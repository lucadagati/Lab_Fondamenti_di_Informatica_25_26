-- ================================================================
-- HealthMonitor IoT — Schema del database (SQLite 3)
-- Le tabelle sono create automaticamente da Flask-SQLAlchemy.
-- Questo file serve come documentazione e per query di esempio.
-- ================================================================

PRAGMA foreign_keys = ON;

-- ── Tabella pazienti ─────────────────────────────────────────
CREATE TABLE IF NOT EXISTS patients (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    name        TEXT    NOT NULL,
    age         INTEGER CHECK (age BETWEEN 0 AND 130),
    gender      TEXT    CHECK (gender IN ('M', 'F', 'Altro')),
    weight_kg   REAL    CHECK (weight_kg > 0),
    height_cm   REAL    CHECK (height_cm > 0),
    notes       TEXT,
    created_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ── Tabella sessioni di monitoraggio ─────────────────────────
CREATE TABLE IF NOT EXISTS sessions (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    patient_id  INTEGER NOT NULL
                    REFERENCES patients(id) ON DELETE CASCADE,
    device_id   TEXT    DEFAULT 'WearableSensor-v1',
    source_type TEXT    DEFAULT 'synthetic',
    source_name TEXT,
    start_time  TIMESTAMP NOT NULL,
    end_time    TIMESTAMP,
    notes       TEXT
);

-- ── Tabella misurazioni ───────────────────────────────────────
CREATE TABLE IF NOT EXISTS measurements (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    session_id      INTEGER NOT NULL
                        REFERENCES sessions(id) ON DELETE CASCADE,
    timestamp       TIMESTAMP NOT NULL,
    heart_rate      REAL CHECK (heart_rate BETWEEN 20 AND 300),
    spo2            REAL CHECK (spo2 BETWEEN 50 AND 100),
    temperature     REAL CHECK (temperature BETWEEN 30 AND 45),
    activity_level  REAL CHECK (activity_level BETWEEN 0 AND 1)
);

-- ── Tabella alert ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS alerts (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    measurement_id  INTEGER REFERENCES measurements(id),
    session_id      INTEGER NOT NULL
                        REFERENCES sessions(id) ON DELETE CASCADE,
    timestamp       TIMESTAMP NOT NULL,
    type            TEXT NOT NULL,
    severity        TEXT NOT NULL
                        CHECK (severity IN ('warning', 'critical')),
    message         TEXT
);

-- ── Tabella campioni ECG persistiti ──────────────────────────
CREATE TABLE IF NOT EXISTS ecg_samples (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    session_id      INTEGER NOT NULL
                        REFERENCES sessions(id) ON DELETE CASCADE,
    sample_index    INTEGER NOT NULL,
    offset_seconds  REAL NOT NULL,
    value           REAL NOT NULL
);

-- ── Tabella waveform multi-segnale (PPG/respirazione/altro) ──────────────
CREATE TABLE IF NOT EXISTS waveform_samples (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    session_id      INTEGER NOT NULL
                        REFERENCES sessions(id) ON DELETE CASCADE,
    signal_type     TEXT NOT NULL,
    sample_index    INTEGER NOT NULL,
    offset_seconds  REAL NOT NULL,
    value           REAL NOT NULL,
    sampling_hz     REAL,
    unit            TEXT
);

-- ── Tabella assessment AI persistiti ─────────────────────────
CREATE TABLE IF NOT EXISTS session_assessments (
    id                       INTEGER PRIMARY KEY AUTOINCREMENT,
    session_id               INTEGER NOT NULL UNIQUE
                                REFERENCES sessions(id) ON DELETE CASCADE,
    computed_at              TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    diagnosis_label          TEXT NOT NULL,
    diagnosis_confidence     REAL NOT NULL,
    risk_level               TEXT NOT NULL,
    rationale                TEXT NOT NULL,
    forecast                 TEXT NOT NULL,
    history_delta            TEXT NOT NULL,
    trend_prediction         TEXT NOT NULL,
    therapy_expected_outcome TEXT
);

-- ── Tabella feature cliniche persistite per audit ──────────────
CREATE TABLE IF NOT EXISTS session_feature_snapshots (
    id                  INTEGER PRIMARY KEY AUTOINCREMENT,
    session_id          INTEGER NOT NULL UNIQUE
                            REFERENCES sessions(id) ON DELETE CASCADE,
    assessment_id       INTEGER NOT NULL UNIQUE
                            REFERENCES session_assessments(id) ON DELETE CASCADE,
    computed_at         TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    hr_mean             REAL,
    hr_std              REAL,
    hr_max              REAL,
    spo2_mean           REAL,
    spo2_min            REAL,
    temp_mean           REAL,
    temp_max            REAL,
    activity_mean       REAL,
    warning_alerts      REAL DEFAULT 0,
    critical_alerts     REAL DEFAULT 0,
    n_measurements      REAL DEFAULT 0,
    clinical_risk_score REAL DEFAULT 0,
    history_sessions    INTEGER DEFAULT 0,
    model_name          TEXT
);

-- ── Tabella forecast numerici persistiti per audit ────────────
CREATE TABLE IF NOT EXISTS session_forecast_snapshots (
    id                  INTEGER PRIMARY KEY AUTOINCREMENT,
    session_id          INTEGER NOT NULL UNIQUE
                            REFERENCES sessions(id) ON DELETE CASCADE,
    assessment_id       INTEGER NOT NULL UNIQUE
                            REFERENCES session_assessments(id) ON DELETE CASCADE,
    computed_at         TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    window_minutes      INTEGER NOT NULL DEFAULT 30,
    forecast_risk       TEXT NOT NULL DEFAULT 'low',
    heart_rate          REAL,
    spo2                REAL,
    temperature         REAL,
    heart_rate_slope    REAL DEFAULT 0,
    spo2_slope          REAL DEFAULT 0,
    temperature_slope   REAL DEFAULT 0,
    model_name          TEXT
);

-- ── Tabella raccomandazioni terapeutiche ─────────────────────
CREATE TABLE IF NOT EXISTS therapy_recommendations (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    assessment_id   INTEGER NOT NULL
                        REFERENCES session_assessments(id) ON DELETE CASCADE,
    category        TEXT NOT NULL,
    title           TEXT NOT NULL,
    details         TEXT NOT NULL,
    sort_order      INTEGER DEFAULT 0
);

-- ── Indici ────────────────────────────────────────────────────
CREATE INDEX IF NOT EXISTS idx_meas_session   ON measurements(session_id);
CREATE INDEX IF NOT EXISTS idx_meas_ts        ON measurements(timestamp);
CREATE INDEX IF NOT EXISTS idx_alerts_session ON alerts(session_id);
CREATE INDEX IF NOT EXISTS idx_alerts_sev     ON alerts(severity);
CREATE INDEX IF NOT EXISTS idx_sess_patient   ON sessions(patient_id);
CREATE INDEX IF NOT EXISTS idx_ecg_session    ON ecg_samples(session_id);
CREATE INDEX IF NOT EXISTS idx_waveform_session ON waveform_samples(session_id);
CREATE INDEX IF NOT EXISTS idx_waveform_signal  ON waveform_samples(signal_type);
CREATE INDEX IF NOT EXISTS idx_assess_session ON session_assessments(session_id);
CREATE INDEX IF NOT EXISTS idx_feature_session ON session_feature_snapshots(session_id);
CREATE INDEX IF NOT EXISTS idx_forecast_session ON session_forecast_snapshots(session_id);

-- ================================================================
-- Query di esempio
-- ================================================================

-- 1. Parametri vitali medi per paziente
SELECT  p.name,
        ROUND(AVG(m.heart_rate), 1)   AS avg_hr,
        ROUND(AVG(m.spo2), 2)         AS avg_spo2,
        ROUND(AVG(m.temperature), 2)  AS avg_temp,
        COUNT(m.id)                   AS n_measurements
FROM    patients   p
JOIN    sessions   s ON s.patient_id = p.id
JOIN    measurements m ON m.session_id = s.id
GROUP BY p.id, p.name
ORDER BY p.name;

-- 2. Alert critici recenti con dettaglio paziente
SELECT  p.name       AS paziente,
        a.type,
        a.severity,
        a.message,
        a.timestamp
FROM    alerts   a
JOIN    sessions s ON s.id = a.session_id
JOIN    patients p ON p.id = s.patient_id
WHERE   a.severity = 'critical'
ORDER BY a.timestamp DESC
LIMIT   20;

-- 3. Sessioni con più anomalie
SELECT  s.id,
        p.name          AS paziente,
        s.start_time,
        COUNT(a.id)     AS n_alerts,
        SUM(CASE WHEN a.severity = 'critical' THEN 1 ELSE 0 END) AS n_critical
FROM    sessions s
JOIN    patients p ON p.id = s.patient_id
LEFT JOIN alerts a ON a.session_id = s.id
GROUP BY s.id
ORDER BY n_alerts DESC;

-- 4. Percentuale misurazioni fuori soglia per sessione
SELECT  m.session_id,
        COUNT(*)  AS totale,
        ROUND(100.0 * SUM(CASE WHEN m.heart_rate < 60 OR m.heart_rate > 100 THEN 1 ELSE 0 END) / COUNT(*), 1)
                  AS pct_hr_anomale,
        ROUND(100.0 * SUM(CASE WHEN m.spo2 < 95 THEN 1 ELSE 0 END) / COUNT(*), 1)
                  AS pct_spo2_basse,
        ROUND(100.0 * SUM(CASE WHEN m.temperature > 37.5 THEN 1 ELSE 0 END) / COUNT(*), 1)
                  AS pct_febbre
FROM    measurements m
GROUP BY m.session_id;

-- 5. BMI calcolato per tutti i pazienti con dati antropometrici
SELECT  name,
        age,
        weight_kg,
        height_cm,
        ROUND(weight_kg / ((height_cm / 100.0) * (height_cm / 100.0)), 1) AS bmi
FROM    patients
WHERE   weight_kg IS NOT NULL AND height_cm IS NOT NULL
ORDER BY bmi DESC;

-- 6. Audit completo delle feature e del forecast per sessione
SELECT  s.id,
        p.name,
        f.hr_mean,
        f.spo2_mean,
        f.clinical_risk_score,
        fc.heart_rate AS forecast_hr,
        fc.spo2       AS forecast_spo2,
        fc.temperature AS forecast_temp
FROM    sessions s
JOIN    patients p ON p.id = s.patient_id
LEFT JOIN session_feature_snapshots f ON f.session_id = s.id
LEFT JOIN session_forecast_snapshots fc ON fc.session_id = s.id
ORDER BY s.start_time DESC;
