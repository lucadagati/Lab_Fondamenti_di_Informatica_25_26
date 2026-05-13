from xml.etree.ElementTree import Element, SubElement, tostring
from xml.dom import minidom
from pathlib import Path

OUT = Path('08-progettazione-er/diagrammi-drawio/esercizi')
OUT.mkdir(parents=True, exist_ok=True)

SPECS = {
    '01-d0-concettuale': {
        'entities': {
            'PAZIENTE': [('PK id_paziente', True), ('nome', False), ('cognome', False)],
            'PROGRAMMA': [('PK id_programma', True), ('AK codice_programma', False), ('stato', False)],
            'SEDUTA': [('PK id_seduta', True), ('data_ora', False), ('durata_min', False)],
        },
        'relationships': [
            ('SEGUE', 'PAZIENTE', '1', 'N', 'PROGRAMMA'),
            ('INCLUDE', 'PROGRAMMA', '1', 'N', 'SEDUTA'),
        ],
    },
    '01-d1-concettuale': {
        'entities': {
            'PAZIENTE': [('PK id_paziente', True), ('nome', False)],
            'PROGRAMMA': [('PK id_programma', True), ('AK codice_programma', False)],
            'SEDUTA': [('PK id_seduta', True), ('data_ora', False)],
            'FISIOTERAPISTA': [('PK id_fisio', True), ('AK matricola', False), ('specializzazione', False)],
        },
        'relationships': [
            ('SEGUE', 'PAZIENTE', '1', 'N', 'PROGRAMMA'),
            ('INCLUDE', 'PROGRAMMA', '1', 'N', 'SEDUTA'),
            ('REFERENTE', 'PROGRAMMA', 'N', '1', 'FISIOTERAPISTA'),
            ('CONDOTTA_DA', 'SEDUTA', 'N', '1', 'FISIOTERAPISTA'),
        ],
    },
    '01-d2-concettuale': {
        'entities': {
            'PAZIENTE': [('PK id_paziente', True)],
            'PROGRAMMA': [('PK id_programma', True)],
            'SEDUTA': [('PK id_seduta', True)],
            'FISIOTERAPISTA': [('PK id_fisio', True)],
            'VALUTAZIONE': [('PK id_valutazione', True), ('data_valutazione', False)],
            'INDICATORE_CLINICO': [('PK id_indicatore', True), ('nome', False)],
        },
        'relationships': [
            ('SEGUE', 'PAZIENTE', '1', 'N', 'PROGRAMMA'),
            ('INCLUDE', 'PROGRAMMA', '1', 'N', 'SEDUTA'),
            ('RICEVE', 'PAZIENTE', '1', 'N', 'VALUTAZIONE'),
            ('PREVEDE', 'PROGRAMMA', '1', 'N', 'VALUTAZIONE'),
            ('MISURA', 'VALUTAZIONE', '1', 'N', 'INDICATORE_CLINICO'),
        ],
    },
    '01-d3-concettuale': {
        'entities': {
            'PAZIENTE': [('PK id_paziente', True)],
            'PROGRAMMA': [('PK id_programma', True)],
            'SEDUTA': [('PK id_seduta', True)],
            'FISIOTERAPISTA': [('PK id_fisio', True)],
            'VALUTAZIONE': [('PK id_valutazione', True)],
            'INDICATORE_CLINICO': [('PK id_indicatore', True)],
        },
        'relationships': [
            ('SEGUE', 'PAZIENTE', '1', 'N', 'PROGRAMMA'),
            ('INCLUDE', 'PROGRAMMA', '1', 'N', 'SEDUTA'),
            ('CONDOTTA_DA', 'SEDUTA', 'N', '1', 'FISIOTERAPISTA'),
            ('REFERENTE', 'PROGRAMMA', 'N', '1', 'FISIOTERAPISTA'),
            ('RICEVE', 'PAZIENTE', '1', 'N', 'VALUTAZIONE'),
            ('MISURA', 'VALUTAZIONE', '1', 'N', 'INDICATORE_CLINICO'),
        ],
    },
    '01-er-finale': {
        'entities': {
            'PAZIENTE': [('PK id_paziente', True), ('AK codice_fiscale', False)],
            'PROGRAMMA': [('PK id_programma', True), ('AK codice_programma', False)],
            'SEDUTA': [('PK id_seduta', True)],
            'FISIOTERAPISTA': [('PK id_fisio', True), ('AK matricola', False)],
            'VALUTAZIONE': [('PK id_valutazione', True)],
            'MISURA_VALUTAZIONE': [('PK id_misura', True)],
            'TIPO_INDICATORE': [('PK id_tipo', True), ('AK nome', False)],
        },
        'relationships': [
            ('SEGUE', 'PAZIENTE', '1', 'N', 'PROGRAMMA'),
            ('REFERENTE', 'PROGRAMMA', 'N', '1', 'FISIOTERAPISTA'),
            ('INCLUDE', 'PROGRAMMA', '1', 'N', 'SEDUTA'),
            ('CONDUCE', 'FISIOTERAPISTA', '1', 'N', 'SEDUTA'),
            ('RICEVE', 'PAZIENTE', '1', 'N', 'VALUTAZIONE'),
            ('PREVEDE', 'PROGRAMMA', '1', 'N', 'VALUTAZIONE'),
            ('CONTIENE', 'VALUTAZIONE', '1', 'N', 'MISURA_VALUTAZIONE'),
            ('CLASSIFICA', 'TIPO_INDICATORE', '1', 'N', 'MISURA_VALUTAZIONE'),
        ],
    },

    '02-d0-concettuale': {
        'entities': {
            'PAZIENTE': [('PK id_paziente', True), ('AK codice_fiscale', False)],
            'RICHIESTA': [('PK id_richiesta', True), ('data_richiesta', False)],
            'CAMPIONE': [('PK barcode', True), ('tipo', False)],
        },
        'relationships': [
            ('RICHIEDE', 'PAZIENTE', '1', 'N', 'RICHIESTA'),
            ('GENERA', 'RICHIESTA', '1', 'N', 'CAMPIONE'),
        ],
    },
    '02-d1-concettuale': {
        'entities': {
            'PAZIENTE': [('PK id_paziente', True)],
            'RICHIESTA': [('PK id_richiesta', True)],
            'CAMPIONE': [('PK barcode', True)],
            'ESAME': [('PK id_esame', True), ('AK codice_esame', False)],
            'RISULTATO': [('PK id_risultato', True), ('valore', False)],
            'STRUMENTO': [('PK id_strumento', True), ('AK matricola', False)],
        },
        'relationships': [
            ('RICHIEDE', 'PAZIENTE', '1', 'N', 'RICHIESTA'),
            ('GENERA', 'RICHIESTA', '1', 'N', 'CAMPIONE'),
            ('SUPPORTA', 'CAMPIONE', 'N', 'M', 'ESAME'),
            ('PRODUCE', 'CAMPIONE', '1', 'N', 'RISULTATO'),
            ('RIFERITO_A', 'RISULTATO', 'N', '1', 'ESAME'),
            ('ESEGUITO_CON', 'RISULTATO', 'N', '1', 'STRUMENTO'),
        ],
    },
    '02-d2-concettuale': {
        'entities': {
            'PAZIENTE': [('PK id_paziente', True)],
            'MEDICO_PRESCRITTORE': [('PK id_medico', True), ('AK cod_albo', False)],
            'RICHIESTA': [('PK id_richiesta', True)],
            'CAMPIONE': [('PK barcode', True)],
            'ESAME': [('PK id_esame', True)],
            'RISULTATO': [('PK id_risultato', True)],
            'STRUMENTO': [('PK id_strumento', True)],
            'REFERTO': [('PK id_referto', True), ('AK numero_referto', False)],
        },
        'relationships': [
            ('RICHIEDE', 'PAZIENTE', '1', 'N', 'RICHIESTA'),
            ('PRESCRIVE', 'MEDICO_PRESCRITTORE', '1', 'N', 'RICHIESTA'),
            ('GENERA', 'RICHIESTA', '1', 'N', 'CAMPIONE'),
            ('PRODUCE', 'CAMPIONE', '1', 'N', 'RISULTATO'),
            ('RIFERITO_A', 'RISULTATO', 'N', '1', 'ESAME'),
            ('ESEGUITO_CON', 'RISULTATO', 'N', '1', 'STRUMENTO'),
            ('INCLUSO_IN', 'RISULTATO', 'N', '1', 'REFERTO'),
        ],
    },
    '02-er-finale': {
        'entities': {
            'PAZIENTE': [('PK id_paziente', True), ('AK codice_fiscale', False)],
            'MEDICO_PRESCRITTORE': [('PK id_medico', True), ('AK cod_albo', False)],
            'RICHIESTA': [('PK id_richiesta', True)],
            'CAMPIONE': [('PK barcode', True)],
            'RICHIESTA_ESAME': [('PK id_rich_esame', True)],
            'ESAME': [('PK id_esame', True), ('AK codice_esame', False)],
            'RISULTATO': [('PK id_risultato', True)],
            'STRUMENTO': [('PK id_strumento', True), ('AK matricola', False)],
            'REFERTO': [('PK id_referto', True), ('AK numero_referto', False)],
        },
        'relationships': [
            ('APRE', 'PAZIENTE', '1', 'N', 'RICHIESTA'),
            ('PRESCRIVE', 'MEDICO_PRESCRITTORE', '1', 'N', 'RICHIESTA'),
            ('GENERA', 'RICHIESTA', '1', 'N', 'CAMPIONE'),
            ('CONTIENE', 'RICHIESTA', '1', 'N', 'RICHIESTA_ESAME'),
            ('RICHIESTO', 'ESAME', '1', 'N', 'RICHIESTA_ESAME'),
            ('PRODUCE', 'CAMPIONE', '1', 'N', 'RISULTATO'),
            ('CLASSIFICA', 'ESAME', '1', 'N', 'RISULTATO'),
            ('ESEGUE', 'STRUMENTO', '1', 'N', 'RISULTATO'),
            ('INCLUDE', 'REFERTO', '1', 'N', 'RISULTATO'),
        ],
    },

    '03-d0-concettuale': {
        'entities': {
            'PAZIENTE': [('PK id_paziente', True)],
            'VIDEO_VISITA': [('PK id_vv', True), ('data_ora', False)],
            'MEDICO': [('PK id_medico', True), ('AK cod_albo', False)],
        },
        'relationships': [
            ('EFFETTUA', 'PAZIENTE', '1', 'N', 'VIDEO_VISITA'),
            ('CON', 'VIDEO_VISITA', 'N', '1', 'MEDICO'),
        ],
    },
    '03-d1-concettuale': {
        'entities': {
            'PAZIENTE': [('PK id_paziente', True)],
            'VIDEO_VISITA': [('PK id_vv', True)],
            'MEDICO': [('PK id_medico', True)],
            'DISPOSITIVO': [('PK id_disp', True), ('AK seriale', False)],
            'MISURA': [('PK id_misura', True), ('valore', False)],
        },
        'relationships': [
            ('EFFETTUA', 'PAZIENTE', '1', 'N', 'VIDEO_VISITA'),
            ('CON', 'VIDEO_VISITA', 'N', '1', 'MEDICO'),
            ('USA', 'PAZIENTE', '1', 'N', 'DISPOSITIVO'),
            ('REGISTRA', 'DISPOSITIVO', '1', 'N', 'MISURA'),
            ('PRODUCE_STORICO', 'PAZIENTE', '1', 'N', 'MISURA'),
        ],
    },
    '03-d2-concettuale': {
        'entities': {
            'PAZIENTE': [('PK id_paziente', True)],
            'MEDICO': [('PK id_medico', True)],
            'PIANO_TERAPEUTICO': [('PK id_piano', True)],
            'DISPOSITIVO': [('PK id_disp', True)],
            'MISURA': [('PK id_misura', True)],
            'ALERT': [('PK id_alert', True), ('stato', False)],
        },
        'relationships': [
            ('SEGUE', 'PAZIENTE', '1', 'N', 'PIANO_TERAPEUTICO'),
            ('DEFINISCE', 'MEDICO', '1', 'N', 'PIANO_TERAPEUTICO'),
            ('USA', 'PAZIENTE', '1', 'N', 'DISPOSITIVO'),
            ('REGISTRA', 'DISPOSITIVO', '1', 'N', 'MISURA'),
            ('GENERA', 'MISURA', '1', 'N', 'ALERT'),
            ('CONTESTUALIZZA', 'PIANO_TERAPEUTICO', '1', 'N', 'ALERT'),
        ],
    },
    '03-er-finale': {
        'entities': {
            'PAZIENTE': [('PK id_paziente', True), ('AK codice_fiscale', False)],
            'VIDEO_VISITA': [('PK id_vv', True)],
            'MEDICO': [('PK id_medico', True), ('AK cod_albo', False)],
            'PIANO_TERAPEUTICO': [('PK id_piano', True)],
            'DISPOSITIVO': [('PK id_disp', True), ('AK seriale', False)],
            'MISURA': [('PK id_misura', True)],
            'TIPO_MISURA': [('PK id_tipo', True), ('AK nome', False)],
            'ALERT': [('PK id_alert', True)],
        },
        'relationships': [
            ('EFFETTUA', 'PAZIENTE', '1', 'N', 'VIDEO_VISITA'),
            ('CONDUCE', 'MEDICO', '1', 'N', 'VIDEO_VISITA'),
            ('SEGUE', 'PAZIENTE', '1', 'N', 'PIANO_TERAPEUTICO'),
            ('DEFINISCE', 'MEDICO', '1', 'N', 'PIANO_TERAPEUTICO'),
            ('USA', 'PAZIENTE', '1', 'N', 'DISPOSITIVO'),
            ('REGISTRA', 'DISPOSITIVO', '1', 'N', 'MISURA'),
            ('CLASSIFICA', 'TIPO_MISURA', '1', 'N', 'MISURA'),
            ('GENERA', 'MISURA', '1', 'N', 'ALERT'),
            ('CONTESTUALIZZA', 'PIANO_TERAPEUTICO', '1', 'N', 'ALERT'),
        ],
    },

    '04-d0-concettuale': {
        'entities': {
            'FARMACO': [('PK id_farmaco', True), ('AK codice_aic', False)],
            'LOTTO': [('PK id_lotto', True), ('codice_lotto', False)],
            'REPARTO': [('PK id_reparto', True), ('AK codice_reparto', False)],
        },
        'relationships': [
            ('CONTENUTO_IN', 'FARMACO', '1', 'N', 'LOTTO'),
            ('STOCCATO_IN', 'LOTTO', 'N', 'M', 'REPARTO'),
        ],
    },
    '04-d1-concettuale': {
        'entities': {
            'MEDICO': [('PK id_medico', True)],
            'PRESCRIZIONE': [('PK id_prescrizione', True)],
            'FARMACO': [('PK id_farmaco', True)],
            'LOTTO': [('PK id_lotto', True)],
            'REPARTO': [('PK id_reparto', True)],
        },
        'relationships': [
            ('PRESCRIVE', 'MEDICO', '1', 'N', 'PRESCRIZIONE'),
            ('INCLUDE', 'PRESCRIZIONE', 'N', 'M', 'FARMACO'),
            ('CONTENUTO_IN', 'FARMACO', '1', 'N', 'LOTTO'),
            ('STOCCATO_IN', 'LOTTO', 'N', 'M', 'REPARTO'),
        ],
    },
    '04-d2-concettuale': {
        'entities': {
            'MEDICO': [('PK id_medico', True)],
            'PRESCRIZIONE': [('PK id_prescrizione', True)],
            'PAZIENTE': [('PK id_paziente', True)],
            'DISPENSAZIONE': [('PK id_disp', True), ('qta', False)],
            'LOTTO': [('PK id_lotto', True)],
            'FARMACO': [('PK id_farmaco', True)],
            'MOVIMENTO': [('PK id_mov', True), ('tipo_mov', False)],
            'REPARTO': [('PK id_reparto', True)],
        },
        'relationships': [
            ('PRESCRIVE', 'MEDICO', '1', 'N', 'PRESCRIZIONE'),
            ('RIGUARDA', 'PRESCRIZIONE', 'N', '1', 'PAZIENTE'),
            ('EVASA_DA', 'PRESCRIZIONE', '1', 'N', 'DISPENSAZIONE'),
            ('USA_LOTTO', 'DISPENSAZIONE', 'N', '1', 'LOTTO'),
            ('DI', 'LOTTO', 'N', '1', 'FARMACO'),
            ('GENERA', 'DISPENSAZIONE', '1', 'N', 'MOVIMENTO'),
            ('VERSO_DA', 'MOVIMENTO', 'N', '1', 'REPARTO'),
        ],
    },
    '04-er-finale': {
        'entities': {
            'FARMACO': [('PK id_farmaco', True), ('AK codice_aic', False)],
            'LOTTO': [('PK id_lotto', True), ('AK codice_lotto', False)],
            'REPARTO': [('PK id_reparto', True), ('AK codice_reparto', False)],
            'GIACENZA_REPARTO': [('PK id_giacenza', True)],
            'MEDICO': [('PK id_medico', True), ('AK cod_albo', False)],
            'PRESCRIZIONE': [('PK id_prescrizione', True)],
            'PAZIENTE': [('PK id_paziente', True), ('AK codice_fiscale', False)],
            'RIGA_PRESCRIZIONE': [('PK id_riga', True)],
            'DISPENSAZIONE': [('PK id_disp', True)],
            'MOVIMENTO': [('PK id_mov', True)],
        },
        'relationships': [
            ('POSSIEDE', 'FARMACO', '1', 'N', 'LOTTO'),
            ('MANTIENE', 'REPARTO', '1', 'N', 'GIACENZA_REPARTO'),
            ('PRESENTE', 'LOTTO', '1', 'N', 'GIACENZA_REPARTO'),
            ('EMETTE', 'MEDICO', '1', 'N', 'PRESCRIZIONE'),
            ('RICEVE', 'PAZIENTE', '1', 'N', 'PRESCRIZIONE'),
            ('CONTIENE', 'PRESCRIZIONE', '1', 'N', 'RIGA_PRESCRIZIONE'),
            ('RICHIESTO', 'FARMACO', '1', 'N', 'RIGA_PRESCRIZIONE'),
            ('GENERA', 'PRESCRIZIONE', '1', 'N', 'DISPENSAZIONE'),
            ('UTILIZZATO', 'LOTTO', '1', 'N', 'DISPENSAZIONE'),
            ('PRODUCE', 'DISPENSAZIONE', '1', 'N', 'MOVIMENTO'),
        ],
    },

    '05-d0-concettuale': {
        'entities': {
            'PAZIENTE': [('PK id_paziente', True), ('AK codice_fiscale', False)],
            'ACCESSO': [('PK id_accesso', True), ('data_ora_arrivo', False)],
            'MEDICO': [('PK id_medico', True), ('AK cod_albo', False)],
        },
        'relationships': [
            ('ACCEDE', 'PAZIENTE', '1', 'N', 'ACCESSO'),
            ('PRESO_IN_CARICO_DA', 'ACCESSO', 'N', '1', 'MEDICO'),
        ],
    },
    '05-d1-concettuale': {
        'entities': {
            'PAZIENTE': [('PK id_paziente', True)],
            'ACCESSO': [('PK id_accesso', True)],
            'AREA': [('PK id_area', True), ('AK codice_area', False)],
            'TRIAGE': [('PK id_triage', True), ('codice_priorita', False)],
            'MEDICO': [('PK id_medico', True)],
        },
        'relationships': [
            ('ACCEDE', 'PAZIENTE', '1', 'N', 'ACCESSO'),
            ('ASSEGNATO_A', 'ACCESSO', 'N', '1', 'AREA'),
            ('SOTTOPOSTO_A', 'ACCESSO', '1', 'N', 'TRIAGE'),
            ('ESEGUITO_DA', 'TRIAGE', 'N', '1', 'MEDICO'),
        ],
    },
    '05-d2-concettuale': {
        'entities': {
            'PAZIENTE': [('PK id_paziente', True)],
            'ACCESSO': [('PK id_accesso', True)],
            'AREA': [('PK id_area', True)],
            'TRIAGE': [('PK id_triage', True)],
            'MEDICO': [('PK id_medico', True)],
            'VISITA': [('PK id_visita', True)],
            'ESAME': [('PK id_esame', True), ('AK codice_esame', False)],
            'ESITO': [('PK id_esito', True), ('tipo_esito', False)],
        },
        'relationships': [
            ('ACCEDE', 'PAZIENTE', '1', 'N', 'ACCESSO'),
            ('ASSEGNATO_A', 'ACCESSO', 'N', '1', 'AREA'),
            ('SOTTOPOSTO_A', 'ACCESSO', '1', 'N', 'TRIAGE'),
            ('ESEGUITO_DA', 'TRIAGE', 'N', '1', 'MEDICO'),
            ('SEGUITO_DA', 'ACCESSO', '1', 'N', 'VISITA'),
            ('RICHIEDE', 'VISITA', 'N', 'M', 'ESAME'),
            ('SI_CHIUDE_CON', 'ACCESSO', '1', '1', 'ESITO'),
        ],
    },
    '05-er-finale': {
        'entities': {
            'PAZIENTE': [('PK id_paziente', True), ('AK codice_fiscale', False)],
            'ACCESSO': [('PK id_accesso', True)],
            'AREA': [('PK id_area', True), ('AK codice_area', False)],
            'TRIAGE': [('PK id_triage', True)],
            'MEDICO': [('PK id_medico', True), ('AK cod_albo', False)],
            'VISITA': [('PK id_visita', True)],
            'RICHIESTA_ESAME': [('PK id_rich_esame', True)],
            'ESAME': [('PK id_esame', True), ('AK codice_esame', False)],
            'ESITO': [('PK id_esito', True)],
        },
        'relationships': [
            ('EFFETTUA', 'PAZIENTE', '1', 'N', 'ACCESSO'),
            ('ACCOGLIE', 'AREA', '1', 'N', 'ACCESSO'),
            ('RICEVE', 'ACCESSO', '1', 'N', 'TRIAGE'),
            ('ESEGUE', 'MEDICO', '1', 'N', 'TRIAGE'),
            ('GENERA', 'ACCESSO', '1', 'N', 'VISITA'),
            ('SVOLGE', 'MEDICO', '1', 'N', 'VISITA'),
            ('PRODUCE', 'VISITA', '1', 'N', 'RICHIESTA_ESAME'),
            ('CLASSIFICA', 'ESAME', '1', 'N', 'RICHIESTA_ESAME'),
            ('TERMINA_CON', 'ACCESSO', '1', '1', 'ESITO'),
        ],
    },

    '06-d0-concettuale': {
        'entities': {
            'MAGAZZINO': [('PK cod_magazzino', True), ('citta', False)],
            'DIPARTIMENTO': [('AK nome_dipartimento', False)],
            'IMPIEGATO': [('PK codice_fiscale', True), ('cognome', False)],
            'PRODOTTO': [('PK cod_prodotto', True), ('nome', False)],
            'FORNITORE': [('PK piva', True), ('nome_fornitore', False)],
        },
        'relationships': [],
    },
    '06-d1-concettuale': {
        'entities': {
            'MAGAZZINO': [('PK cod_magazzino', True)],
            'DIPARTIMENTO': [('SK nome_dipartimento', False)],
            'IMPIEGATO': [('PK codice_fiscale', True)],
        },
        'relationships': [
            ('CONTIENE', 'MAGAZZINO', '1', 'N', 'DIPARTIMENTO'),
            ('AFFERISCE_A', 'IMPIEGATO', 'N', '1', 'DIPARTIMENTO'),
        ],
    },
    '06-d2-concettuale': {
        'entities': {
            'PRODOTTO_A': [('PK cod_prodotto', True)],
            'PRODOTTO_B': [('PK cod_prodotto', True)],
        },
        'relationships': [
            ('COMPOSIZIONE', 'PRODOTTO_A', 'N', 'M', 'PRODOTTO_B'),
        ],
    },
    '06-d3-concettuale': {
        'entities': {
            'FORNITORE': [('PK piva', True)],
            'PRODOTTO': [('PK cod_prodotto', True)],
            'DIPARTIMENTO': [('SK nome_dipartimento', False)],
        },
        'relationships': [
            ('FORNITURA (quantita)', 'FORNITORE', '1', 'N', 'PRODOTTO'),
            ('FORNITURA (quantita)', 'DIPARTIMENTO', '1', 'N', 'PRODOTTO'),
        ],
    },
    '06-er-finale': {
        'entities': {
            'MAGAZZINO': [('PK cod_magazzino', True)],
            'DIPARTIMENTO': [('PK cod_magazzino+nome_dip', True), ('SK nome_dip', False)],
            'IMPIEGATO': [('PK codice_fiscale', True)],
            'PRODOTTO': [('PK cod_prodotto', True), ('AK nome_prodotto', False)],
            'COMPOSIZIONE': [('PK id_composizione', True)],
            'FORNITORE': [('PK piva', True), ('AK nome_fornitore', False)],
            'FORNITURA': [('PK id_fornitura', True), ('quantita', False)],
        },
        'relationships': [
            ('CONTIENE', 'MAGAZZINO', '1', 'N', 'DIPARTIMENTO'),
            ('INCLUDE', 'DIPARTIMENTO', '1', 'N', 'IMPIEGATO'),
            ('COMPOSTO', 'PRODOTTO', '1', 'N', 'COMPOSIZIONE'),
            ('COMPONENTE', 'PRODOTTO', '1', 'N', 'COMPOSIZIONE'),
            ('EFFETTUA', 'FORNITORE', '1', 'N', 'FORNITURA'),
            ('RIGUARDA', 'PRODOTTO', '1', 'N', 'FORNITURA'),
            ('RICEVE', 'DIPARTIMENTO', '1', 'N', 'FORNITURA'),
        ],
    },
}


def pretty_xml(el):
    return minidom.parseString(tostring(el, encoding='utf-8')).toprettyxml(indent='  ', encoding='UTF-8')


def mklabel(text, underline=False):
    t = text.replace('&', '&amp;').replace('<', '&lt;').replace('>', '&gt;')
    return f'<u>{t}</u>' if underline else t


def generate(name, spec):
    entities = spec['entities']
    relationships = spec['relationships']

    mxfile = Element('mxfile', host='app.diagrams.net', modified='2026-05-13T11:00:00.000Z', agent='Codex', version='30.0.1')
    diagram = SubElement(mxfile, 'diagram', name='Page-1', id=name)

    entity_count = len(entities)
    cols = 1
    rows = entity_count
    page_w = 3200
    page_h = max(3200, 500 + rows * 620)

    model = SubElement(diagram, 'mxGraphModel', dx='1600', dy='1000', grid='1', gridSize='10', guides='1', tooltips='1', connect='1', arrows='1', fold='1', page='1', pageScale='1', pageWidth=str(page_w), pageHeight=str(page_h), math='0', shadow='0')
    root = SubElement(model, 'root')
    SubElement(root, 'mxCell', id='0')
    SubElement(root, 'mxCell', id='1', parent='0')

    entity_pos = {}
    w, h = 280, 120
    sx, sy, dx, dy = 520, 260, 0, 520

    eid = 2
    for i, (ename, attrs) in enumerate(entities.items()):
        x = sx + (i % cols) * dx
        y = sy + (i // cols) * dy
        entity_pos[ename] = (x, y)
        cid = f'e{eid}'; eid += 1
        cell = SubElement(root, 'mxCell', id=cid, value=ename, style='rounded=0;whiteSpace=wrap;html=1;fontStyle=1;strokeWidth=2;', vertex='1', parent='1')
        SubElement(cell, 'mxGeometry', x=str(x), y=str(y), width=str(w), height=str(h), attrib={'as': 'geometry'})

        # Keep attributes around each entity with fixed slots to avoid overlaps.
        slots = [(-380, -160), (430, -160), (-380, 140), (430, 140), (0, -250), (0, 240)]
        for k, (aname, is_pk) in enumerate(attrs[:4]):
            aid = f'e{eid}'; eid += 1
            ox, oy = slots[k % len(slots)]
            ax = x + ox
            ay = y + oy
            aval = mklabel(aname, underline=is_pk)
            attr = SubElement(root, 'mxCell', id=aid, value=aval, style='ellipse;whiteSpace=wrap;html=1;strokeWidth=1.5;', vertex='1', parent='1')
            SubElement(attr, 'mxGeometry', x=str(ax), y=str(ay), width='250', height='60', attrib={'as': 'geometry'})
            cid2 = f'e{eid}'; eid += 1
            edge = SubElement(root, 'mxCell', id=cid2, value='', style='endArrow=none;html=1;strokeWidth=1.2;', edge='1', parent='1', source=cid, target=aid)
            SubElement(edge, 'mxGeometry', relative='1', attrib={'as': 'geometry'})

    # map entity name to rectangle id by scanning created cells
    rect_ids = {}
    for c in root.findall('mxCell'):
        if c.attrib.get('vertex') == '1' and c.attrib.get('style', '').startswith('rounded=0'):
            rect_ids[c.attrib['value']] = c.attrib['id']

    rel_pair_offsets = {}
    for rel_idx, (rname, e1, c1, c2, e2) in enumerate(relationships):
        x1, y1 = entity_pos[e1]
        x2, y2 = entity_pos[e2]
        c1x, c1y = x1 + (w / 2), y1 + (h / 2)
        c2x, c2y = x2 + (w / 2), y2 + (h / 2)

        pair_key = tuple(sorted((e1, e2)))
        pair_index = rel_pair_offsets.get(pair_key, 0)
        rel_pair_offsets[pair_key] = pair_index + 1

        rw, rh = 230, 120
        rel_col = rel_idx % 2
        base_x = 1260 + rel_col * 320
        rx = base_x + (pair_index * 40)
        ry = 180 + rel_idx * 220

        rid = f'e{eid}'; eid += 1
        rel = SubElement(root, 'mxCell', id=rid, value=rname, style='rhombus;whiteSpace=wrap;html=1;strokeWidth=2;', vertex='1', parent='1')
        SubElement(rel, 'mxGeometry', x=str(rx), y=str(ry), width=str(rw), height=str(rh), attrib={'as': 'geometry'})

        eleft = f'e{eid}'; eid += 1
        edge1 = SubElement(root, 'mxCell', id=eleft, value=c1, style='endArrow=none;html=1;strokeWidth=1.5;', edge='1', parent='1', source=rect_ids[e1], target=rid)
        SubElement(edge1, 'mxGeometry', relative='1', attrib={'as': 'geometry'})

        eright = f'e{eid}'; eid += 1
        edge2 = SubElement(root, 'mxCell', id=eright, value=c2, style='endArrow=none;html=1;strokeWidth=1.5;', edge='1', parent='1', source=rid, target=rect_ids[e2])
        SubElement(edge2, 'mxGeometry', relative='1', attrib={'as': 'geometry'})

    out = OUT / f'{name}.drawio'
    out.write_bytes(pretty_xml(mxfile))


for n, s in SPECS.items():
    generate(n, s)
print(f'Generated {len(SPECS)} drawio files')
