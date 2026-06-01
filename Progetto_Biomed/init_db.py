"""
init_db.py — Inizializza il database e aggiunge dati di esempio.

Uso:
    python init_db.py
"""

import random

from app import create_app, db
from app.models import (
    Patient, Session, Measurement, Alert, ECGSample,
    SessionAssessment, TherapyRecommendation,
    SessionFeatureSnapshot, SessionForecastSnapshot,
)
from app.ai import build_ai_assessment
from app.simulator import generate_session_data
from app.processing import detect_session_alerts
from app.devices import DEVICE_PROFILES
from app.public_datasets import import_bidmc_vitals_session, import_mitdb_session


def _store_alerts(session_obj, measurements):
    for a in detect_session_alerts(measurements):
        db.session.add(Alert(
            measurement_id=a.get('measurement_id'),
                session_id=session_obj.id,
                timestamp=a['timestamp'],
                type=a['type'],
                severity=a['severity'],
                message=a['message'],
            ))


def _store_assessment(session_obj, measurements):
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
        alerts=list(session_obj.alerts),
    )
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


def main():
    app = create_app()
    with app.app_context():
        db.drop_all()
        db.create_all()
        print("Tabelle create.")

        rng = random.Random(42)

        # ── Pazienti di esempio ───────────────────────────────────────────
        patient_specs = [
            ('Mario Rossi', 52, 'M', 82, 176, 'Ipertensione lieve, in terapia'),
            ('Laura Bianchi', 67, 'F', 63, 160, 'Diabete tipo 2, follow-up domiciliare'),
            ('Giuseppe Verdi', 34, 'M', 78, 183, 'Maratoneta amatoriale'),
            ('Anna Ferrari', 45, 'F', 59, 165, 'Telemonitoraggio post dimissione'),
            ('Luca Romano', 71, 'M', 85, 174, 'BPCO moderata'),
            ('Elisa Conti', 29, 'F', 57, 168, 'Stress e palpitazioni episodiche'),
            ('Franco Ricci', 63, 'M', 91, 171, 'Scompenso lieve compensato'),
            ('Silvia Galli', 56, 'F', 68, 162, 'Follow-up post COVID'),
            ('Davide Serra', 39, 'M', 75, 179, 'Attività fisica intensa'),
            ('Marta Greco', 48, 'F', 62, 166, 'Rischio metabolico'),
            ('Paolo Leone', 58, 'M', 88, 177, 'Ipertensione e obesità'),
            ('Giulia Fontana', 31, 'F', 54, 164, 'Nessuna comorbidità rilevante'),
            ('Riccardo Neri', 74, 'M', 80, 170, 'Fragilità geriatrica'),
            ('Teresa Lombardi', 69, 'F', 61, 158, 'Telemonitoraggio notturno'),
            ('Federico Riva', 42, 'M', 83, 181, 'Sintomi compatibili con aritmia parossistica'),
            ('Sara Villa', 36, 'F', 60, 169, 'Anamnesi respiratoria lieve'),
            ('Claudio De Santis', 65, 'M', 86, 172, 'Cardiopatia ischemica stabilizzata'),
            ('Irene Bellini', 27, 'F', 55, 167, 'Atleta con monitoraggio recupero'),
        ]
        patients = [
            Patient(
                name=name,
                age=age,
                gender=gender,
                weight_kg=weight,
                height_cm=height,
                notes=notes,
            )
            for name, age, gender, weight, height, notes in patient_specs
        ]
        for p in patients:
            db.session.add(p)
        db.session.commit()
        print(f"Pazienti creati: {len(patients)}")

        # ── Sessioni di esempio ───────────────────────────────────────────
        profile_map = {
            'stable': ['normal', 'normal', 'stress'],
            'sleep': ['sleep', 'normal', 'sleep'],
            'respiratory': ['normal', 'sleep', 'stress'],
            'arrhythmic': ['normal', 'arrhythmia', 'stress'],
            'athlete': ['exercise', 'normal', 'exercise'],
            'mixed': ['normal', 'stress', 'exercise'],
        }
        patient_groups = [
            'arrhythmic', 'sleep', 'athlete', 'stable', 'respiratory', 'mixed',
            'stable', 'respiratory', 'athlete', 'mixed', 'stable', 'stable',
            'sleep', 'sleep', 'arrhythmic', 'respiratory', 'stable', 'athlete',
        ]
        device_keys = [
            key for key, profile in DEVICE_PROFILES.items()
            if profile.get('category') != 'public-dataset'
        ]

        sessions_spec = []
        for index, patient in enumerate(patients):
            group = patient_groups[index]
            scenarios = profile_map[group]
            for j, scenario in enumerate(scenarios):
                duration = rng.choice([20, 30, 45, 60, 90])
                interval = rng.choice([5, 10, 30]) if scenario in ('exercise', 'arrhythmia') else rng.choice([10, 30])
                device_key = device_keys[(index + j) % len(device_keys)]
                sessions_spec.append((patient, scenario, duration, interval, device_key))

        total_meas = 0
        total_alerts = 0
        for patient, scenario, duration, interval, device_key in sessions_spec:
            data = generate_session_data(
                duration_minutes=duration,
                sampling_interval_seconds=interval,
                patient_age=patient.age,
                scenario=scenario,
                device_key=device_key,
            )
            sess = Session(
                patient_id=patient.id,
                device_id=device_key,
                source_type='synthetic',
                source_name=f'demo:{scenario}',
                start_time=data[0]['timestamp'],
                end_time=data[-1]['timestamp'],
                notes=f'Sessione demo longitudinale — scenario: {scenario}',
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

            _store_alerts(sess, measurements)
            db.session.flush()
            _store_assessment(sess, measurements)
            db.session.commit()

            total_meas += len(measurements)
            total_alerts += sess.n_alerts
            print(f"  {patient.name:20s} | {scenario:12s} | {device_key:16s} | "
                f"{len(measurements):4d} mis. | {sess.n_alerts} alert")

        public_records = [('100', patients[0]), ('119', patients[14])]
        for record_name, patient in public_records:
            try:
                dataset_session = import_mitdb_session(record_name=record_name, duration_seconds=30)
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

                for sample in dataset_session['ecg_samples']:
                    db.session.add(ECGSample(
                        session_id=sess.id,
                        sample_index=sample['sample_index'],
                        offset_seconds=sample['offset_seconds'],
                        value=sample['value'],
                    ))

                _store_alerts(sess, measurements)
                db.session.flush()
                _store_assessment(sess, measurements)
                db.session.commit()

                print(f"  {patient.name:20s} | mitdb:{record_name:7s} | physionet_mitdb   | "
                      f"{len(measurements):4d} mis. | {sess.n_alerts} alert")
            except Exception as exc:
                db.session.rollback()
                print(f"  Import MIT-BIH {record_name} saltato: {exc}")

        bidmc_records = [('bidmc01', patients[7]), ('bidmc03', patients[4])]
        for record_name, patient in bidmc_records:
            try:
                dataset_session = import_bidmc_vitals_session(record_name=record_name, duration_seconds=60)
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

                _store_alerts(sess, measurements)
                db.session.flush()
                _store_assessment(sess, measurements)
                db.session.commit()

                print(f"  {patient.name:20s} | bidmc:{record_name:7s} | physionet_bidmc   | "
                      f"{len(measurements):4d} mis. | {sess.n_alerts} alert")
            except Exception as exc:
                db.session.rollback()
                print(f"  Import BIDMC {record_name} saltato: {exc}")

        print(f"\nDatabase pronto.")
        print(f"  Pazienti:    {Patient.query.count()}")
        print(f"  Sessioni:    {Session.query.count()}")
        print(f"  Misurazioni: {Measurement.query.count()}")
        print(f"  Alert:       {Alert.query.count()}"
              f"  (critici: {Alert.query.filter_by(severity='critical').count()})")


if __name__ == '__main__':
    main()
