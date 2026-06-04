import io
import json

import numpy as np
import pandas as pd
from datetime import datetime
from flask import (
    Blueprint, render_template, request, redirect,
    url_for, flash, jsonify, send_file, current_app,
)

from app import db
from app.models import (
    Patient, Session, Measurement, Alert, ECGSample, WaveformSample,
    SessionAssessment, TherapyRecommendation,
    SessionFeatureSnapshot, SessionForecastSnapshot,
)
from app.processing import analyze_session, detect_session_alerts
from app.simulator import generate_session_data
from app.ai import build_ai_assessment, build_therapy_plan_from_persisted
from app.devices import DEVICE_PROFILES, DEFAULT_DEVICE_KEY, get_device_label
from app.public_datasets import (
    available_public_datasets,
    import_bidmc_vitals_session,
    import_mitdb_session,
)
from app.pdf_reports import build_patient_timeline_pdf, build_session_report_pdf
from app.import_jobs import create_import_job, get_import_job
from app.patient_profiles import build_patient_profile_map, infer_patient_profile

main = Blueprint('main', __name__)


SIMULATION_DEVICE_PROFILES = {
    key: value for key, value in DEVICE_PROFILES.items()
    if value.get('category') != 'public-dataset'
}


# ── Helpers ───────────────────────────────────────────────────────────────────

def _process_alerts(session_obj, measurements):
    """Run contextual anomaly detection and persist episode-level alerts."""
    for a in detect_session_alerts(measurements):
        db.session.add(Alert(
            measurement_id=a.get('measurement_id'),
            session_id=session_obj.id,
            timestamp=a['timestamp'],
            type=a['type'],
            severity=a['severity'],
            message=a['message'],
        ))


def _serialize_assessment(assessment):
    feature_snapshot = assessment.feature_snapshot
    forecast_snapshot = assessment.forecast_snapshot
    therapy_items = [
        {
            'title': item.title,
            'category': item.category,
            'details': item.details,
        }
        for item in sorted(assessment.therapy_recommendations, key=lambda rec: rec.sort_order)
    ]
    persisted_metrics = {
        'hr_mean': feature_snapshot.hr_mean if feature_snapshot else None,
        'hr_std': feature_snapshot.hr_std if feature_snapshot else None,
        'spo2_mean': feature_snapshot.spo2_mean if feature_snapshot else None,
        'spo2_min': feature_snapshot.spo2_min if feature_snapshot else None,
        'temp_mean': feature_snapshot.temp_mean if feature_snapshot else None,
        'temp_max': feature_snapshot.temp_max if feature_snapshot else None,
        'activity_mean': feature_snapshot.activity_mean if feature_snapshot else None,
    }
    persisted_features = {
        'hr_mean': float(feature_snapshot.hr_mean or 0.0) if feature_snapshot else 0.0,
        'hr_std': float(feature_snapshot.hr_std or 0.0) if feature_snapshot else 0.0,
        'spo2_mean': float(feature_snapshot.spo2_mean or 0.0) if feature_snapshot else 0.0,
        'spo2_min': float(feature_snapshot.spo2_min or 0.0) if feature_snapshot else 0.0,
        'temp_mean': float(feature_snapshot.temp_mean or 0.0) if feature_snapshot else 0.0,
        'temp_max': float(feature_snapshot.temp_max or 0.0) if feature_snapshot else 0.0,
        'activity_mean': float(feature_snapshot.activity_mean or 0.0) if feature_snapshot else 0.0,
        'critical_alerts': float(feature_snapshot.critical_alerts or 0.0) if feature_snapshot else 0.0,
        'warning_alerts': float(feature_snapshot.warning_alerts or 0.0) if feature_snapshot else 0.0,
        'n_measurements': float(feature_snapshot.n_measurements or 0.0) if feature_snapshot else 0.0,
    }
    therapy_plan = build_therapy_plan_from_persisted(
        assessment.diagnosis_label,
        assessment.risk_level,
        persisted_metrics,
        assessment.trend_prediction or {},
        therapy_items,
        persisted_features,
    ) if therapy_items else {'items': [], 'expected_outcome': assessment.therapy_expected_outcome}
    return {
        'label': assessment.diagnosis_label,
        'confidence': assessment.diagnosis_confidence,
        'risk_level': assessment.risk_level,
        'rationale': assessment.rationale or [],
        'forecast': assessment.forecast or {},
        'history_delta': assessment.history_delta or {},
        'trend_prediction': assessment.trend_prediction or {},
        'therapy_plan': therapy_plan,
        'metrics': {
            'history_sessions': (assessment.trend_prediction or {}).get('history_sessions', 0),
        },
        'audit_features': {
            'hr_mean': feature_snapshot.hr_mean,
            'hr_std': feature_snapshot.hr_std,
            'hr_max': feature_snapshot.hr_max,
            'spo2_mean': feature_snapshot.spo2_mean,
            'spo2_min': feature_snapshot.spo2_min,
            'temp_mean': feature_snapshot.temp_mean,
            'temp_max': feature_snapshot.temp_max,
            'activity_mean': feature_snapshot.activity_mean,
            'warning_alerts': feature_snapshot.warning_alerts,
            'critical_alerts': feature_snapshot.critical_alerts,
            'n_measurements': feature_snapshot.n_measurements,
            'clinical_risk_score': feature_snapshot.clinical_risk_score,
            'history_sessions': feature_snapshot.history_sessions,
            'model_name': feature_snapshot.model_name,
        } if feature_snapshot else {},
        'audit_forecast': {
            'window_minutes': forecast_snapshot.window_minutes,
            'forecast_risk': forecast_snapshot.forecast_risk,
            'heart_rate': forecast_snapshot.heart_rate,
            'spo2': forecast_snapshot.spo2,
            'temperature': forecast_snapshot.temperature,
            'heart_rate_slope': forecast_snapshot.heart_rate_slope,
            'spo2_slope': forecast_snapshot.spo2_slope,
            'temperature_slope': forecast_snapshot.temperature_slope,
            'model_name': forecast_snapshot.model_name,
        } if forecast_snapshot else {},
    }


def _persist_audit_snapshots(session_obj, assessment, ai_assessment):
    if session_obj.feature_snapshot is not None:
        db.session.delete(session_obj.feature_snapshot)
        db.session.flush()
    if session_obj.forecast_snapshot is not None:
        db.session.delete(session_obj.forecast_snapshot)
        db.session.flush()

    feature_payload = ai_assessment.get('audit_features', {})
    forecast_payload = ai_assessment.get('audit_forecast', {})

    db.session.add(SessionFeatureSnapshot(
        session_id=session_obj.id,
        assessment_id=assessment.id,
        hr_mean=feature_payload.get('hr_mean'),
        hr_std=feature_payload.get('hr_std'),
        hr_max=feature_payload.get('hr_max'),
        spo2_mean=feature_payload.get('spo2_mean'),
        spo2_min=feature_payload.get('spo2_min'),
        temp_mean=feature_payload.get('temp_mean'),
        temp_max=feature_payload.get('temp_max'),
        activity_mean=feature_payload.get('activity_mean'),
        warning_alerts=feature_payload.get('warning_alerts', 0.0),
        critical_alerts=feature_payload.get('critical_alerts', 0.0),
        n_measurements=feature_payload.get('n_measurements', 0.0),
        clinical_risk_score=feature_payload.get('clinical_risk_score', 0.0),
        history_sessions=feature_payload.get('history_sessions', 0),
        model_name=feature_payload.get('model_name', 'clinical-feature extractor'),
    ))
    db.session.add(SessionForecastSnapshot(
        session_id=session_obj.id,
        assessment_id=assessment.id,
        window_minutes=forecast_payload.get('window_minutes', 30),
        forecast_risk=forecast_payload.get('forecast_risk', ai_assessment.get('risk_level', 'low')),
        heart_rate=forecast_payload.get('heart_rate'),
        spo2=forecast_payload.get('spo2'),
        temperature=forecast_payload.get('temperature'),
        heart_rate_slope=forecast_payload.get('heart_rate_slope', 0.0),
        spo2_slope=forecast_payload.get('spo2_slope', 0.0),
        temperature_slope=forecast_payload.get('temperature_slope', 0.0),
        model_name=forecast_payload.get('model_name', 'linear-short-term forecast'),
    ))



def _build_and_persist_assessment(session_obj, measurements):
    alerts = list(session_obj.alerts)
    historical_sessions = (
        Session.query
        .filter(
            Session.patient_id == session_obj.patient_id,
            Session.id != session_obj.id,
            Session.start_time < session_obj.start_time,
        )
        .order_by(Session.start_time.desc())
        .limit(8)
        .all()
    )
    ai_assessment = build_ai_assessment(
        session_obj.patient,
        session_obj,
        measurements,
        historical_sessions,
        alerts=alerts,
    )

    if session_obj.assessment is not None:
        db.session.delete(session_obj.assessment)
        db.session.flush()

    trend_payload = dict(ai_assessment['trend_prediction'])
    trend_payload['history_sessions'] = ai_assessment['metrics'].get('history_sessions', 0)

    assessment = SessionAssessment(
        session_id=session_obj.id,
        diagnosis_label=ai_assessment['label'],
        diagnosis_confidence=ai_assessment['confidence'],
        risk_level=ai_assessment['risk_level'],
        rationale=ai_assessment['rationale'],
        forecast=ai_assessment['forecast'],
        history_delta=ai_assessment['history_delta'],
        trend_prediction=trend_payload,
        therapy_expected_outcome=ai_assessment['therapy_plan']['expected_outcome'],
    )
    db.session.add(assessment)
    db.session.flush()

    for index, item in enumerate(ai_assessment['therapy_plan']['items']):
        db.session.add(TherapyRecommendation(
            assessment_id=assessment.id,
            category=item['category'],
            title=item['title'],
            details=item['details'],
            sort_order=index,
        ))

    _persist_audit_snapshots(session_obj, assessment, ai_assessment)
    return ai_assessment


# ── Dashboard ─────────────────────────────────────────────────────────────────

@main.route('/')
def index():
    stats = {
        'n_patients':    Patient.query.count(),
        'n_sessions':    Session.query.count(),
        'n_alerts':      Alert.query.count(),
        'n_critical':    Alert.query.filter_by(severity='critical').count(),
    }
    recent_alerts = (
        Alert.query.order_by(Alert.timestamp.desc()).limit(8).all()
    )
    recent_sessions = (
        Session.query.order_by(Session.start_time.desc()).limit(6).all()
    )
    device_usage = {}
    for session_obj in Session.query.all():
        label = get_device_label(session_obj.device_id)
        device_usage[label] = device_usage.get(label, 0) + 1
    return render_template(
        'index.html',
        **stats,
        recent_alerts=recent_alerts,
        recent_sessions=recent_sessions,
        device_usage=device_usage,
        get_device_label=get_device_label,
    )


# ── Patients ──────────────────────────────────────────────────────────────────

@main.route('/patients')
def patients():
    all_patients = Patient.query.order_by(Patient.name).all()
    return render_template('patients.html', patients=all_patients)


@main.route('/patients/add', methods=['GET', 'POST'])
def add_patient():
    if request.method == 'POST':
        name = request.form.get('name', '').strip()
        if not name:
            flash('Il nome è obbligatorio.', 'danger')
            return redirect(url_for('main.add_patient'))

        try:
            patient = Patient(
                name=name,
                age=int(request.form['age']) if request.form.get('age') else None,
                gender=request.form.get('gender') or None,
                weight_kg=float(request.form['weight_kg']) if request.form.get('weight_kg') else None,
                height_cm=float(request.form['height_cm']) if request.form.get('height_cm') else None,
                notes=request.form.get('notes') or None,
            )
            db.session.add(patient)
            db.session.commit()
            flash(f'Paziente "{name}" aggiunto.', 'success')
            return redirect(url_for('main.patient_detail', patient_id=patient.id))
        except (ValueError, KeyError) as exc:
            db.session.rollback()
            flash(f'Errore nei dati inseriti: {exc}', 'danger')
            return redirect(url_for('main.add_patient'))

    return render_template('add_patient.html')


@main.route('/patients/<int:patient_id>')
def patient_detail(patient_id):
    patient = Patient.query.get_or_404(patient_id)
    sessions = (
        Session.query
        .filter_by(patient_id=patient_id)
        .order_by(Session.start_time.desc())
        .all()
    )
    return render_template(
        'patient_detail.html',
        patient=patient,
        sessions=sessions,
        get_device_label=get_device_label,
    )


@main.route('/patients/<int:patient_id>/timeline')
def patient_timeline(patient_id):
    patient = Patient.query.get_or_404(patient_id)
    sessions = (
        Session.query
        .filter_by(patient_id=patient_id)
        .order_by(Session.start_time)
        .all()
    )

    timeline_rows = []
    changed = False
    for session_obj in sessions:
        ordered_measurements = sorted(session_obj.measurements, key=lambda item: item.timestamp)
        if session_obj.assessment is None and ordered_measurements:
            _build_and_persist_assessment(session_obj, ordered_measurements)
            changed = True
        assessment = session_obj.assessment
        timeline_rows.append({
            'session_id': session_obj.id,
            'timestamp': session_obj.start_time.strftime('%Y-%m-%dT%H:%M:%S'),
            'device_label': get_device_label(session_obj.device_id),
            'duration_minutes': session_obj.duration_minutes or 0,
            'diagnosis_label': assessment.diagnosis_label if assessment else 'n/d',
            'diagnosis_confidence': assessment.diagnosis_confidence if assessment else 0,
            'risk_level': assessment.risk_level if assessment else 'low',
            'trend_label': (assessment.trend_prediction or {}).get('label', 'n/d') if assessment else 'n/d',
            'trend_confidence': (assessment.trend_prediction or {}).get('confidence', 0) if assessment else 0,
            'alert_count': session_obj.n_alerts,
            'critical_alert_count': sum(1 for alert in session_obj.alerts if alert.severity == 'critical'),
            'forecast_hr': (assessment.forecast or {}).get('heart_rate') if assessment else None,
            'forecast_spo2': (assessment.forecast or {}).get('spo2') if assessment else None,
            'forecast_temp': (assessment.forecast or {}).get('temperature') if assessment else None,
            'expected_outcome': assessment.therapy_expected_outcome if assessment else None,
        })

    if changed:
        db.session.commit()

    return render_template(
        'patient_timeline.html',
        patient=patient,
        sessions=sessions,
        timeline_json=json.dumps(timeline_rows),
        get_device_label=get_device_label,
    )


@main.route('/patients/<int:patient_id>/timeline.pdf')
def patient_timeline_pdf(patient_id):
    patient = Patient.query.get_or_404(patient_id)
    sessions = (
        Session.query
        .filter_by(patient_id=patient_id)
        .order_by(Session.start_time)
        .all()
    )
    timeline_rows = []
    changed = False
    for session_obj in sessions:
        ordered_measurements = sorted(session_obj.measurements, key=lambda item: item.timestamp)
        if session_obj.assessment is None and ordered_measurements:
            _build_and_persist_assessment(session_obj, ordered_measurements)
            changed = True
        assessment = session_obj.assessment
        timeline_rows.append({
            'session_id': session_obj.id,
            'timestamp': session_obj.start_time.strftime('%Y-%m-%dT%H:%M:%S'),
            'diagnosis_label': assessment.diagnosis_label if assessment else 'n/d',
            'trend_label': (assessment.trend_prediction or {}).get('label', 'n/d') if assessment else 'n/d',
            'alert_count': session_obj.n_alerts,
            'expected_outcome': assessment.therapy_expected_outcome if assessment else None,
        })
    if changed:
        db.session.commit()

    pdf_buffer = build_patient_timeline_pdf(patient, sessions, timeline_rows)
    return send_file(
        pdf_buffer,
        mimetype='application/pdf',
        as_attachment=True,
        download_name=f'timeline-patient-{patient.id}.pdf',
    )


@main.route('/patients/<int:patient_id>/delete', methods=['POST'])
def delete_patient(patient_id):
    patient = Patient.query.get_or_404(patient_id)
    name = patient.name
    db.session.delete(patient)
    db.session.commit()
    flash(f'Paziente "{name}" eliminato.', 'success')
    return redirect(url_for('main.patients'))


# ── Sessions ──────────────────────────────────────────────────────────────────

@main.route('/sessions/<int:session_id>')
def session_detail(session_id):
    sess = Session.query.get_or_404(session_id)
    measurements = (
        Measurement.query
        .filter_by(session_id=session_id)
        .order_by(Measurement.timestamp)
        .all()
    )
    alerts = (
        Alert.query
        .filter_by(session_id=session_id)
        .order_by(Alert.timestamp)
        .all()
    )
    analysis = analyze_session(measurements)
    if sess.assessment is None:
        ai_assessment = _build_and_persist_assessment(sess, measurements)
        db.session.commit()
    else:
        ai_assessment = _serialize_assessment(sess.assessment)
    return render_template(
        'session_analysis.html',
        sess=sess,
        measurements=measurements,
        alerts=alerts,
        analysis_json=json.dumps(analysis),
        ai_assessment=ai_assessment,
        n_critical=sum(1 for a in alerts if a.severity == 'critical'),
        n_warning=sum(1 for a in alerts if a.severity == 'warning'),
        get_device_label=get_device_label,
    )


@main.route('/sessions/<int:session_id>/report.pdf')
def session_report_pdf(session_id):
    sess = Session.query.get_or_404(session_id)
    measurements = (
        Measurement.query
        .filter_by(session_id=session_id)
        .order_by(Measurement.timestamp)
        .all()
    )
    alerts = (
        Alert.query
        .filter_by(session_id=session_id)
        .order_by(Alert.timestamp)
        .all()
    )
    if sess.assessment is None and measurements:
        ai_assessment = _build_and_persist_assessment(sess, measurements)
        db.session.commit()
    else:
        ai_assessment = _serialize_assessment(sess.assessment)

    pdf_buffer = build_session_report_pdf(sess, ai_assessment, alerts)
    return send_file(
        pdf_buffer,
        mimetype='application/pdf',
        as_attachment=True,
        download_name=f'session-report-{sess.id}.pdf',
    )


@main.route('/sessions/<int:session_id>/delete', methods=['POST'])
def delete_session(session_id):
    sess = Session.query.get_or_404(session_id)
    pid = sess.patient_id
    db.session.delete(sess)
    db.session.commit()
    flash('Sessione eliminata.', 'success')
    return redirect(url_for('main.patient_detail', patient_id=pid))


# ── Simulate ──────────────────────────────────────────────────────────────────

@main.route('/simulate', methods=['GET', 'POST'])
def simulate():
    all_patients = Patient.query.order_by(Patient.name).all()
    device_profiles = SIMULATION_DEVICE_PROFILES
    patient_profiles = build_patient_profile_map(all_patients)

    if request.method == 'POST':
        patient_id = request.form.get('patient_id')
        if not patient_id:
            flash('Seleziona un paziente.', 'danger')
            return redirect(url_for('main.simulate'))

        duration = int(request.form.get('duration', 60))
        interval = int(request.form.get('interval', 10))
        scenario = request.form.get('scenario', 'normal')
        device_id = request.form.get('device_id', DEFAULT_DEVICE_KEY).strip() or DEFAULT_DEVICE_KEY

        patient = Patient.query.get_or_404(int(patient_id))
        profile = infer_patient_profile(patient)
        if scenario not in profile['allowed_scenarios']:
            flash(
                f'Scenario "{scenario}" non coerente con il profilo clinico di {patient.name}. '
                f'Usato scenario consigliato: {profile["default_scenario"]}.',
                'warning',
            )
            scenario = profile['default_scenario']
        if device_id not in SIMULATION_DEVICE_PROFILES:
            device_id = DEFAULT_DEVICE_KEY
        data = generate_session_data(
            duration_minutes=duration,
            sampling_interval_seconds=interval,
            patient_age=patient.age,
            scenario=scenario,
            device_key=device_id,
            patient_profile=profile['key'],
        )

        sess = Session(
            patient_id=patient.id,
            device_id=device_id,
            source_type='synthetic',
            source_name=f'simulation:{scenario}',
            start_time=data[0]['timestamp'],
            end_time=data[-1]['timestamp'],
            notes=f'Sessione simulata — scenario: {scenario} · profilo clinico: {profile["label"]}',
        )
        db.session.add(sess)
        db.session.flush()

        measurements = []
        for row in data:
            m = Measurement(
                session_id=sess.id,
                timestamp=row['timestamp'],
                heart_rate=row['heart_rate'],
                spo2=row['spo2'],
                temperature=row['temperature'],
                activity_level=row['activity_level'],
            )
            db.session.add(m)
            measurements.append(m)
        db.session.flush()

        _process_alerts(sess, measurements)
        db.session.flush()
        _build_and_persist_assessment(sess, measurements)
        db.session.commit()

        flash(
            f'Sessione creata con {len(data)} misurazioni '
            f'({sess.n_alerts} alert rilevati).',
            'success',
        )
        return redirect(url_for('main.session_detail', session_id=sess.id))

    return render_template(
        'simulate.html',
        patients=all_patients,
        device_profiles=device_profiles,
        default_device_key=DEFAULT_DEVICE_KEY,
        patient_profiles=patient_profiles,
    )


# ── Upload CSV ────────────────────────────────────────────────────────────────

@main.route('/upload', methods=['GET', 'POST'])
def upload():
    all_patients = Patient.query.order_by(Patient.name).all()

    if request.method == 'POST':
        patient_id = request.form.get('patient_id')
        file = request.files.get('file')

        if not patient_id or not file or not file.filename:
            flash('Seleziona un paziente e un file CSV.', 'danger')
            return redirect(url_for('main.upload'))

        if not file.filename.lower().endswith('.csv'):
            flash('Il file deve essere in formato CSV.', 'danger')
            return redirect(url_for('main.upload'))

        patient = Patient.query.get_or_404(int(patient_id))

        try:
            raw = file.stream.read().decode('utf-8', errors='replace')
            df = pd.read_csv(io.StringIO(raw))
            df.columns = [c.strip().lower().replace(' ', '_') for c in df.columns]

            # Auto-detect timestamp column
            ts_col = next(
                (c for c in df.columns if any(k in c for k in ('time', 'date', 'ts', 'stamp'))),
                None,
            )
            if ts_col:
                df['_ts'] = pd.to_datetime(df[ts_col], errors='coerce')
            else:
                df['_ts'] = pd.date_range(
                    start=datetime.utcnow(), periods=len(df), freq='10s'
                )

            def _find(candidates):
                return next((c for c in candidates if c in df.columns), None)

            hr_col   = _find(['heart_rate', 'hr', 'bpm', 'pulse'])
            spo2_col = _find(['spo2', 'oxygen', 'o2', 'saturation', 'spo₂'])
            temp_col = _find(['temperature', 'temp', 'body_temp'])
            act_col  = _find(['activity', 'activity_level', 'steps', 'accel'])

            sess = Session(
                patient_id=patient.id,
                device_id=request.form.get('device_id', DEFAULT_DEVICE_KEY).strip() or DEFAULT_DEVICE_KEY,
                source_type='csv',
                source_name=file.filename,
                start_time=df['_ts'].min().to_pydatetime(),
                end_time=df['_ts'].max().to_pydatetime(),
                notes=f'Importato da file: {file.filename}',
            )
            db.session.add(sess)
            db.session.flush()

            def _safe_float(row, col):
                if col is None:
                    return None
                val = row.get(col)
                try:
                    return None if pd.isna(val) else float(val)
                except (TypeError, ValueError):
                    return None

            measurements = []
            for _, row in df.iterrows():
                m = Measurement(
                    session_id=sess.id,
                    timestamp=row['_ts'].to_pydatetime(),
                    heart_rate=_safe_float(row, hr_col),
                    spo2=_safe_float(row, spo2_col),
                    temperature=_safe_float(row, temp_col),
                    activity_level=_safe_float(row, act_col),
                )
                db.session.add(m)
                measurements.append(m)
            db.session.flush()

            _process_alerts(sess, measurements)
            db.session.flush()
            _build_and_persist_assessment(sess, measurements)
            db.session.commit()

            flash(
                f'File importato: {len(measurements)} misurazioni '
                f'({sess.n_alerts} alert rilevati).',
                'success',
            )
            return redirect(url_for('main.session_detail', session_id=sess.id))

        except Exception as exc:
            db.session.rollback()
            flash(f'Errore durante l\'importazione: {exc}', 'danger')
            return redirect(url_for('main.upload'))

    return render_template(
        'upload.html',
        patients=all_patients,
        device_profiles=SIMULATION_DEVICE_PROFILES,
        default_device_key=DEFAULT_DEVICE_KEY,
    )


@main.route('/datasets/public', methods=['GET', 'POST'])
def public_datasets():
    all_patients = Patient.query.order_by(Patient.name).all()
    datasets = available_public_datasets()

    if request.method == 'POST':
        patient_id = request.form.get('patient_id')
        dataset_key = request.form.get('dataset_key', 'mitdb')
        record_name = request.form.get('record_name', '100')
        duration_seconds = int(request.form.get('duration_seconds', 30))

        if not patient_id:
            flash('Seleziona un paziente per l\'importazione del dataset pubblico.', 'danger')
            return redirect(url_for('main.public_datasets'))

        patient = Patient.query.get_or_404(int(patient_id))

        try:
            if dataset_key == 'mitdb':
                dataset_session = import_mitdb_session(record_name=record_name, duration_seconds=duration_seconds)
            elif dataset_key == 'bidmc':
                dataset_session = import_bidmc_vitals_session(record_name=record_name, duration_seconds=duration_seconds)
            else:
                raise ValueError('Dataset pubblico non supportato.')

            sess = Session(
                patient_id=patient.id,
                device_id=dataset_session['device_id'],
                source_type=dataset_session['source_type'],
                source_name=dataset_session['source_name'],
                start_time=dataset_session['start_time'],
                end_time=dataset_session['end_time'],
                notes=dataset_session['notes'],
            )
            db.session.add(sess)
            db.session.flush()

            measurements = []
            for row in dataset_session['measurements']:
                measurement = Measurement(
                    session_id=sess.id,
                    timestamp=row['timestamp'],
                    heart_rate=row['heart_rate'],
                    spo2=row['spo2'],
                    temperature=row['temperature'],
                    activity_level=row['activity_level'],
                )
                db.session.add(measurement)
                measurements.append(measurement)
            db.session.flush()

            for sample in dataset_session['ecg_samples']:
                db.session.add(ECGSample(
                    session_id=sess.id,
                    sample_index=sample['sample_index'],
                    offset_seconds=sample['offset_seconds'],
                    value=sample['value'],
                ))

            for sample in dataset_session.get('waveform_samples', []):
                db.session.add(WaveformSample(
                    session_id=sess.id,
                    signal_type=sample['signal_type'],
                    sample_index=sample['sample_index'],
                    offset_seconds=sample['offset_seconds'],
                    value=sample['value'],
                    sampling_hz=sample.get('sampling_hz'),
                    unit=sample.get('unit'),
                ))

            _process_alerts(sess, measurements)
            db.session.flush()
            _build_and_persist_assessment(sess, measurements)
            db.session.commit()

            waveform_suffix = ''
            if dataset_session['ecg_samples']:
                waveform_suffix = f", {len(dataset_session['ecg_samples'])} campioni waveform"
            elif dataset_session.get('waveform_samples'):
                waveform_suffix = f", {len(dataset_session['waveform_samples'])} campioni PPG/resp"
            flash(
                f'Dataset pubblico importato: {dataset_session["dataset_label"]} '
                f'({len(measurements)} misurazioni{waveform_suffix}).',
                'success',
            )
            return redirect(url_for('main.session_detail', session_id=sess.id))
        except Exception as exc:
            db.session.rollback()
            flash(f'Errore importando il dataset pubblico: {exc}', 'danger')
            return redirect(url_for('main.public_datasets'))

    return render_template(
        'public_datasets.html',
        patients=all_patients,
        datasets=datasets,
    )


@main.route('/api/datasets/public/import-jobs', methods=['POST'])
def api_create_public_dataset_job():
    payload = request.get_json(silent=True) or {}
    patient_id = payload.get('patient_id')
    dataset_key = payload.get('dataset_key', 'mitdb')
    record_name = payload.get('record_name', '100')
    duration_seconds = int(payload.get('duration_seconds', 60))

    if not patient_id:
        return jsonify({'error': 'Seleziona un paziente.'}), 400

    Patient.query.get_or_404(int(patient_id))
    job_id = create_import_job(
        current_app._get_current_object(),
        int(patient_id),
        dataset_key,
        record_name,
        duration_seconds,
    )
    return jsonify({'job_id': job_id}), 202


@main.route('/api/datasets/public/import-jobs/<job_id>')
def api_public_dataset_job_status(job_id):
    job = get_import_job(job_id)
    if job is None:
        return jsonify({'error': 'Job non trovato.'}), 404

    return jsonify({
        'id': job['id'],
        'status': job['status'],
        'progress': job['progress'],
        'message': job['message'],
        'session_id': job.get('session_id'),
        'error': job.get('error'),
        'redirect_url': url_for('main.session_detail', session_id=job['session_id']) if job.get('session_id') else None,
    })


# ── REST API ──────────────────────────────────────────────────────────────────

@main.route('/api/session/<int:session_id>/data')
def api_session_data(session_id):
    measurements = (
        Measurement.query
        .filter_by(session_id=session_id)
        .order_by(Measurement.timestamp)
        .all()
    )
    return jsonify([
        {
            'timestamp':      m.timestamp.isoformat(),
            'heart_rate':     m.heart_rate,
            'spo2':           m.spo2,
            'temperature':    m.temperature,
            'activity_level': m.activity_level,
        }
        for m in measurements
    ])


@main.route('/api/stats')
def api_stats():
    return jsonify({
        'patients':       Patient.query.count(),
        'sessions':       Session.query.count(),
        'measurements':   Measurement.query.count(),
        'alerts':         Alert.query.count(),
        'critical_alerts': Alert.query.filter_by(severity='critical').count(),
    })
