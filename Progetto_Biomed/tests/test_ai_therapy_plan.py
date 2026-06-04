import unittest

from app.ai import _therapy_suggestions


class TherapyPlanScenarioTest(unittest.TestCase):
    def test_respiratory_treatment_generates_counterfactual(self):
        current_features = {
            'hr_mean': 108.0,
            'hr_std': 9.5,
            'spo2_mean': 91.8,
            'spo2_min': 89.6,
            'temp_mean': 36.9,
            'temp_max': 37.1,
            'activity_mean': 0.18,
            'critical_alerts': 2.0,
            'warning_alerts': 4.0,
            'n_measurements': 600.0,
        }
        metrics = {
            'hr_mean': 108.0,
            'hr_std': 9.5,
            'spo2_mean': 91.8,
            'spo2_min': 89.6,
            'temp_mean': 36.9,
            'temp_max': 37.1,
            'activity_mean': 0.18,
        }
        trend_prediction = {
            'label': 'peggioramento',
            'confidence': 0.74,
            'scores': {'peggioramento': 0.74, 'stabile': 0.18, 'miglioramento': 0.08},
            'n_transitions': 0,
            'model_name': 'clinical-risk fallback',
        }

        plan = _therapy_suggestions(
            'rischio respiratorio',
            'high',
            metrics,
            trend_prediction,
            current_features,
            trend_model_bundle=None,
        )

        self.assertTrue(plan['items'])
        scenario = plan['items'][0]['scenario']
        self.assertIn('projected_risk_level', scenario)
        self.assertIn('projected_metrics', scenario)
        self.assertLess(scenario['risk_score_delta'], 0.0)
        self.assertGreaterEqual(scenario['projected_metrics']['spo2'], metrics['spo2_mean'])


if __name__ == '__main__':
    unittest.main()
