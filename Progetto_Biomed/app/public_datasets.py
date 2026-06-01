from datetime import datetime, timedelta

import numpy as np
from scipy.signal import find_peaks

try:
    import wfdb
except ImportError:  # pragma: no cover - handled at runtime
    wfdb = None


MITDB_RECORDS = {
    '100': 'MIT-BIH Arrhythmia record 100',
    '101': 'MIT-BIH Arrhythmia record 101',
    '106': 'MIT-BIH Arrhythmia record 106',
    '119': 'MIT-BIH Arrhythmia record 119',
}

BIDMC_RECORDS = {
    'bidmc01': 'BIDMC PPG and Respiration record 01',
    'bidmc02': 'BIDMC PPG and Respiration record 02',
    'bidmc03': 'BIDMC PPG and Respiration record 03',
    'bidmc04': 'BIDMC PPG and Respiration record 04',
}


def available_public_datasets():
    return {
        'mitdb': {
            'label': 'PhysioNet MIT-BIH Arrhythmia Database',
            'description': 'ECG reale annotato con ritmo cardiaco e battiti da record pubblici PhysioNet.',
            'records': MITDB_RECORDS,
        },
        'bidmc': {
            'label': 'PhysioNet BIDMC PPG and Respiration Dataset',
            'description': 'Segnali vitali reali con PPG e respirazione, utili per derivare frequenza cardiaca da sorgente non simulata.',
            'records': BIDMC_RECORDS,
        },
    }


def _instantaneous_hr(samples, fs):
    if len(samples) < 2:
        return np.array([]), np.array([])
    rr = np.diff(samples) / fs
    rr = np.where(rr <= 0, np.nan, rr)
    hr = 60.0 / rr
    beat_seconds = samples[1:] / fs
    valid = ~np.isnan(hr)
    return beat_seconds[valid], hr[valid]


def import_mitdb_session(record_name='100', duration_seconds=30):
    if wfdb is None:
        raise RuntimeError('wfdb non installato. Eseguire pip install -r requirements.txt')

    duration_seconds = int(max(10, min(duration_seconds, 120)))
    fs = 360
    total_samples = duration_seconds * fs

    record = wfdb.rdrecord(record_name, sampfrom=0, sampto=total_samples, pn_dir='mitdb')
    annotation = wfdb.rdann(record_name, 'atr', sampfrom=0, sampto=total_samples, pn_dir='mitdb')

    signal = record.p_signal[:, 0]
    sample_rate = float(record.fs)
    beat_symbols = set(['N', 'L', 'R', 'A', 'V', 'F', 'j', 'e', 'J', 'E', 'a', 'S'])
    beat_samples = np.array([
        sample for sample, symbol in zip(annotation.sample, annotation.symbol)
        if symbol in beat_symbols
    ], dtype=float)

    beat_seconds, heart_rates = _instantaneous_hr(beat_samples, sample_rate)
    measurement_seconds = np.arange(0, duration_seconds, 1.0)
    if len(beat_seconds) >= 2:
        hr_series = np.interp(
            measurement_seconds,
            beat_seconds,
            heart_rates,
            left=heart_rates[0],
            right=heart_rates[-1],
        )
    elif len(heart_rates) == 1:
        hr_series = np.repeat(float(heart_rates[0]), len(measurement_seconds))
    else:
        hr_series = np.repeat(75.0, len(measurement_seconds))

    downsample_step = max(1, int(sample_rate // 125))
    ecg_values = signal[::downsample_step]
    ecg_offsets = np.arange(len(ecg_values)) * (downsample_step / sample_rate)

    session_start = datetime.utcnow() - timedelta(seconds=duration_seconds)
    measurements = [
        {
            'timestamp': session_start + timedelta(seconds=float(second)),
            'heart_rate': round(float(hr_series[index]), 1),
            'spo2': None,
            'temperature': None,
            'activity_level': 0.02,
        }
        for index, second in enumerate(measurement_seconds)
    ]
    ecg_samples = [
        {
            'sample_index': index,
            'offset_seconds': round(float(offset), 4),
            'value': round(float(value), 5),
        }
        for index, (offset, value) in enumerate(zip(ecg_offsets, ecg_values))
    ]

    return {
        'source_type': 'public_dataset',
        'source_name': f'PhysioNet MIT-BIH {record_name}',
        'dataset_label': MITDB_RECORDS.get(record_name, f'MIT-BIH {record_name}'),
        'device_id': 'physionet_mitdb',
        'start_time': measurements[0]['timestamp'],
        'end_time': measurements[-1]['timestamp'],
        'measurements': measurements,
        'ecg_samples': ecg_samples,
        'notes': f'Import da dataset pubblico PhysioNet MIT-BIH, record {record_name}',
    }


def _select_signal_index(signal_names, aliases):
    lowered = [name.lower() for name in signal_names]
    for alias in aliases:
        for index, name in enumerate(lowered):
            if alias in name:
                return index
    return None


def _derive_hr_from_ppg(ppg_signal, sample_rate, duration_seconds):
    if len(ppg_signal) < 3:
        return np.arange(0, duration_seconds, 1.0), np.repeat(72.0, int(duration_seconds))

    centered = ppg_signal - np.nanmedian(ppg_signal)
    variability = float(np.nanstd(centered))
    min_distance = max(1, int(sample_rate * 0.45))
    prominence = max(0.02, variability * 0.18)
    peaks, _ = find_peaks(centered, distance=min_distance, prominence=prominence)

    if len(peaks) < 2:
        measurement_seconds = np.arange(0, duration_seconds, 1.0)
        return measurement_seconds, np.repeat(72.0, len(measurement_seconds))

    beat_seconds = peaks[1:] / sample_rate
    rr_intervals = np.diff(peaks) / sample_rate
    rr_intervals = np.where(rr_intervals <= 0, np.nan, rr_intervals)
    heart_rates = 60.0 / rr_intervals
    valid = ~np.isnan(heart_rates)

    if not np.any(valid):
        measurement_seconds = np.arange(0, duration_seconds, 1.0)
        return measurement_seconds, np.repeat(72.0, len(measurement_seconds))

    beat_seconds = beat_seconds[valid]
    heart_rates = heart_rates[valid]
    measurement_seconds = np.arange(0, duration_seconds, 1.0)
    if len(beat_seconds) >= 2:
        hr_series = np.interp(
            measurement_seconds,
            beat_seconds,
            heart_rates,
            left=heart_rates[0],
            right=heart_rates[-1],
        )
    else:
        hr_series = np.repeat(float(heart_rates[0]), len(measurement_seconds))
    return measurement_seconds, hr_series


def import_bidmc_vitals_session(record_name='bidmc01', duration_seconds=60):
    if wfdb is None:
        raise RuntimeError('wfdb non installato. Eseguire pip install -r requirements.txt')

    duration_seconds = int(max(30, min(duration_seconds, 180)))
    probe = wfdb.rdrecord(record_name, sampfrom=0, sampto=1, pn_dir='bidmc')
    sample_rate = float(probe.fs)
    total_samples = int(duration_seconds * sample_rate)
    record = wfdb.rdrecord(record_name, sampfrom=0, sampto=total_samples, pn_dir='bidmc')

    signal_names = list(record.sig_name)
    ppg_idx = _select_signal_index(signal_names, ['pleth', 'ppg'])
    resp_idx = _select_signal_index(signal_names, ['resp'])

    if ppg_idx is None:
        raise RuntimeError('Il record BIDMC selezionato non contiene un canale PPG riconoscibile.')

    ppg_signal = record.p_signal[:, ppg_idx]
    measurement_seconds, hr_series = _derive_hr_from_ppg(ppg_signal, sample_rate, duration_seconds)

    resp_mean = None
    if resp_idx is not None:
        resp_signal = record.p_signal[:, resp_idx]
        resp_mean = round(float(np.nanmean(resp_signal)), 4)

    session_start = datetime.utcnow() - timedelta(seconds=duration_seconds)
    measurements = [
        {
            'timestamp': session_start + timedelta(seconds=float(second)),
            'heart_rate': round(float(hr_series[index]), 1),
            'spo2': None,
            'temperature': None,
            'activity_level': 0.03,
        }
        for index, second in enumerate(measurement_seconds)
    ]

    return {
        'source_type': 'public_dataset',
        'source_name': f'PhysioNet BIDMC {record_name}',
        'dataset_label': BIDMC_RECORDS.get(record_name, f'BIDMC {record_name}'),
        'device_id': 'physionet_bidmc',
        'start_time': measurements[0]['timestamp'],
        'end_time': measurements[-1]['timestamp'],
        'measurements': measurements,
        'ecg_samples': [],
        'notes': (
            f'Import da dataset pubblico PhysioNet BIDMC, record {record_name}. '
            f'Frequenza cardiaca derivata da PPG reale'
            f'{"; segnale respiratorio disponibile" if resp_mean is not None else ""}.'
        ),
    }
