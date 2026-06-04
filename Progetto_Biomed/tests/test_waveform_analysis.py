import math
import unittest

import numpy as np

from app.waveform_analysis import analyze_ecg_waveform, analyze_ppg_waveform


class WaveformAnalysisTest(unittest.TestCase):
    def test_ecg_analysis_extracts_hrv_and_quality(self):
        sampling_hz = 180.0
        duration_seconds = 180.0
        time_axis = np.arange(0.0, duration_seconds, 1.0 / sampling_hz)
        signal = np.zeros_like(time_axis)
        beat_times = np.arange(0.6, duration_seconds, 0.86)

        for beat_time in beat_times:
            signal += 1.10 * np.exp(-((time_axis - beat_time) ** 2) / 0.00018)
            signal += -0.18 * np.exp(-((time_axis - (beat_time - 0.03)) ** 2) / 0.00035)
            signal += 0.25 * np.exp(-((time_axis - (beat_time + 0.22)) ** 2) / 0.006)

        signal += 0.02 * np.sin(2 * np.pi * time_axis * 0.3)

        samples = [
            {
                'sample_index': index,
                'offset_seconds': float(offset),
                'value': float(value),
            }
            for index, (offset, value) in enumerate(zip(time_axis, signal))
        ]

        analysis = analyze_ecg_waveform(samples, sampling_hz=sampling_hz)
        self.assertEqual(analysis['signal_type'], 'ecg')
        self.assertGreater(analysis['quality']['score'], 60.0)
        self.assertGreater(analysis['features']['qrs_peak_count'], 100)
        self.assertIsNotNone(analysis['hrv']['sdnn_ms'])
        self.assertIsNotNone(analysis['hrv']['rmssd_ms'])
        self.assertTrue(analysis['rolling_metrics'])
        self.assertIn(analysis['waveform']['display_mode'], {'full_signal', 'recent_window_downsampled'})

    def test_ppg_analysis_extracts_pulse_features(self):
        sampling_hz = 125.0
        duration_seconds = 240.0
        time_axis = np.arange(0.0, duration_seconds, 1.0 / sampling_hz)
        pulse_period = 0.92
        signal = 0.55 + 0.02 * np.sin(2 * np.pi * time_axis * 0.15)

        for beat_time in np.arange(0.5, duration_seconds, pulse_period):
            signal += 0.18 * np.exp(-((time_axis - beat_time) ** 2) / 0.006)
            signal += 0.04 * np.exp(-((time_axis - (beat_time + 0.18)) ** 2) / 0.02)

        signal += 0.005 * np.sin(2 * np.pi * time_axis * 4.0)

        samples = [
            {
                'sample_index': index,
                'offset_seconds': float(offset),
                'value': float(value),
                'sampling_hz': sampling_hz,
            }
            for index, (offset, value) in enumerate(zip(time_axis, signal))
        ]

        analysis = analyze_ppg_waveform(samples, sampling_hz=sampling_hz)
        self.assertEqual(analysis['signal_type'], 'ppg')
        self.assertGreater(analysis['quality']['score'], 65.0)
        self.assertGreater(analysis['features']['pulse_peak_count'], 150)
        self.assertTrue(math.isfinite(analysis['features']['perfusion_index_proxy']))
        self.assertIsNotNone(analysis['hrv']['mean_hr_bpm'])
        self.assertTrue(analysis['rolling_metrics'])


if __name__ == '__main__':
    unittest.main()
