import numpy as np
from scipy.signal import butter, filtfilt, find_peaks, welch


def _safe_round(value, digits=3):
    if value is None or not np.isfinite(value):
        return None
    return round(float(value), digits)


def _estimate_sampling_hz(offset_seconds, fallback_hz=None):
    if len(offset_seconds) < 2:
        return fallback_hz
    diffs = np.diff(offset_seconds)
    diffs = diffs[np.isfinite(diffs) & (diffs > 0)]
    if len(diffs) == 0:
        return fallback_hz
    return float(1.0 / np.median(diffs))


def _bandpass_filter(values, sampling_hz, low_hz, high_hz, order=2):
    if sampling_hz is None or sampling_hz <= 0 or len(values) < 12:
        return values
    nyq = 0.5 * sampling_hz
    low = max(low_hz / nyq, 1e-4)
    high = min(high_hz / nyq, 0.99)
    if low >= high:
        return values
    b, a = butter(order, [low, high], btype='band')
    padlen = min(len(values) - 1, max(len(a), len(b)) * 3)
    if padlen < 3:
        return values
    return filtfilt(b, a, values, padlen=padlen)


def _artifact_summary(values):
    if len(values) == 0:
        return {
            'clipping_ratio': None,
            'flatline_ratio': None,
            'spike_ratio': None,
            'nan_ratio': 1.0,
            'flags': ['missing_signal'],
        }

    arr = np.asarray(values, dtype=float)
    valid = np.isfinite(arr)
    nan_ratio = 1.0 - (np.sum(valid) / len(arr))
    clean = arr[valid]
    if len(clean) < 3:
        return {
            'clipping_ratio': None,
            'flatline_ratio': None,
            'spike_ratio': None,
            'nan_ratio': _safe_round(nan_ratio, 4),
            'flags': ['insufficient_valid_samples'],
        }

    dynamic_range = float(np.max(clean) - np.min(clean))
    derivative = np.diff(clean)
    clipping_ratio = float(np.mean((clean <= np.quantile(clean, 0.01)) | (clean >= np.quantile(clean, 0.99))))
    flatline_ratio = float(np.mean(np.abs(derivative) < max(dynamic_range * 0.001, 1e-6)))
    if np.std(derivative) < 1e-9:
        spike_ratio = 0.0
    else:
        dz = np.abs((derivative - np.mean(derivative)) / np.std(derivative))
        spike_ratio = float(np.mean(dz > 4.0))

    flags = []
    if nan_ratio > 0.05:
        flags.append('missing_samples')
    if clipping_ratio > 0.08:
        flags.append('clipping')
    if flatline_ratio > 0.20:
        flags.append('flatline')
    if spike_ratio > 0.03:
        flags.append('impulsive_noise')

    return {
        'clipping_ratio': _safe_round(clipping_ratio, 4),
        'flatline_ratio': _safe_round(flatline_ratio, 4),
        'spike_ratio': _safe_round(spike_ratio, 4),
        'nan_ratio': _safe_round(nan_ratio, 4),
        'flags': flags,
    }


def _quality_score(artifact_metrics, beat_coverage=1.0, variability_penalty=0.0):
    score = 100.0
    score -= 100.0 * float(artifact_metrics.get('nan_ratio') or 0.0)
    score -= 70.0 * float(artifact_metrics.get('clipping_ratio') or 0.0)
    score -= 50.0 * float(artifact_metrics.get('flatline_ratio') or 0.0)
    score -= 120.0 * float(artifact_metrics.get('spike_ratio') or 0.0)
    score -= max(0.0, 1.0 - beat_coverage) * 35.0
    score -= variability_penalty
    return max(0.0, min(100.0, score))


def _downsample_for_display(offsets, *series, max_points=1600):
    if len(offsets) <= max_points:
        return [np.asarray(offsets)] + [np.asarray(values) for values in series]
    step = int(np.ceil(len(offsets) / max_points))
    idx = np.arange(0, len(offsets), step, dtype=int)
    return [np.asarray(offsets)[idx]] + [np.asarray(values)[idx] for values in series]


def _select_display_window(offsets, *series, window_seconds=120.0):
    if len(offsets) == 0:
        return [np.asarray(offsets)] + [np.asarray(values) for values in series]
    duration_seconds = float(offsets[-1] - offsets[0]) if len(offsets) > 1 else 0.0
    if duration_seconds <= window_seconds:
        return [np.asarray(offsets)] + [np.asarray(values) for values in series]
    start_time = float(offsets[-1] - window_seconds)
    mask = np.asarray(offsets) >= start_time
    return [np.asarray(offsets)[mask]] + [np.asarray(values)[mask] for values in series]


def _hrv_features(rr_intervals):
    rr_ms = np.asarray(rr_intervals, dtype=float) * 1000.0
    if len(rr_ms) < 2:
        return {}

    diff_rr = np.diff(rr_ms)
    mean_rr = float(np.mean(rr_ms))
    mean_hr = 60000.0 / mean_rr if mean_rr > 0 else None
    features = {
        'mean_rr_ms': _safe_round(mean_rr, 1),
        'mean_hr_bpm': _safe_round(mean_hr, 1),
        'sdnn_ms': _safe_round(np.std(rr_ms, ddof=1) if len(rr_ms) > 1 else 0.0, 1),
        'rmssd_ms': _safe_round(np.sqrt(np.mean(np.square(diff_rr))) if len(diff_rr) else 0.0, 1),
        'pnn50': _safe_round(float(np.mean(np.abs(diff_rr) > 50.0)) if len(diff_rr) else 0.0, 3),
        'nn_intervals': int(len(rr_ms)),
    }

    if len(rr_ms) >= 8:
        rr_centered = rr_ms - np.mean(rr_ms)
        fs_interp = 4.0
        t_beats = np.cumsum(rr_intervals)
        t_beats = np.insert(t_beats[:-1], 0, 0.0)
        if len(t_beats) >= 4 and t_beats[-1] > 0:
            interp_t = np.arange(0.0, t_beats[-1], 1.0 / fs_interp)
            interp_rr = np.interp(interp_t, t_beats, rr_centered[:len(t_beats)])
            freq, power = welch(interp_rr, fs=fs_interp, nperseg=min(256, len(interp_rr)))
            lf = float(np.trapz(power[(freq >= 0.04) & (freq < 0.15)], freq[(freq >= 0.04) & (freq < 0.15)]))
            hf = float(np.trapz(power[(freq >= 0.15) & (freq < 0.4)], freq[(freq >= 0.15) & (freq < 0.4)]))
            features['lf_power'] = _safe_round(lf, 3)
            features['hf_power'] = _safe_round(hf, 3)
            features['lf_hf_ratio'] = _safe_round(lf / hf, 3) if hf > 1e-9 else None

    return features


def _rolling_window_metrics(offsets, raw, peaks, valid_rr, sampling_hz, signal_type, window_seconds=60.0, step_seconds=30.0):
    if len(offsets) < 2:
        return []

    offsets = np.asarray(offsets, dtype=float)
    raw = np.asarray(raw, dtype=float)
    total_duration = float(offsets[-1] - offsets[0])
    if total_duration < window_seconds:
        return []

    peak_times = offsets[peaks] if len(peaks) else np.array([], dtype=float)
    windows = []
    start = float(offsets[0])
    end_limit = float(offsets[-1])
    while start + window_seconds <= end_limit + 1e-9:
        end = start + window_seconds
        sample_mask = (offsets >= start) & (offsets < end)
        segment = raw[sample_mask]
        if np.sum(sample_mask) < max(20, int((sampling_hz or 1.0) * 10)):
            start += step_seconds
            continue

        segment_artifacts = _artifact_summary(segment)
        if len(peak_times):
            peak_mask = (peak_times >= start) & (peak_times < end)
            segment_peak_indices = np.where(peak_mask)[0]
            segment_valid_rr = []
            for idx in segment_peak_indices[:-1]:
                rr = peak_times[idx + 1] - peak_times[idx]
                if 0.33 <= rr <= 1.8:
                    segment_valid_rr.append(rr)
            segment_valid_rr = np.asarray(segment_valid_rr, dtype=float)
            beat_coverage = float(len(segment_valid_rr) / max(1, len(segment_peak_indices) - 1))
        else:
            segment_valid_rr = np.array([], dtype=float)
            beat_coverage = 0.0

        hrv = _hrv_features(segment_valid_rr)
        quality = _quality_score(segment_artifacts, beat_coverage=beat_coverage)
        entry = {
            't_center': _safe_round(start + (window_seconds / 2.0), 2),
            'quality_score': _safe_round(quality, 1),
            'beat_coverage': _safe_round(beat_coverage, 3),
        }
        if signal_type == 'ecg':
            entry['mean_hr_bpm'] = hrv.get('mean_hr_bpm')
            entry['sdnn_ms'] = hrv.get('sdnn_ms')
            entry['rmssd_ms'] = hrv.get('rmssd_ms')
        else:
            entry['pulse_rate_bpm'] = hrv.get('mean_hr_bpm')
            entry['sdnn_ms'] = hrv.get('sdnn_ms')
            entry['rmssd_ms'] = hrv.get('rmssd_ms')
        windows.append(entry)
        start += step_seconds

    return windows


def analyze_ecg_waveform(samples, sampling_hz=None):
    if not samples:
        return {}

    offsets = np.array([float(item['offset_seconds']) for item in samples], dtype=float)
    raw = np.array([float(item['value']) for item in samples], dtype=float)
    sampling_hz = _estimate_sampling_hz(offsets, sampling_hz)
    filtered = _bandpass_filter(raw, sampling_hz, low_hz=0.5, high_hz=35.0)
    centered = filtered - np.median(filtered)
    amplitude = np.abs(centered)
    prominence = max(np.std(amplitude) * 0.9, np.percentile(amplitude, 75) * 0.25, 0.05)
    distance = max(1, int((sampling_hz or 180.0) * 0.3))
    peaks, _ = find_peaks(amplitude, distance=distance, prominence=prominence)

    rr_intervals = np.diff(offsets[peaks]) if len(peaks) >= 2 else np.array([])
    valid_rr = rr_intervals[(rr_intervals >= 0.33) & (rr_intervals <= 1.8)]
    beat_coverage = (len(valid_rr) / len(rr_intervals)) if len(rr_intervals) else 0.0
    irregularity = np.std(valid_rr) * 40.0 if len(valid_rr) >= 3 else 12.0
    artifact_metrics = _artifact_summary(raw)
    quality_score = _quality_score(artifact_metrics, beat_coverage=beat_coverage, variability_penalty=irregularity)

    hrv = _hrv_features(valid_rr)
    dominant_hr = hrv.get('mean_hr_bpm')
    qrs_amplitude = float(np.percentile(amplitude, 95)) if len(amplitude) else None

    rolling_metrics = _rolling_window_metrics(
        offsets,
        raw,
        peaks,
        valid_rr,
        sampling_hz,
        signal_type='ecg',
        window_seconds=60.0,
        step_seconds=30.0,
    )
    display_offsets, display_raw, display_filtered = _select_display_window(offsets, raw, filtered, window_seconds=120.0)
    display_offsets, display_raw, display_filtered = _downsample_for_display(
        display_offsets, display_raw, display_filtered, max_points=1800
    )
    display_peak_mask = (offsets[peaks] >= display_offsets[0]) if len(peaks) and len(display_offsets) else np.array([], dtype=bool)
    display_peak_times = offsets[peaks][display_peak_mask] if len(peaks) and len(display_offsets) else np.array([], dtype=float)
    display_peak_values = raw[peaks][display_peak_mask] if len(peaks) and len(display_offsets) else np.array([], dtype=float)

    return {
        'signal_type': 'ecg',
        'source': 'real',
        'sampling_hz': _safe_round(sampling_hz, 2),
        'waveform': {
            'timestamps': [round(float(value), 4) for value in display_offsets],
            'values': [round(float(value), 5) for value in display_raw],
            'filtered': [round(float(value), 5) for value in display_filtered],
            'peak_timestamps': [round(float(value), 4) for value in display_peak_times[:160]],
            'peak_values': [round(float(value), 5) for value in display_peak_values[:160]],
            'display_window_seconds': 120,
            'display_mode': 'recent_window_downsampled' if len(offsets) > len(display_offsets) else 'full_signal',
        },
        'features': {
            'dominant_hr_bpm': dominant_hr,
            'qrs_peak_count': int(len(peaks)),
            'qrs_amplitude_p95': _safe_round(qrs_amplitude, 4),
            'duration_seconds': _safe_round(offsets[-1] if len(offsets) else 0.0, 2),
        },
        'hrv': hrv,
        'rolling_metrics': rolling_metrics,
        'artifacts': artifact_metrics,
        'quality': {
            'score': _safe_round(quality_score, 1),
            'label': 'high' if quality_score >= 80 else 'moderate' if quality_score >= 55 else 'low',
            'beat_coverage': _safe_round(beat_coverage, 3),
        },
    }


def analyze_ppg_waveform(samples, sampling_hz=None):
    if not samples:
        return {}

    offsets = np.array([float(item['offset_seconds']) for item in samples], dtype=float)
    raw = np.array([float(item['value']) for item in samples], dtype=float)
    sampling_hz = _estimate_sampling_hz(offsets, sampling_hz)
    filtered = _bandpass_filter(raw, sampling_hz, low_hz=0.4, high_hz=8.0)
    centered = filtered - np.median(filtered)
    prominence = max(np.std(centered) * 0.35, np.percentile(np.abs(centered), 70) * 0.20, 0.01)
    distance = max(1, int((sampling_hz or 125.0) * 0.35))
    peaks, _ = find_peaks(centered, distance=distance, prominence=prominence)

    rr_intervals = np.diff(offsets[peaks]) if len(peaks) >= 2 else np.array([])
    valid_rr = rr_intervals[(rr_intervals >= 0.33) & (rr_intervals <= 1.8)]
    beat_coverage = (len(valid_rr) / len(rr_intervals)) if len(rr_intervals) else 0.0
    variability_penalty = np.std(valid_rr) * 30.0 if len(valid_rr) >= 3 else 10.0
    artifact_metrics = _artifact_summary(raw)
    quality_score = _quality_score(artifact_metrics, beat_coverage=beat_coverage, variability_penalty=variability_penalty)

    pulse_amplitudes = centered[peaks] if len(peaks) else np.array([])
    dc_level = float(np.mean(np.abs(raw))) if len(raw) else 0.0
    perfusion_index = float(np.mean(np.abs(pulse_amplitudes)) / dc_level) if dc_level > 1e-9 and len(pulse_amplitudes) else None

    hrv = _hrv_features(valid_rr)
    rolling_metrics = _rolling_window_metrics(
        offsets,
        raw,
        peaks,
        valid_rr,
        sampling_hz,
        signal_type='ppg',
        window_seconds=60.0,
        step_seconds=30.0,
    )
    display_offsets, display_raw, display_filtered = _select_display_window(offsets, raw, filtered, window_seconds=180.0)
    display_offsets, display_raw, display_filtered = _downsample_for_display(
        display_offsets, display_raw, display_filtered, max_points=1800
    )
    display_peak_mask = (offsets[peaks] >= display_offsets[0]) if len(peaks) and len(display_offsets) else np.array([], dtype=bool)
    display_peak_times = offsets[peaks][display_peak_mask] if len(peaks) and len(display_offsets) else np.array([], dtype=float)
    display_peak_values = raw[peaks][display_peak_mask] if len(peaks) and len(display_offsets) else np.array([], dtype=float)

    return {
        'signal_type': 'ppg',
        'source': 'real',
        'sampling_hz': _safe_round(sampling_hz, 2),
        'waveform': {
            'timestamps': [round(float(value), 4) for value in display_offsets],
            'values': [round(float(value), 5) for value in display_raw],
            'filtered': [round(float(value), 5) for value in display_filtered],
            'peak_timestamps': [round(float(value), 4) for value in display_peak_times[:160]],
            'peak_values': [round(float(value), 5) for value in display_peak_values[:160]],
            'display_window_seconds': 180,
            'display_mode': 'recent_window_downsampled' if len(offsets) > len(display_offsets) else 'full_signal',
        },
        'features': {
            'pulse_rate_bpm': hrv.get('mean_hr_bpm'),
            'pulse_peak_count': int(len(peaks)),
            'pulse_amplitude_mean': _safe_round(np.mean(np.abs(pulse_amplitudes)) if len(pulse_amplitudes) else None, 5),
            'perfusion_index_proxy': _safe_round(perfusion_index, 5),
            'duration_seconds': _safe_round(offsets[-1] if len(offsets) else 0.0, 2),
        },
        'hrv': hrv,
        'rolling_metrics': rolling_metrics,
        'artifacts': artifact_metrics,
        'quality': {
            'score': _safe_round(quality_score, 1),
            'label': 'high' if quality_score >= 80 else 'moderate' if quality_score >= 55 else 'low',
            'beat_coverage': _safe_round(beat_coverage, 3),
        },
    }


def summarize_respiration_waveform(samples, sampling_hz=None):
    if not samples:
        return {}

    offsets = np.array([float(item['offset_seconds']) for item in samples], dtype=float)
    raw = np.array([float(item['value']) for item in samples], dtype=float)
    sampling_hz = _estimate_sampling_hz(offsets, sampling_hz)
    filtered = _bandpass_filter(raw, sampling_hz, low_hz=0.05, high_hz=0.8)
    centered = filtered - np.median(filtered)
    peaks, _ = find_peaks(centered, distance=max(1, int((sampling_hz or 25.0) * 1.0)), prominence=max(np.std(centered) * 0.2, 0.005))
    resp_rate = None
    if len(peaks) >= 2:
        rr = np.diff(offsets[peaks])
        valid = rr[(rr >= 1.0) & (rr <= 10.0)]
        if len(valid):
            resp_rate = 60.0 / float(np.mean(valid))

    return {
        'signal_type': 'respiration',
        'sampling_hz': _safe_round(sampling_hz, 2),
        'resp_rate_bpm': _safe_round(resp_rate, 1),
        'amplitude_std': _safe_round(np.std(centered), 5),
    }
