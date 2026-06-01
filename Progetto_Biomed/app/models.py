from datetime import datetime
from app import db


class Patient(db.Model):
    __tablename__ = 'patients'

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    age = db.Column(db.Integer)
    gender = db.Column(db.String(10))
    weight_kg = db.Column(db.Float)
    height_cm = db.Column(db.Float)
    notes = db.Column(db.Text)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)

    sessions = db.relationship(
        'Session', backref='patient', lazy=True, cascade='all, delete-orphan'
    )

    @property
    def bmi(self):
        if self.weight_kg and self.height_cm and self.height_cm > 0:
            return round(self.weight_kg / ((self.height_cm / 100) ** 2), 1)
        return None

    def __repr__(self):
        return f'<Patient {self.name}>'


class Session(db.Model):
    __tablename__ = 'sessions'

    id = db.Column(db.Integer, primary_key=True)
    patient_id = db.Column(
        db.Integer, db.ForeignKey('patients.id'), nullable=False
    )
    device_id = db.Column(db.String(50), default='WearableSensor-v1')
    source_type = db.Column(db.String(30), default='synthetic')
    source_name = db.Column(db.String(120))
    start_time = db.Column(db.DateTime, nullable=False, default=datetime.utcnow)
    end_time = db.Column(db.DateTime)
    notes = db.Column(db.Text)

    measurements = db.relationship(
        'Measurement', backref='session', lazy=True, cascade='all, delete-orphan'
    )
    alerts = db.relationship(
        'Alert', backref='session', lazy=True, cascade='all, delete-orphan'
    )
    ecg_samples = db.relationship(
        'ECGSample', backref='session', lazy=True, cascade='all, delete-orphan'
    )
    assessment = db.relationship(
        'SessionAssessment', backref='session', uselist=False,
        lazy=True, cascade='all, delete-orphan'
    )
    feature_snapshot = db.relationship(
        'SessionFeatureSnapshot', backref='session', uselist=False,
        lazy=True, cascade='all, delete-orphan'
    )
    forecast_snapshot = db.relationship(
        'SessionForecastSnapshot', backref='session', uselist=False,
        lazy=True, cascade='all, delete-orphan'
    )

    @property
    def duration_minutes(self):
        if self.end_time and self.start_time:
            return round((self.end_time - self.start_time).total_seconds() / 60, 1)
        return None

    @property
    def n_measurements(self):
        return len(self.measurements)

    @property
    def n_alerts(self):
        return len(self.alerts)

    def __repr__(self):
        return f'<Session {self.id}>'


class Measurement(db.Model):
    __tablename__ = 'measurements'

    id = db.Column(db.Integer, primary_key=True)
    session_id = db.Column(
        db.Integer, db.ForeignKey('sessions.id'), nullable=False
    )
    timestamp = db.Column(db.DateTime, nullable=False)
    heart_rate = db.Column(db.Float)
    spo2 = db.Column(db.Float)
    temperature = db.Column(db.Float)
    activity_level = db.Column(db.Float)

    alerts = db.relationship('Alert', backref='measurement', lazy=True)

    def __repr__(self):
        return f'<Measurement {self.id}>'


class Alert(db.Model):
    __tablename__ = 'alerts'

    id = db.Column(db.Integer, primary_key=True)
    measurement_id = db.Column(
        db.Integer, db.ForeignKey('measurements.id'), nullable=True
    )
    session_id = db.Column(
        db.Integer, db.ForeignKey('sessions.id'), nullable=False
    )
    timestamp = db.Column(db.DateTime, nullable=False)
    type = db.Column(db.String(50), nullable=False)
    severity = db.Column(db.String(20), nullable=False)  # 'warning' | 'critical'
    message = db.Column(db.Text)

    def __repr__(self):
        return f'<Alert {self.type} [{self.severity}]>'


class ECGSample(db.Model):
    __tablename__ = 'ecg_samples'

    id = db.Column(db.Integer, primary_key=True)
    session_id = db.Column(
        db.Integer, db.ForeignKey('sessions.id'), nullable=False
    )
    sample_index = db.Column(db.Integer, nullable=False)
    offset_seconds = db.Column(db.Float, nullable=False)
    value = db.Column(db.Float, nullable=False)

    def __repr__(self):
        return f'<ECGSample {self.session_id}:{self.sample_index}>'


class SessionAssessment(db.Model):
    __tablename__ = 'session_assessments'

    id = db.Column(db.Integer, primary_key=True)
    session_id = db.Column(
        db.Integer, db.ForeignKey('sessions.id'), nullable=False, unique=True
    )
    computed_at = db.Column(db.DateTime, nullable=False, default=datetime.utcnow)
    diagnosis_label = db.Column(db.String(80), nullable=False)
    diagnosis_confidence = db.Column(db.Float, nullable=False)
    risk_level = db.Column(db.String(20), nullable=False)
    rationale = db.Column(db.JSON, nullable=False, default=list)
    forecast = db.Column(db.JSON, nullable=False, default=dict)
    history_delta = db.Column(db.JSON, nullable=False, default=dict)
    trend_prediction = db.Column(db.JSON, nullable=False, default=dict)
    therapy_expected_outcome = db.Column(db.Text)

    therapy_recommendations = db.relationship(
        'TherapyRecommendation', backref='assessment', lazy=True,
        cascade='all, delete-orphan'
    )
    feature_snapshot = db.relationship(
        'SessionFeatureSnapshot', backref='assessment', uselist=False,
        lazy=True, cascade='all, delete-orphan'
    )
    forecast_snapshot = db.relationship(
        'SessionForecastSnapshot', backref='assessment', uselist=False,
        lazy=True, cascade='all, delete-orphan'
    )

    def __repr__(self):
        return f'<SessionAssessment {self.session_id} {self.diagnosis_label}>'


class SessionFeatureSnapshot(db.Model):
    __tablename__ = 'session_feature_snapshots'

    id = db.Column(db.Integer, primary_key=True)
    session_id = db.Column(
        db.Integer, db.ForeignKey('sessions.id'), nullable=False, unique=True
    )
    assessment_id = db.Column(
        db.Integer, db.ForeignKey('session_assessments.id'), nullable=False, unique=True
    )
    computed_at = db.Column(db.DateTime, nullable=False, default=datetime.utcnow)
    hr_mean = db.Column(db.Float)
    hr_std = db.Column(db.Float)
    hr_max = db.Column(db.Float)
    spo2_mean = db.Column(db.Float)
    spo2_min = db.Column(db.Float)
    temp_mean = db.Column(db.Float)
    temp_max = db.Column(db.Float)
    activity_mean = db.Column(db.Float)
    warning_alerts = db.Column(db.Float, default=0.0)
    critical_alerts = db.Column(db.Float, default=0.0)
    n_measurements = db.Column(db.Float, default=0.0)
    clinical_risk_score = db.Column(db.Float, default=0.0)
    history_sessions = db.Column(db.Integer, default=0)
    model_name = db.Column(db.String(120), default='clinical-feature extractor')

    def __repr__(self):
        return f'<SessionFeatureSnapshot {self.session_id}>'


class SessionForecastSnapshot(db.Model):
    __tablename__ = 'session_forecast_snapshots'

    id = db.Column(db.Integer, primary_key=True)
    session_id = db.Column(
        db.Integer, db.ForeignKey('sessions.id'), nullable=False, unique=True
    )
    assessment_id = db.Column(
        db.Integer, db.ForeignKey('session_assessments.id'), nullable=False, unique=True
    )
    computed_at = db.Column(db.DateTime, nullable=False, default=datetime.utcnow)
    window_minutes = db.Column(db.Integer, nullable=False, default=30)
    forecast_risk = db.Column(db.String(20), nullable=False, default='low')
    heart_rate = db.Column(db.Float)
    spo2 = db.Column(db.Float)
    temperature = db.Column(db.Float)
    heart_rate_slope = db.Column(db.Float, default=0.0)
    spo2_slope = db.Column(db.Float, default=0.0)
    temperature_slope = db.Column(db.Float, default=0.0)
    model_name = db.Column(db.String(120), default='linear-short-term forecast')

    def __repr__(self):
        return f'<SessionForecastSnapshot {self.session_id}>'


class TherapyRecommendation(db.Model):
    __tablename__ = 'therapy_recommendations'

    id = db.Column(db.Integer, primary_key=True)
    assessment_id = db.Column(
        db.Integer, db.ForeignKey('session_assessments.id'), nullable=False
    )
    category = db.Column(db.String(50), nullable=False)
    title = db.Column(db.String(150), nullable=False)
    details = db.Column(db.Text, nullable=False)
    sort_order = db.Column(db.Integer, default=0)

    def __repr__(self):
        return f'<TherapyRecommendation {self.title}>'
