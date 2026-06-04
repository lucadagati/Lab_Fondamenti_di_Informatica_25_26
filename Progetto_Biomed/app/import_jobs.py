import threading
import time
import uuid

from app import db
from app.models import Session, Measurement, ECGSample, WaveformSample, Patient
from app.public_datasets import import_bidmc_vitals_session, import_mitdb_session


_JOBS = {}
_JOBS_LOCK = threading.Lock()


def _update_job(job_id, **changes):
    with _JOBS_LOCK:
        job = _JOBS.get(job_id)
        if job is None:
            return
        job.update(changes)
        job['updated_at'] = time.time()


def get_import_job(job_id):
    with _JOBS_LOCK:
        job = _JOBS.get(job_id)
        return dict(job) if job else None


def create_import_job(app, patient_id, dataset_key, record_name, duration_seconds):
    job_id = uuid.uuid4().hex
    with _JOBS_LOCK:
        _JOBS[job_id] = {
            'id': job_id,
            'status': 'queued',
            'progress': 0,
            'message': 'Job in coda',
            'dataset_key': dataset_key,
            'record_name': record_name,
            'duration_seconds': int(duration_seconds),
            'patient_id': int(patient_id),
            'created_at': time.time(),
            'updated_at': time.time(),
            'session_id': None,
            'error': None,
        }

    thread = threading.Thread(
        target=_run_import_job,
        args=(app, job_id),
        daemon=True,
    )
    thread.start()
    return job_id


def _persist_dataset_session(dataset_session, patient_id):
    from app.routes import _process_alerts, _build_and_persist_assessment

    sess = Session(
        patient_id=patient_id,
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
    return sess.id


def _run_import_job(app, job_id):
    with app.app_context():
        job = get_import_job(job_id)
        if job is None:
            return

        try:
            patient = Patient.query.get(job['patient_id'])
            if patient is None:
                raise RuntimeError('Paziente non trovato.')

            def progress_callback(progress, message):
                _update_job(job_id, status='running', progress=int(progress), message=message)

            progress_callback(3, 'Connessione al dataset remoto')
            if job['dataset_key'] == 'mitdb':
                dataset_session = import_mitdb_session(
                    record_name=job['record_name'],
                    duration_seconds=job['duration_seconds'],
                    progress_callback=progress_callback,
                )
            elif job['dataset_key'] == 'bidmc':
                dataset_session = import_bidmc_vitals_session(
                    record_name=job['record_name'],
                    duration_seconds=job['duration_seconds'],
                    progress_callback=progress_callback,
                )
            else:
                raise RuntimeError('Dataset pubblico non supportato.')

            progress_callback(90, 'Persistenza della sessione e valutazione ML')
            session_id = _persist_dataset_session(dataset_session, patient.id)
            _update_job(
                job_id,
                status='completed',
                progress=100,
                message='Import completato',
                session_id=session_id,
            )
        except Exception as exc:
            db.session.rollback()
            _update_job(
                job_id,
                status='failed',
                progress=100,
                message='Import fallito',
                error=str(exc),
            )
