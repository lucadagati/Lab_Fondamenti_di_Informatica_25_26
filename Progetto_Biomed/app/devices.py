DEVICE_PROFILES = {
    'smartwatch_vitals': {
        'label': 'Smartwatch Vitals S2',
        'category': 'wearable',
        'signals': ['heart_rate', 'spo2', 'temperature', 'activity'],
        'supports_ecg': False,
        'sampling_options': [10, 30, 60],
        'noise_factor': 1.05,
    },
    'chest_strap_ecg': {
        'label': 'Chest Strap ECG Pro',
        'category': 'wearable',
        'signals': ['heart_rate', 'spo2', 'temperature', 'activity', 'ecg'],
        'supports_ecg': True,
        'sampling_options': [5, 10, 30],
        'noise_factor': 0.85,
    },
    'bedside_monitor': {
        'label': 'Bedside Monitor M7',
        'category': 'clinical',
        'signals': ['heart_rate', 'spo2', 'temperature', 'activity', 'ecg'],
        'supports_ecg': True,
        'sampling_options': [5, 10],
        'noise_factor': 0.75,
    },
    'home_patch': {
        'label': 'Home Patch One',
        'category': 'telemedicine',
        'signals': ['heart_rate', 'temperature', 'activity', 'ecg'],
        'supports_ecg': True,
        'sampling_options': [5, 10, 30],
        'noise_factor': 0.95,
    },
    'physionet_mitdb': {
        'label': 'PhysioNet MIT-BIH ECG',
        'category': 'public-dataset',
        'signals': ['heart_rate', 'ecg'],
        'supports_ecg': True,
        'sampling_options': [1],
        'noise_factor': 0.0,
    },
    'physionet_bidmc': {
        'label': 'PhysioNet BIDMC Vitals',
        'category': 'public-dataset',
        'signals': ['heart_rate', 'respiration', 'ppg'],
        'supports_ecg': False,
        'sampling_options': [1],
        'noise_factor': 0.0,
    },
}


DEFAULT_DEVICE_KEY = 'smartwatch_vitals'


def get_device_profile(device_key):
    return DEVICE_PROFILES.get(device_key, DEVICE_PROFILES[DEFAULT_DEVICE_KEY])


def get_device_choices():
    return [(key, profile['label']) for key, profile in DEVICE_PROFILES.items()]


def get_device_label(device_key):
    return get_device_profile(device_key)['label']
