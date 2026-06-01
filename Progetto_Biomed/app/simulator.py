"""
Synthetic wearable sensor data generator.

Generates realistic time-series data for:
  - Heart Rate (bpm)
  - SpO₂ (%)
  - Skin Temperature (°C)
  - Activity Level (0–1 normalised)

Supported scenarios: normal, exercise, stress, sleep, arrhythmia
"""

from __future__ import annotations

import numpy as np
from datetime import datetime, timedelta
from typing import Optional

from app.devices import get_device_profile


SCENARIOS = {
    'normal': {
        'hr_base': 72, 'hr_std': 3,  'hr_trend': 0,
        'spo2_base': 98,  'spo2_std': 0.5,
        'temp_base': 36.6, 'temp_std': 0.1,
        'activity_base': 0.10, 'activity_std': 0.05,
    },
    'exercise': {
        'hr_base': 115, 'hr_std': 12, 'hr_trend': 0.3,
        'spo2_base': 97,  'spo2_std': 1.0,
        'temp_base': 37.5, 'temp_std': 0.3,
        'activity_base': 0.80, 'activity_std': 0.15,
    },
    'stress': {
        'hr_base': 95, 'hr_std': 8,  'hr_trend': 0.1,
        'spo2_base': 97.5, 'spo2_std': 0.7,
        'temp_base': 36.9, 'temp_std': 0.15,
        'activity_base': 0.30, 'activity_std': 0.10,
    },
    'sleep': {
        'hr_base': 58, 'hr_std': 3,  'hr_trend': -0.05,
        'spo2_base': 96.5, 'spo2_std': 1.5,
        'temp_base': 36.2, 'temp_std': 0.10,
        'activity_base': 0.01, 'activity_std': 0.02,
    },
    'arrhythmia': {
        'hr_base': 80, 'hr_std': 20, 'hr_trend': 0,
        'spo2_base': 96,  'spo2_std': 1.5,
        'temp_base': 36.8, 'temp_std': 0.20,
        'activity_base': 0.10, 'activity_std': 0.05,
    },
}


def generate_session_data(
    duration_minutes: int = 60,
    sampling_interval_seconds: int = 10,
    patient_age: Optional[int] = None,
    scenario: str = 'normal',
    device_key: str = 'smartwatch_vitals',
) -> list:
    """
    Generate synthetic wearable sensor data for one monitoring session.

    Parameters
    ----------
    duration_minutes        : total session length
    sampling_interval_seconds : time between consecutive readings
    patient_age             : if provided, adjusts baseline HR for age
    scenario                : one of 'normal', 'exercise', 'stress',
                              'sleep', 'arrhythmia'

    Returns
    -------
    List of dicts with keys: timestamp, heart_rate, spo2, temperature,
    activity_level
    """
    params = dict(SCENARIOS.get(scenario, SCENARIOS['normal']))
    device_profile = get_device_profile(device_key)
    noise_factor = float(device_profile.get('noise_factor', 1.0))

    # Age-dependent HR correction (HR decreases ~0.2 bpm/year after 30)
    if patient_age and patient_age > 30:
        correction = max(0.80, 1.0 - (patient_age - 30) * 0.002)
        params['hr_base'] = int(params['hr_base'] * correction)

    n = int((duration_minutes * 60) / sampling_interval_seconds)
    t = np.linspace(0, duration_minutes, n)
    rng = np.random.default_rng()

    # Heart Rate
    hr = (
        params['hr_base']
        + params['hr_trend'] * t
        + 3.0 * np.sin(2 * np.pi * t / 25)   # slow respiratory sinus arrhythmia
        + rng.normal(0, params['hr_std'] * noise_factor, n)
    )
    if scenario == 'arrhythmia':
        spike_idx = rng.choice(n, size=max(1, n // 20), replace=False)
        hr[spike_idx] += rng.choice([-35, 45, 55], size=len(spike_idx))

    # SpO₂
    spo2 = params['spo2_base'] + rng.normal(0, params['spo2_std'] * noise_factor, n)
    desat_idx = rng.choice(n, size=max(1, n // 50), replace=False)
    spo2[desat_idx] -= rng.uniform(1.5, 4.0, size=len(desat_idx))

    # Temperature (slow sinusoidal circadian-like drift)
    temp = (
        params['temp_base']
        + 0.015 * np.sin(2 * np.pi * t / 60)
        + rng.normal(0, params['temp_std'] * noise_factor, n)
    )

    # Activity level
    activity = np.maximum(0, params['activity_base'] + rng.normal(0, params['activity_std'] * noise_factor, n))

    # Clip to physiological bounds
    hr       = np.clip(hr,       35, 200)
    spo2     = np.clip(spo2,     85, 100)
    temp     = np.clip(temp,     34.0, 42.0)
    activity = np.clip(activity, 0.0,  1.0)

    start_time = datetime.utcnow() - timedelta(minutes=duration_minutes)
    return [
        {
            'timestamp':      start_time + timedelta(seconds=i * sampling_interval_seconds),
            'heart_rate':     round(float(hr[i]),       1),
            'spo2':           round(float(spo2[i]),     1),
            'temperature':    round(float(temp[i]),     2),
            'activity_level': round(float(activity[i]), 3),
            'device_supports_ecg': bool(device_profile.get('supports_ecg')),
        }
        for i in range(n)
    ]
