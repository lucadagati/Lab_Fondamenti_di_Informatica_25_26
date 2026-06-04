"""
Signal processing and anomaly detection for wearable vital-sign data.

Pipeline:
  raw signal → moving-average / Savitzky-Golay smoothing
             → statistical feature extraction
             → clinical-threshold alert detection
             → z-score outlier detection
"""

import numpy as np
from scipy.signal import savgol_filter

from app.devices import get_device_profile
from app.waveform_analysis import (
    analyze_ecg_waveform,
    analyze_ppg_waveform,
    summarize_respiration_waveform,
)

# ── Clinical thresholds ───────────────────────────────────────────────────────
HR_CRITICAL_LOW = 40
HR_WARNING_LOW = 50
HR_WARNING_HIGH = 100
HR_CRITICAL_HIGH = 150

SPO2_CRITICAL_LOW = 90
SPO2_WARNING_LOW = 95

TEMP_CRITICAL_LOW = 35.0
TEMP_WARNING_LOW = 36.0
TEMP_WARNING_HIGH = 37.5
TEMP_CRITICAL_HIGH = 38.5


def _contextual_thresholds(activity_level):
    activity = 0.0 if activity_level is None else float(activity_level)
    hr_high = 102 + (40 * min(activity, 1.0))
    hr_critical = hr_high + 22
    temp_high = 37.5 + (0.5 * min(activity, 1.0))
    return {
        'hr_low': 48 if activity < 0.15 else 52,
        'hr_critical_low': 40,
        'hr_high': hr_high,
        'hr_critical_high': hr_critical,
        'spo2_low': 94.0,
        'spo2_critical_low': 90.0,
        'temp_low': 35.8,
        'temp_critical_low': 35.0,
        'temp_high': temp_high,
        'temp_critical_high': max(38.5, temp_high + 0.5),
    }


def _build_episode_alert(alert_type, severity, start_idx, end_idx, measurements, values, message):
    start = measurements[start_idx]
    end = measurements[end_idx]
    valid_values = [v for v in values[start_idx:end_idx + 1] if v is not None]
    peak = max(valid_values) if valid_values else None
    trough = min(valid_values) if valid_values else None
    duration_min = (end.timestamp - start.timestamp).total_seconds() / 60.0
    return {
        'measurement_id': start.id,
        'timestamp': start.timestamp,
        'type': alert_type,
        'severity': severity,
        'message': message.format(
            duration=round(duration_min, 1),
            peak=f'{peak:.1f}' if peak is not None else 'n/d',
            trough=f'{trough:.1f}' if trough is not None else 'n/d',
        ),
    }


def detect_session_alerts(measurements, min_consecutive=3):
    """Aggregate abnormal samples into clinically meaningful alert episodes."""
    if not measurements:
        return []

    alerts = []
    series = {
        'heart_rate': [m.heart_rate for m in measurements],
        'spo2': [m.spo2 for m in measurements],
        'temperature': [m.temperature for m in measurements],
        'activity': [m.activity_level for m in measurements],
    }

    rules = {
        'tachycardia': {
            'values': series['heart_rate'],
            'warning': lambda m, t: m.heart_rate is not None and m.heart_rate > t['hr_high'],
            'critical': lambda m, t: m.heart_rate is not None and m.heart_rate > t['hr_critical_high'],
            'warning_message': 'Tachicardia persistente per {duration} min (picco {peak} bpm).',
            'critical_message': 'Tachicardia severa persistente per {duration} min (picco {peak} bpm).',
        },
        'bradycardia': {
            'values': series['heart_rate'],
            'warning': lambda m, t: m.heart_rate is not None and m.heart_rate < t['hr_low'],
            'critical': lambda m, t: m.heart_rate is not None and m.heart_rate < t['hr_critical_low'],
            'warning_message': 'Bradicardia persistente per {duration} min (minimo {trough} bpm).',
            'critical_message': 'Bradicardia severa persistente per {duration} min (minimo {trough} bpm).',
        },
        'low_spo2': {
            'values': series['spo2'],
            'warning': lambda m, t: m.spo2 is not None and m.spo2 < t['spo2_low'],
            'critical': lambda m, t: m.spo2 is not None and m.spo2 < t['spo2_critical_low'],
            'warning_message': 'Desaturazione persistente per {duration} min (minimo {trough}%).',
            'critical_message': 'Desaturazione severa persistente per {duration} min (minimo {trough}%).',
        },
        'fever': {
            'values': series['temperature'],
            'warning': lambda m, t: m.temperature is not None and m.temperature > t['temp_high'],
            'critical': lambda m, t: m.temperature is not None and m.temperature > t['temp_critical_high'],
            'warning_message': 'Ipertermia persistente per {duration} min (picco {peak} °C).',
            'critical_message': 'Ipertermia severa persistente per {duration} min (picco {peak} °C).',
        },
        'hypothermia': {
            'values': series['temperature'],
            'warning': lambda m, t: m.temperature is not None and m.temperature < t['temp_low'],
            'critical': lambda m, t: m.temperature is not None and m.temperature < t['temp_critical_low'],
            'warning_message': 'Ipotermia persistente per {duration} min (minimo {trough} °C).',
            'critical_message': 'Ipotermia severa persistente per {duration} min (minimo {trough} °C).',
        },
    }

    for alert_type, config in rules.items():
        start_idx = None
        critical_seen = False
        count = 0
        for idx, measurement in enumerate(measurements + [None]):
            if measurement is None:
                abnormal = False
                is_critical = False
            else:
                thresholds = _contextual_thresholds(measurement.activity_level)
                is_critical = config['critical'](measurement, thresholds)
                abnormal = is_critical or config['warning'](measurement, thresholds)

            if abnormal and start_idx is None:
                start_idx = idx
                critical_seen = is_critical
                count = 1
            elif abnormal:
                critical_seen = critical_seen or is_critical
                count += 1
            elif start_idx is not None:
                if count >= min_consecutive or critical_seen:
                    severity = 'critical' if critical_seen else 'warning'
                    msg_key = 'critical_message' if critical_seen else 'warning_message'
                    alerts.append(_build_episode_alert(
                        alert_type=alert_type if not critical_seen else f'{alert_type}_severe',
                        severity=severity,
                        start_idx=start_idx,
                        end_idx=idx - 1,
                        measurements=measurements,
                        values=config['values'],
                        message=config[msg_key],
                    ))
                start_idx = None
                critical_seen = False
                count = 0

    hr_values = np.array([m.heart_rate for m in measurements if m.heart_rate is not None], dtype=float)
    activity_values = np.array([m.activity_level for m in measurements if m.activity_level is not None], dtype=float)
    if len(hr_values) >= 12 and len(activity_values) >= 12:
        hr_variability = float(np.std(hr_values))
        activity_mean = float(np.mean(activity_values))
        if hr_variability > 16 and activity_mean < 0.35:
            alerts.append({
                'measurement_id': measurements[0].id,
                'timestamp': measurements[0].timestamp,
                'type': 'arrhythmia_suspected',
                'severity': 'warning' if hr_variability < 22 else 'critical',
                'message': (
                    'Irregolarità del ritmo sospetta: variabilità FC elevata '
                    f'({hr_variability:.1f} bpm) a bassa attività.'
                ),
            })

    alerts.sort(key=lambda item: item['timestamp'])
    return alerts


# ── Smoothing ─────────────────────────────────────────────────────────────────

def smooth_signal(values, window_size=7):
    """
    Apply a centered moving-average filter.
    None / NaN entries are preserved in the output.
    """
    arr = np.array([v if v is not None else np.nan for v in values], dtype=float)
    mask_nan = np.isnan(arr)
    if mask_nan.all():
        return arr

    # Linear interpolation to fill gaps before smoothing
    idx = np.arange(len(arr))
    filled = np.interp(idx, idx[~mask_nan], arr[~mask_nan])

    w = min(window_size, len(filled))
    kernel = np.ones(w) / w
    smoothed = np.convolve(filled, kernel, mode='same')
    smoothed[mask_nan] = np.nan
    return smoothed


def apply_savgol(values, window_length=11, polyorder=2):
    """Savitzky-Golay filter for polynomial-preserving smoothing."""
    arr = np.array([v if v is not None else np.nan for v in values], dtype=float)
    if np.sum(~np.isnan(arr)) < window_length:
        return arr
    return savgol_filter(arr, window_length, polyorder)


def _to_json_list(arr):
    """Convert numpy array → JSON-serialisable Python list (nan → None)."""
    return [None if (v is None or (isinstance(v, float) and np.isnan(v))) else float(v)
            for v in arr]


# ── Statistics ────────────────────────────────────────────────────────────────

def compute_statistics(values):
    """Return descriptive statistics for a 1-D signal."""
    arr = np.array([v for v in values if v is not None], dtype=float)
    arr = arr[~np.isnan(arr)]
    if len(arr) == 0:
        return {}
    return {
        'mean':   round(float(np.mean(arr)), 2),
        'std':    round(float(np.std(arr)),  2),
        'min':    round(float(np.min(arr)),  2),
        'max':    round(float(np.max(arr)),  2),
        'median': round(float(np.median(arr)), 2),
        'q25':    round(float(np.percentile(arr, 25)), 2),
        'q75':    round(float(np.percentile(arr, 75)), 2),
    }


def extract_session_features(measurements):
    heart_rate = [m.heart_rate for m in measurements if m.heart_rate is not None]
    spo2 = [m.spo2 for m in measurements if m.spo2 is not None]
    temperature = [m.temperature for m in measurements if m.temperature is not None]
    activity = [m.activity_level for m in measurements if m.activity_level is not None]
    if not heart_rate:
        return {}
    return {
        'heart_rate_mean': round(float(np.mean(heart_rate)), 2),
        'heart_rate_std': round(float(np.std(heart_rate)), 2),
        'spo2_mean': round(float(np.mean(spo2)), 2) if spo2 else None,
        'spo2_min': round(float(np.min(spo2)), 2) if spo2 else None,
        'temperature_mean': round(float(np.mean(temperature)), 2) if temperature else None,
        'temperature_max': round(float(np.max(temperature)), 2) if temperature else None,
        'activity_mean': round(float(np.mean(activity)), 3) if activity else None,
    }


def generate_ecg_preview(measurements, duration_seconds=8, sampling_hz=180):
    if not measurements:
        return {}

    session_obj = measurements[0].session
    if getattr(session_obj, 'ecg_samples', None):
        ordered_samples = sorted(session_obj.ecg_samples, key=lambda item: item.sample_index)
        limited = [sample for sample in ordered_samples if sample.offset_seconds <= duration_seconds]
        if limited:
            return {
                'timestamps': [round(float(sample.offset_seconds), 3) for sample in limited],
                'values': [round(float(sample.value), 4) for sample in limited],
                'sampling_hz': sampling_hz,
                'duration_seconds': duration_seconds,
                'source': 'public_dataset',
            }

    heart_rate = [m.heart_rate for m in measurements if m.heart_rate is not None]
    activity = [m.activity_level for m in measurements if m.activity_level is not None]
    if not heart_rate:
        return {}

    rr_interval = 60.0 / max(45.0, float(np.mean(heart_rate)))
    variability = float(np.std(heart_rate)) / 140.0
    activity_mean = float(np.mean(activity)) if activity else 0.0

    time_axis = np.arange(0, duration_seconds, 1 / sampling_hz)
    signal = np.zeros_like(time_axis)
    beat_times = np.arange(0, duration_seconds + rr_interval, rr_interval)

    for beat_time in beat_times:
        signal += 0.08 * np.exp(-((time_axis - (beat_time - 0.18)) ** 2) / 0.0016)
        signal += -0.12 * np.exp(-((time_axis - (beat_time - 0.03)) ** 2) / 0.00018)
        signal += 1.15 * np.exp(-((time_axis - beat_time) ** 2) / 0.00012)
        signal += -0.22 * np.exp(-((time_axis - (beat_time + 0.03)) ** 2) / 0.0003)
        signal += 0.28 * np.exp(-((time_axis - (beat_time + 0.22)) ** 2) / 0.006)

    signal += 0.015 * np.sin(2 * np.pi * time_axis * (0.3 + activity_mean))
    signal += np.random.default_rng(42).normal(0, 0.012 + variability, len(time_axis))

    return {
        'timestamps': [round(float(value), 3) for value in time_axis.tolist()],
        'values': [round(float(value), 4) for value in signal.tolist()],
        'sampling_hz': sampling_hz,
        'duration_seconds': duration_seconds,
        'source': 'synthetic',
    }


# ── Threshold-based anomaly detection ────────────────────────────────────────

def check_vital_alerts(heart_rate, spo2, temperature, timestamp):
    """
    Check a single sample against clinical thresholds.
    Returns a list of alert dicts (may be empty).
    """
    alerts = []

    if heart_rate is not None:
        if heart_rate < HR_CRITICAL_LOW:
            alerts.append({
                'type': 'bradycardia_severe', 'severity': 'critical',
                'message': f'Bradicardia grave ({heart_rate:.0f} bpm)',
                'timestamp': timestamp,
            })
        elif heart_rate < HR_WARNING_LOW:
            alerts.append({
                'type': 'bradycardia', 'severity': 'warning',
                'message': f'Bradicardia ({heart_rate:.0f} bpm)',
                'timestamp': timestamp,
            })
        elif heart_rate > HR_CRITICAL_HIGH:
            alerts.append({
                'type': 'tachycardia_severe', 'severity': 'critical',
                'message': f'Tachicardia grave ({heart_rate:.0f} bpm)',
                'timestamp': timestamp,
            })
        elif heart_rate > HR_WARNING_HIGH:
            alerts.append({
                'type': 'tachycardia', 'severity': 'warning',
                'message': f'Tachicardia ({heart_rate:.0f} bpm)',
                'timestamp': timestamp,
            })

    if spo2 is not None:
        if spo2 < SPO2_CRITICAL_LOW:
            alerts.append({
                'type': 'hypoxia_severe', 'severity': 'critical',
                'message': f'Ipossia grave — SpO₂ {spo2:.1f}%',
                'timestamp': timestamp,
            })
        elif spo2 < SPO2_WARNING_LOW:
            alerts.append({
                'type': 'low_spo2', 'severity': 'warning',
                'message': f'SpO₂ bassa ({spo2:.1f}%)',
                'timestamp': timestamp,
            })

    if temperature is not None:
        if temperature < TEMP_CRITICAL_LOW:
            alerts.append({
                'type': 'hypothermia_severe', 'severity': 'critical',
                'message': f'Ipotermia grave ({temperature:.1f} °C)',
                'timestamp': timestamp,
            })
        elif temperature < TEMP_WARNING_LOW:
            alerts.append({
                'type': 'hypothermia', 'severity': 'warning',
                'message': f'Ipotermia ({temperature:.1f} °C)',
                'timestamp': timestamp,
            })
        elif temperature > TEMP_CRITICAL_HIGH:
            alerts.append({
                'type': 'hyperthermia_severe', 'severity': 'critical',
                'message': f'Ipertermia grave ({temperature:.1f} °C)',
                'timestamp': timestamp,
            })
        elif temperature > TEMP_WARNING_HIGH:
            alerts.append({
                'type': 'fever', 'severity': 'warning',
                'message': f'Febbre ({temperature:.1f} °C)',
                'timestamp': timestamp,
            })

    return alerts


# ── Z-score anomaly detection ─────────────────────────────────────────────────

def detect_zscore_anomalies(values, timestamps, threshold=3.0):
    """
    Detect statistical outliers using the z-score method.
    Returns a list of anomaly dicts.
    """
    arr = np.array([v if v is not None else np.nan for v in values], dtype=float)
    valid = ~np.isnan(arr)
    if valid.sum() < 5:
        return []

    mean = np.nanmean(arr)
    std = np.nanstd(arr)
    if std < 1e-9:
        return []

    z_scores = np.abs((arr - mean) / std)
    anomalies = []
    for i, (z, val, ts) in enumerate(zip(z_scores, values, timestamps)):
        if valid[i] and z > threshold:
            anomalies.append({
                'index': i,
                'timestamp': ts,
                'value': val,
                'z_score': round(float(z), 2),
                'type': 'statistical_outlier',
                'severity': 'warning' if z < 4.0 else 'critical',
                'message': f'Valore anomalo (z-score: {z:.2f})',
            })
    return anomalies


def _real_ecg_samples(session_obj):
    return [
        {
            'sample_index': sample.sample_index,
            'offset_seconds': sample.offset_seconds,
            'value': sample.value,
        }
        for sample in sorted(session_obj.ecg_samples, key=lambda item: item.sample_index)
    ]


def _waveform_samples_by_type(session_obj, signal_type):
    return [
        {
            'sample_index': sample.sample_index,
            'offset_seconds': sample.offset_seconds,
            'value': sample.value,
            'sampling_hz': sample.sampling_hz,
            'unit': sample.unit,
        }
        for sample in sorted(session_obj.waveform_samples, key=lambda item: item.sample_index)
        if sample.signal_type == signal_type
    ]


def _build_waveform_analysis(session_obj, measurements):
    ecg_samples = _real_ecg_samples(session_obj)
    if ecg_samples:
        return analyze_ecg_waveform(ecg_samples)

    ppg_samples = _waveform_samples_by_type(session_obj, 'ppg')
    if ppg_samples:
        analysis = analyze_ppg_waveform(ppg_samples)
        respiration_samples = _waveform_samples_by_type(session_obj, 'respiration')
        if respiration_samples:
            analysis['respiration'] = summarize_respiration_waveform(respiration_samples)
        return analysis

    device_profile = get_device_profile(session_obj.device_id)
    if device_profile.get('supports_ecg'):
        preview = generate_ecg_preview(measurements)
        if preview:
            return {
                'signal_type': 'ecg',
                'source': 'synthetic',
                'sampling_hz': preview.get('sampling_hz'),
                'waveform': {
                    'timestamps': preview.get('timestamps', []),
                    'values': preview.get('values', []),
                    'filtered': preview.get('values', []),
                    'peak_timestamps': [],
                    'peak_values': [],
                },
                'features': {
                    'dominant_hr_bpm': None,
                    'qrs_peak_count': None,
                    'qrs_amplitude_p95': None,
                    'duration_seconds': preview.get('duration_seconds'),
                },
                'hrv': {},
                'artifacts': {'flags': ['synthetic_preview']},
                'quality': {'score': None, 'label': 'synthetic', 'beat_coverage': None},
            }
    return {}


# ── Session-level analysis ────────────────────────────────────────────────────

def analyze_session(measurements):
    """
    Run the full analysis pipeline on a list of Measurement ORM objects.
    Returns a JSON-serialisable dict consumed by the Plotly.js charts.
    """
    if not measurements:
        return {}

    hr = [m.heart_rate for m in measurements]
    spo2 = [m.spo2 for m in measurements]
    temp = [m.temperature for m in measurements]
    activity = [m.activity_level for m in measurements]
    timestamps = [m.timestamp.strftime('%Y-%m-%dT%H:%M:%S') for m in measurements]
    session_obj = measurements[0].session
    waveform_analysis = _build_waveform_analysis(session_obj, measurements)

    return {
        'timestamps': timestamps,
        'heart_rate': {
            'raw':    _to_json_list(hr),
            'smooth': _to_json_list(smooth_signal(hr)),
            'stats':  compute_statistics(hr),
        },
        'spo2': {
            'raw':    _to_json_list(spo2),
            'smooth': _to_json_list(smooth_signal(spo2)),
            'stats':  compute_statistics(spo2),
        },
        'temperature': {
            'raw':    _to_json_list(temp),
            'smooth': _to_json_list(smooth_signal(temp)),
            'stats':  compute_statistics(temp),
        },
        'activity': {
            'raw':   _to_json_list(activity),
            'stats': compute_statistics(activity),
        },
        'features': extract_session_features(measurements),
        'waveform_analysis': waveform_analysis,
        'ecg_preview': waveform_analysis.get('waveform', {}) if waveform_analysis else {},
    }
