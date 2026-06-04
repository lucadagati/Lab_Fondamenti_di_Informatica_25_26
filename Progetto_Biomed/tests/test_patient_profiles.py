import unittest
from types import SimpleNamespace

from app.patient_profiles import infer_patient_profile, suggest_longitudinal_scenarios


class PatientProfilesTest(unittest.TestCase):
    def test_infer_respiratory_profile_from_notes(self):
        patient = SimpleNamespace(notes='BPCO moderata in follow-up domiciliare')
        profile = infer_patient_profile(patient)
        self.assertEqual(profile['key'], 'respiratory')
        self.assertEqual(profile['default_scenario'], 'stress')

    def test_longitudinal_scenarios_are_coherent_for_arrhythmic_patient(self):
        patient = SimpleNamespace(notes='Sintomi compatibili con aritmia parossistica')
        scenarios = suggest_longitudinal_scenarios(patient, n_sessions=4)
        self.assertIn('arrhythmia', scenarios)
        self.assertEqual(scenarios[0], 'normal')
        self.assertEqual(scenarios[1], 'arrhythmia')


if __name__ == '__main__':
    unittest.main()
