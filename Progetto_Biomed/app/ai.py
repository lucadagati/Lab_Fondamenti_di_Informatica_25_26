import numpy as np
from sklearn.ensemble import RandomForestClassifier

from app.models import Session


def _safe_float(value, default=0.0):
    return default if value is None else float(value)


def _linear_slope(values):
    clean = np.array([v for v in values if v is not None], dtype=float)
    if len(clean) < 3:
        return 0.0
    x = np.arange(len(clean), dtype=float)
    slope, _ = np.polyfit(x, clean, 1)
    return float(slope)


def _session_means(measurements):
    return {
        'hr_mean': float(np.mean([m.heart_rate for m in measurements if m.heart_rate is not None])) if measurements else 0.0,
        'spo2_mean': float(np.mean([m.spo2 for m in measurements if m.spo2 is not None])) if measurements else 0.0,
        'temp_mean': float(np.mean([m.temperature for m in measurements if m.temperature is not None])) if measurements else 0.0,
        'activity_mean': float(np.mean([m.activity_level for m in measurements if m.activity_level is not None])) if measurements else 0.0,
    }


def _extract_session_features(measurements, alerts=None):
    hr_values = [m.heart_rate for m in measurements if m.heart_rate is not None]
    spo2_values = [m.spo2 for m in measurements if m.spo2 is not None]
    temp_values = [m.temperature for m in measurements if m.temperature is not None]
    activity_values = [m.activity_level for m in measurements if m.activity_level is not None]
    critical_alerts = sum(1 for alert in (alerts or []) if alert.severity == 'critical')
    warning_alerts = sum(1 for alert in (alerts or []) if alert.severity == 'warning')
    return {
        'hr_mean': float(np.mean(hr_values)) if hr_values else 0.0,
        'hr_std': float(np.std(hr_values)) if hr_values else 0.0,
        'spo2_mean': float(np.mean(spo2_values)) if spo2_values else 0.0,
        'spo2_min': float(np.min(spo2_values)) if spo2_values else 0.0,
        'temp_mean': float(np.mean(temp_values)) if temp_values else 0.0,
        'temp_max': float(np.max(temp_values)) if temp_values else 0.0,
        'activity_mean': float(np.mean(activity_values)) if activity_values else 0.0,
        'critical_alerts': float(critical_alerts),
        'warning_alerts': float(warning_alerts),
        'n_measurements': float(len(measurements)),
    }


def _clinical_risk_score(features):
    score = 0.0
    score += max(0.0, features['hr_std'] - 10) * 0.07
    score += max(0.0, 95.0 - features['spo2_mean']) * 0.8
    score += max(0.0, 92.0 - features['spo2_min']) * 1.2
    score += max(0.0, features['temp_max'] - 37.5) * 2.0
    score += features['critical_alerts'] * 0.7
    score += features['warning_alerts'] * 0.25
    return float(score)


def _trend_label(current_score, next_score):
    delta = next_score - current_score
    if delta >= 0.75:
        return 'peggioramento'
    if delta <= -0.75:
        return 'miglioramento'
    return 'stabile'


def _train_trend_model(patient, session_obj, current_features, historical_sessions):
    feature_order = [
        'hr_mean', 'hr_std', 'spo2_mean', 'spo2_min', 'temp_mean', 'temp_max',
        'activity_mean', 'critical_alerts', 'warning_alerts', 'n_measurements',
    ]
    transitions_x = []
    transitions_y = []

    all_sessions = Session.query.order_by(Session.patient_id, Session.start_time).all()
    grouped_sessions = {}
    for item in all_sessions:
        grouped_sessions.setdefault(item.patient_id, []).append(item)

    for patient_sessions in grouped_sessions.values():
        for idx in range(len(patient_sessions) - 1):
            current_session = patient_sessions[idx]
            next_session = patient_sessions[idx + 1]
            current_measurements = sorted(current_session.measurements, key=lambda item: item.timestamp)
            next_measurements = sorted(next_session.measurements, key=lambda item: item.timestamp)
            if not current_measurements or not next_measurements:
                continue
            current_alerts = list(current_session.alerts)
            next_alerts = list(next_session.alerts)
            current_vector = _extract_session_features(current_measurements, current_alerts)
            next_vector = _extract_session_features(next_measurements, next_alerts)
            current_score = _clinical_risk_score(current_vector)
            next_score = _clinical_risk_score(next_vector)
            transitions_x.append([current_vector[name] for name in feature_order])
            transitions_y.append(_trend_label(current_score, next_score))

    if len(set(transitions_y)) < 2 or len(transitions_x) < 6:
        return None

    model = RandomForestClassifier(
        n_estimators=120,
        max_depth=6,
        random_state=42,
        class_weight='balanced',
    )
    model.fit(transitions_x, transitions_y)
    current_vector = [current_features[name] for name in feature_order]
    probabilities = model.predict_proba([current_vector])[0]
    labels = model.classes_
    scores = {label: round(float(prob), 3) for label, prob in zip(labels, probabilities)}
    predicted_label = labels[int(np.argmax(probabilities))]
    confidence = round(float(np.max(probabilities)), 2)
    return {
        'label': predicted_label,
        'confidence': confidence,
        'scores': scores,
        'n_transitions': len(transitions_x),
        'model_name': 'RandomForestClassifier',
    }


def _rule_based_trend(current_features):
    risk_score = _clinical_risk_score(current_features)
    if risk_score >= 6.0:
        label = 'peggioramento'
        scores = {'peggioramento': 0.72, 'stabile': 0.18, 'miglioramento': 0.10}
    elif risk_score <= 1.25:
        label = 'miglioramento'
        scores = {'miglioramento': 0.58, 'stabile': 0.30, 'peggioramento': 0.12}
    else:
        label = 'stabile'
        scores = {'stabile': 0.54, 'miglioramento': 0.18, 'peggioramento': 0.28}
    return {
        'label': label,
        'confidence': round(scores[label], 2),
        'scores': scores,
        'n_transitions': 0,
        'model_name': 'clinical-risk fallback',
    }


def _therapy_suggestions(label, risk_level, metrics, trend_prediction):
    suggestions = []

    if label == 'sospetta aritmia':
        suggestions.extend([
            {
                'title': 'Monitoraggio ECG continuo e valutazione cardiologica',
                'category': 'diagnostico',
                'details': 'Suggerire Holter/telemetria, revisione del ritmo e correlazione con i sintomi riferiti.',
            },
            {
                'title': 'Ottimizzazione di idratazione, elettroliti e trigger',
                'category': 'supportivo',
                'details': 'Verificare fattori precipitanti come caffeina, stress, deprivazione di sonno o squilibri elettrolitici.',
            },
        ])

    if label == 'rischio respiratorio':
        suggestions.extend([
            {
                'title': 'Valutazione dell’ossigenoterapia e saturimetria ravvicinata',
                'category': 'respiratorio',
                'details': 'Incrementare il controllo della SpO₂ e valutare supporto respiratorio secondo protocollo clinico.',
            },
            {
                'title': 'Riduzione dello sforzo e osservazione dei sintomi respiratori',
                'category': 'supportivo',
                'details': 'Limitare attività intensa e registrare dispnea, tosse o peggioramento notturno.',
            },
        ])

    if label == 'rischio infettivo':
        suggestions.extend([
            {
                'title': 'Controllo seriato della temperatura e valutazione medica',
                'category': 'infettivo',
                'details': 'Integrare segni sistemici, anamnesi e possibile terapia antipiretica/antinfettiva secondo indicazione clinica.',
            },
        ])

    if label == 'stress autonomico':
        suggestions.extend([
            {
                'title': 'Riduzione dei trigger simpatici',
                'category': 'comportamentale',
                'details': 'Suggerire pausa, respirazione guidata, controllo di caffeina e gestione dello stress.',
            },
        ])

    if label == 'profilo sonno/riposo':
        suggestions.extend([
            {
                'title': 'Mantenere monitoraggio conservativo',
                'category': 'follow-up',
                'details': 'Pattern compatibile con riposo; mantenere osservazione e confrontare con lo storico del paziente.',
            },
        ])

    if not suggestions:
        suggestions.append({
            'title': 'Proseguire follow-up clinico standard',
            'category': 'follow-up',
            'details': 'Non emergono interventi prioritari; mantenere trend analysis e confronto con baseline del paziente.',
        })

    expected = 'stabilità clinica attesa'
    if trend_prediction['label'] == 'miglioramento':
        expected = 'probabile miglioramento nel breve termine se il contesto resta invariato'
    elif trend_prediction['label'] == 'peggioramento':
        expected = 'probabile peggioramento nel breve termine; raccomandato incremento del monitoraggio'

    if risk_level == 'high':
        expected = 'alto rischio di deterioramento: indicata escalation clinica e revisione terapeutica rapida'

    return {
        'items': suggestions[:3],
        'expected_outcome': expected,
    }


def build_ai_assessment(patient, session_obj, measurements, historical_sessions, alerts=None):
    if not measurements:
        return {
            'label': 'Dati insufficienti',
            'confidence': 0.0,
            'risk_level': 'low',
            'rationale': [],
            'forecast': {},
            'history_delta': {},
        }

    hr_values = [m.heart_rate for m in measurements if m.heart_rate is not None]
    spo2_values = [m.spo2 for m in measurements if m.spo2 is not None]
    temp_values = [m.temperature for m in measurements if m.temperature is not None]
    activity_values = [m.activity_level for m in measurements if m.activity_level is not None]
    current_features = _extract_session_features(measurements, alerts)

    hr_mean = float(np.mean(hr_values)) if hr_values else 0.0
    hr_std = float(np.std(hr_values)) if hr_values else 0.0
    hr_max = float(np.max(hr_values)) if hr_values else 0.0
    spo2_mean = float(np.mean(spo2_values)) if spo2_values else 0.0
    spo2_min = float(np.min(spo2_values)) if spo2_values else 0.0
    temp_mean = float(np.mean(temp_values)) if temp_values else 0.0
    temp_max = float(np.max(temp_values)) if temp_values else 0.0
    activity_mean = float(np.mean(activity_values)) if activity_values else 0.0

    hr_slope = _linear_slope(hr_values)
    spo2_slope = _linear_slope(spo2_values)
    temp_slope = _linear_slope(temp_values)

    history_means = []
    for past_session in historical_sessions:
        session_measurements = sorted(past_session.measurements, key=lambda item: item.timestamp)
        if session_measurements:
            history_means.append(_session_means(session_measurements))

    baseline = {
        'hr_mean': float(np.mean([item['hr_mean'] for item in history_means])) if history_means else hr_mean,
        'spo2_mean': float(np.mean([item['spo2_mean'] for item in history_means])) if history_means else spo2_mean,
        'temp_mean': float(np.mean([item['temp_mean'] for item in history_means])) if history_means else temp_mean,
        'activity_mean': float(np.mean([item['activity_mean'] for item in history_means])) if history_means else activity_mean,
    }

    alert_types = [alert.type for alert in (alerts or [])]
    critical_alerts = sum(1 for alert in (alerts or []) if alert.severity == 'critical')

    scores = {
        'stato fisiologico stabile': 0.18,
        'risposta da esercizio': 0.10,
        'stress autonomico': 0.10,
        'sospetta aritmia': 0.10,
        'rischio respiratorio': 0.10,
        'rischio infettivo': 0.10,
        'profilo sonno/riposo': 0.10,
    }
    rationale = []

    if activity_mean > 0.55 and 95 <= hr_mean <= 145 and spo2_mean >= 95:
        scores['risposta da esercizio'] += 0.55
        rationale.append('FC elevata ma coerente con attività elevata e ossigenazione conservata.')

    if activity_mean < 0.35 and hr_std > 14:
        scores['sospetta aritmia'] += min(0.55, hr_std / 35)
        rationale.append('Elevata variabilità della frequenza cardiaca a bassa attività.')

    if 'arrhythmia_suspected' in alert_types or critical_alerts >= 3:
        scores['sospetta aritmia'] += 0.35
        rationale.append('La distribuzione degli alert suggerisce episodi ritmici non fisiologici.')

    if spo2_mean < 95 or spo2_min < 92:
        scores['rischio respiratorio'] += 0.45 + max(0.0, (95 - spo2_mean) / 8)
        rationale.append('Riduzione persistente della saturazione, compatibile con stress respiratorio.')

    if temp_mean > 37.6 or temp_max > 38.0:
        scores['rischio infettivo'] += 0.45 + max(0.0, (temp_max - 37.8) / 2)
        rationale.append('Temperatura media e picco termico compatibili con quadro febbrile.')

    if activity_mean < 0.12 and hr_mean < 65 and spo2_mean >= 95 and temp_mean < 36.6:
        scores['profilo sonno/riposo'] += 0.50
        rationale.append('Bassa attività e parametri compatibili con riposo o sonno.')

    if activity_mean < 0.35 and hr_mean > 90 and hr_std < 12 and spo2_mean >= 95:
        scores['stress autonomico'] += 0.42
        rationale.append('FC relativamente alta a bassa attività senza desaturazione significativa.')

    if history_means and abs(hr_mean - baseline['hr_mean']) < 8 and abs(spo2_mean - baseline['spo2_mean']) < 1.2 and abs(temp_mean - baseline['temp_mean']) < 0.3 and critical_alerts == 0:
        scores['stato fisiologico stabile'] += 0.28
        rationale.append('Scostamento minimo rispetto al profilo storico del paziente.')

    if not history_means and critical_alerts == 0 and hr_std < 8 and spo2_mean >= 95 and temp_mean < 37.4:
        scores['stato fisiologico stabile'] += 0.20
        rationale.append('Pattern complessivamente regolare, in assenza di alert critici e di derive sfavorevoli.')

    label = max(scores, key=scores.get)
    confidence = round(min(0.97, scores[label]), 2)

    forecast_hr = round(hr_mean + (hr_slope * 18), 1)
    forecast_spo2 = round(spo2_mean + (spo2_slope * 18), 1)
    forecast_temp = round(temp_mean + (temp_slope * 18), 2)

    forecast_risk = 'low'
    if forecast_spo2 < 94 or forecast_temp > 37.8 or forecast_hr > 125:
        forecast_risk = 'medium'
    if forecast_spo2 < 92 or forecast_temp > 38.3 or forecast_hr > 145:
        forecast_risk = 'high'
    if label == 'sospetta aritmia' and forecast_risk == 'low':
        forecast_risk = 'medium'

    history_delta = {
        'hr_mean': round(hr_mean - baseline['hr_mean'], 1),
        'spo2_mean': round(spo2_mean - baseline['spo2_mean'], 1),
        'temp_mean': round(temp_mean - baseline['temp_mean'], 2),
        'activity_mean': round(activity_mean - baseline['activity_mean'], 2),
    }
    clinical_risk_score = round(_clinical_risk_score(current_features), 3)

    if not rationale:
        rationale.append('Il pattern non mostra deviazioni clinicamente rilevanti rispetto al baseline disponibile.')

    trend_prediction = _train_trend_model(patient, session_obj, current_features, historical_sessions)
    if trend_prediction is None:
        trend_prediction = _rule_based_trend(current_features)

    therapy_plan = _therapy_suggestions(label, forecast_risk, {
        'hr_mean': hr_mean,
        'hr_std': hr_std,
        'spo2_mean': spo2_mean,
        'spo2_min': spo2_min,
        'temp_mean': temp_mean,
        'temp_max': temp_max,
        'activity_mean': activity_mean,
    }, trend_prediction)

    audit_features = {
        'hr_mean': round(hr_mean, 3),
        'hr_std': round(hr_std, 3),
        'hr_max': round(hr_max, 3),
        'spo2_mean': round(spo2_mean, 3),
        'spo2_min': round(spo2_min, 3),
        'temp_mean': round(temp_mean, 3),
        'temp_max': round(temp_max, 3),
        'activity_mean': round(activity_mean, 4),
        'warning_alerts': float(current_features['warning_alerts']),
        'critical_alerts': float(current_features['critical_alerts']),
        'n_measurements': float(current_features['n_measurements']),
        'clinical_risk_score': clinical_risk_score,
        'history_sessions': len(history_means),
        'model_name': 'clinical-feature extractor',
    }
    audit_forecast = {
        'window_minutes': 30,
        'forecast_risk': forecast_risk,
        'heart_rate': forecast_hr,
        'spo2': forecast_spo2,
        'temperature': forecast_temp,
        'heart_rate_slope': round(hr_slope, 5),
        'spo2_slope': round(spo2_slope, 5),
        'temperature_slope': round(temp_slope, 5),
        'model_name': 'linear-short-term forecast',
    }

    return {
        'label': label,
        'confidence': confidence,
        'risk_level': forecast_risk,
        'rationale': rationale[:4],
        'forecast': {
            'window_minutes': 30,
            'heart_rate': forecast_hr,
            'spo2': forecast_spo2,
            'temperature': forecast_temp,
            'risk_level': forecast_risk,
        },
        'history_delta': history_delta,
        'trend_prediction': trend_prediction,
        'therapy_plan': therapy_plan,
        'metrics': {
            'hr_mean': round(hr_mean, 1),
            'hr_std': round(hr_std, 1),
            'spo2_mean': round(spo2_mean, 1),
            'spo2_min': round(spo2_min, 1),
            'temp_mean': round(temp_mean, 2),
            'temp_max': round(temp_max, 2),
            'activity_mean': round(activity_mean, 2),
            'history_sessions': len(history_means),
        },
        'audit_features': audit_features,
        'audit_forecast': audit_forecast,
    }
