from __future__ import annotations

from typing import Dict, List


CLINICAL_PROFILES: Dict[str, Dict[str, object]] = {
    'arrhythmic': {
        'label': 'aritmico',
        'keywords': ['aritmia', 'palpitazioni', 'cardiopatia ischemica'],
        'default_scenario': 'arrhythmia',
        'allowed_scenarios': ['normal', 'stress', 'sleep', 'arrhythmia'],
        'trajectory': ['normal', 'arrhythmia', 'stress', 'arrhythmia'],
        'preferred_device': 'chest_strap_ecg',
    },
    'respiratory': {
        'label': 'respiratorio',
        'keywords': ['bpco', 'respiratoria', 'post covid'],
        'default_scenario': 'stress',
        'allowed_scenarios': ['normal', 'sleep', 'stress'],
        'trajectory': ['normal', 'stress', 'sleep', 'stress'],
        'preferred_device': 'bedside_monitor',
    },
    'sleep_rest': {
        'label': 'riposo/nocturno',
        'keywords': ['notturno', 'fragilità geriatrica'],
        'default_scenario': 'sleep',
        'allowed_scenarios': ['sleep', 'normal', 'stress'],
        'trajectory': ['sleep', 'normal', 'sleep'],
        'preferred_device': 'bedside_monitor',
    },
    'athlete': {
        'label': 'atleta',
        'keywords': ['maratoneta', 'attività fisica intensa', 'atleta'],
        'default_scenario': 'exercise',
        'allowed_scenarios': ['exercise', 'normal', 'sleep'],
        'trajectory': ['exercise', 'normal', 'exercise', 'sleep'],
        'preferred_device': 'smartwatch_vitals',
    },
    'metabolic': {
        'label': 'metabolico/cardiovascolare',
        'keywords': ['diabete', 'metabolico', 'ipertensione', 'obesità', 'scompenso'],
        'default_scenario': 'normal',
        'allowed_scenarios': ['normal', 'stress', 'sleep'],
        'trajectory': ['normal', 'stress', 'normal'],
        'preferred_device': 'home_patch',
    },
    'recovery': {
        'label': 'follow-up/recupero',
        'keywords': ['post dimissione', 'follow-up', 'telemonitoraggio'],
        'default_scenario': 'normal',
        'allowed_scenarios': ['normal', 'sleep', 'stress'],
        'trajectory': ['stress', 'normal', 'normal'],
        'preferred_device': 'home_patch',
    },
    'autonomic_stress': {
        'label': 'stress autonomico',
        'keywords': ['stress'],
        'default_scenario': 'stress',
        'allowed_scenarios': ['stress', 'normal', 'sleep'],
        'trajectory': ['stress', 'normal', 'stress'],
        'preferred_device': 'smartwatch_vitals',
    },
    'stable': {
        'label': 'stabile',
        'keywords': [],
        'default_scenario': 'normal',
        'allowed_scenarios': ['normal', 'sleep', 'stress'],
        'trajectory': ['normal', 'normal', 'sleep'],
        'preferred_device': 'smartwatch_vitals',
    },
}


def infer_patient_profile(patient) -> Dict[str, object]:
    notes = (getattr(patient, 'notes', '') or '').lower()
    for profile_key, profile in CLINICAL_PROFILES.items():
        if any(keyword in notes for keyword in profile['keywords']):
            return {'key': profile_key, **profile}
    profile = CLINICAL_PROFILES['stable']
    return {'key': 'stable', **profile}


def build_patient_profile_map(patients) -> Dict[str, Dict[str, object]]:
    return {
        str(patient.id): {
            'key': profile['key'],
            'label': profile['label'],
            'default_scenario': profile['default_scenario'],
            'allowed_scenarios': list(profile['allowed_scenarios']),
            'trajectory': list(profile['trajectory']),
            'preferred_device': profile['preferred_device'],
        }
        for patient in patients
        for profile in [infer_patient_profile(patient)]
    }


def suggest_longitudinal_scenarios(patient, n_sessions: int = 3) -> List[str]:
    profile = infer_patient_profile(patient)
    trajectory = list(profile['trajectory'])
    if n_sessions <= len(trajectory):
        return trajectory[:n_sessions]
    output = []
    while len(output) < n_sessions:
        output.extend(trajectory)
    return output[:n_sessions]
