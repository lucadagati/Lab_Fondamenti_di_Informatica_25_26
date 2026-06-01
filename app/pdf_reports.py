import io
from datetime import datetime

from reportlab.lib import colors
from reportlab.lib.pagesizes import A4
from reportlab.lib.styles import ParagraphStyle, getSampleStyleSheet
from reportlab.lib.units import mm
from reportlab.platypus import Paragraph, SimpleDocTemplate, Spacer, Table, TableStyle


def _styles():
    styles = getSampleStyleSheet()
    styles.add(ParagraphStyle(name='SmallMuted', fontSize=9, leading=12, textColor=colors.HexColor('#52606d')))
    styles.add(ParagraphStyle(name='SectionHeading', fontSize=13, leading=16, textColor=colors.HexColor('#0f172a'), spaceAfter=6))
    return styles


def _safe_text(value, fallback='n/d'):
    if value is None or value == '':
        return fallback
    return str(value)


def _build_table(rows, col_widths=None):
    table = Table(rows, colWidths=col_widths, repeatRows=1)
    table.setStyle(TableStyle([
        ('BACKGROUND', (0, 0), (-1, 0), colors.HexColor('#e2e8f0')),
        ('TEXTCOLOR', (0, 0), (-1, 0), colors.HexColor('#0f172a')),
        ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
        ('GRID', (0, 0), (-1, -1), 0.35, colors.HexColor('#cbd5e1')),
        ('ROWBACKGROUNDS', (0, 1), (-1, -1), [colors.white, colors.HexColor('#f8fafc')]),
        ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
        ('VALIGN', (0, 0), (-1, -1), 'TOP'),
        ('FONTSIZE', (0, 0), (-1, -1), 9),
        ('LEADING', (0, 0), (-1, -1), 12),
        ('TOPPADDING', (0, 0), (-1, -1), 6),
        ('BOTTOMPADDING', (0, 0), (-1, -1), 6),
    ]))
    return table


def build_session_report_pdf(sess, ai_assessment, alerts):
    buffer = io.BytesIO()
    document = SimpleDocTemplate(buffer, pagesize=A4, leftMargin=16 * mm, rightMargin=16 * mm, topMargin=16 * mm, bottomMargin=16 * mm)
    styles = _styles()
    story = []

    story.append(Paragraph(f'Report sessione #{sess.id}', styles['Title']))
    story.append(Paragraph(f'Paziente: {_safe_text(sess.patient.name)}', styles['Heading3']))
    story.append(Paragraph(
        f'Device: {_safe_text(sess.device_id)} | Origine: {_safe_text(sess.source_name)} | Data: {sess.start_time.strftime("%d/%m/%Y %H:%M")}',
        styles['SmallMuted'],
    ))
    story.append(Spacer(1, 8))

    story.append(Paragraph('Sintesi clinica', styles['SectionHeading']))
    story.append(_build_table([
        ['Diagnosi AI', _safe_text(ai_assessment.get('label'))],
        ['Confidenza', f"{round(float(ai_assessment.get('confidence', 0)) * 100):.0f}%"],
        ['Rischio', _safe_text(ai_assessment.get('risk_level'))],
        ['Trend ML', _safe_text((ai_assessment.get('trend_prediction') or {}).get('label'))],
        ['Esito atteso', _safe_text((ai_assessment.get('therapy_plan') or {}).get('expected_outcome'))],
    ], col_widths=[55 * mm, 115 * mm]))
    story.append(Spacer(1, 10))

    story.append(Paragraph('Forecast numerico persistito', styles['SectionHeading']))
    audit_forecast = ai_assessment.get('audit_forecast') or {}
    story.append(_build_table([
        ['Finestra', 'FC prevista', 'SpO2 prevista', 'Temp prevista', 'Slope FC'],
        [
            _safe_text(audit_forecast.get('window_minutes')) + ' min',
            _safe_text(audit_forecast.get('heart_rate')),
            _safe_text(audit_forecast.get('spo2')),
            _safe_text(audit_forecast.get('temperature')),
            _safe_text(audit_forecast.get('heart_rate_slope')),
        ],
    ], col_widths=[30 * mm, 34 * mm, 34 * mm, 34 * mm, 38 * mm]))
    story.append(Spacer(1, 10))

    story.append(Paragraph('Feature estratte persistite', styles['SectionHeading']))
    audit_features = ai_assessment.get('audit_features') or {}
    feature_rows = [['Feature', 'Valore'],
        ['HR mean', _safe_text(audit_features.get('hr_mean'))],
        ['HR std', _safe_text(audit_features.get('hr_std'))],
        ['HR max', _safe_text(audit_features.get('hr_max'))],
        ['SpO2 mean', _safe_text(audit_features.get('spo2_mean'))],
        ['SpO2 min', _safe_text(audit_features.get('spo2_min'))],
        ['Temp mean', _safe_text(audit_features.get('temp_mean'))],
        ['Temp max', _safe_text(audit_features.get('temp_max'))],
        ['Activity mean', _safe_text(audit_features.get('activity_mean'))],
        ['Warning alerts', _safe_text(audit_features.get('warning_alerts'))],
        ['Critical alerts', _safe_text(audit_features.get('critical_alerts'))],
        ['Clinical risk score', _safe_text(audit_features.get('clinical_risk_score'))],
    ]
    story.append(_build_table(feature_rows, col_widths=[65 * mm, 105 * mm]))
    story.append(Spacer(1, 10))

    story.append(Paragraph('Razionale e terapie suggerite', styles['SectionHeading']))
    rationale = ai_assessment.get('rationale') or ['Nessun razionale disponibile']
    for item in rationale:
        story.append(Paragraph(f'- {_safe_text(item)}', styles['BodyText']))
    story.append(Spacer(1, 6))
    therapy_items = (ai_assessment.get('therapy_plan') or {}).get('items') or []
    therapy_rows = [['Categoria', 'Titolo', 'Dettagli']]
    for item in therapy_items:
        therapy_rows.append([
            _safe_text(item.get('category')),
            _safe_text(item.get('title')),
            _safe_text(item.get('details')),
        ])
    story.append(_build_table(therapy_rows, col_widths=[30 * mm, 52 * mm, 88 * mm]))
    story.append(Spacer(1, 10))

    story.append(Paragraph('Alert contestuali', styles['SectionHeading']))
    alert_rows = [['Timestamp', 'Tipo', 'Severita', 'Messaggio']]
    if alerts:
        for alert in alerts[:20]:
            alert_rows.append([
                alert.timestamp.strftime('%d/%m/%Y %H:%M'),
                _safe_text(alert.type),
                _safe_text(alert.severity),
                _safe_text(alert.message),
            ])
    else:
        alert_rows.append(['-', '-', '-', 'Nessun alert registrato'])
    story.append(_build_table(alert_rows, col_widths=[32 * mm, 34 * mm, 26 * mm, 78 * mm]))
    story.append(Spacer(1, 8))
    story.append(Paragraph(f'Generato il {datetime.utcnow().strftime("%d/%m/%Y %H:%M UTC")}', styles['SmallMuted']))

    document.build(story)
    buffer.seek(0)
    return buffer


def build_patient_timeline_pdf(patient, sessions, timeline_rows):
    buffer = io.BytesIO()
    document = SimpleDocTemplate(buffer, pagesize=A4, leftMargin=16 * mm, rightMargin=16 * mm, topMargin=16 * mm, bottomMargin=16 * mm)
    styles = _styles()
    story = []

    story.append(Paragraph(f'Timeline terapeutica paziente: {_safe_text(patient.name)}', styles['Title']))
    story.append(Paragraph(
        f'Età: {_safe_text(patient.age)} | Genere: {_safe_text(patient.gender)} | Sessioni: {len(sessions)}',
        styles['SmallMuted'],
    ))
    story.append(Spacer(1, 8))

    summary_rows = [['Indicatore', 'Valore'],
        ['Ultima diagnosi', _safe_text(sessions[-1].assessment.diagnosis_label if sessions and sessions[-1].assessment else None)],
        ['Ultimo outcome atteso', _safe_text(sessions[-1].assessment.therapy_expected_outcome if sessions and sessions[-1].assessment else None)],
        ['Alert cumulativi', str(sum(item.get('alert_count', 0) for item in timeline_rows))],
    ]
    story.append(Paragraph('Sintesi longitudinale', styles['SectionHeading']))
    story.append(_build_table(summary_rows, col_widths=[60 * mm, 110 * mm]))
    story.append(Spacer(1, 10))

    story.append(Paragraph('Evoluzione sessione per sessione', styles['SectionHeading']))
    rows = [['Sessione', 'Data', 'Diagnosi', 'Trend', 'Alert', 'Outcome']]
    for item in timeline_rows:
        rows.append([
            f"#{item.get('session_id')}",
            _safe_text(item.get('timestamp', '')[:16].replace('T', ' ')),
            _safe_text(item.get('diagnosis_label')),
            _safe_text(item.get('trend_label')),
            str(item.get('alert_count', 0)),
            _safe_text(item.get('expected_outcome')),
        ])
    story.append(_build_table(rows, col_widths=[18 * mm, 28 * mm, 34 * mm, 24 * mm, 16 * mm, 60 * mm]))
    story.append(Spacer(1, 8))
    story.append(Paragraph(f'Generato il {datetime.utcnow().strftime("%d/%m/%Y %H:%M UTC")}', styles['SmallMuted']))

    document.build(story)
    buffer.seek(0)
    return buffer
