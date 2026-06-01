from xml.etree.ElementTree import Element, SubElement, tostring
from xml.dom import minidom
from pathlib import Path

OUT = Path('08-progettazione-er/diagrammi-drawio/esercizi')

DIAGRAMS = {
    '01-er-finale': {
        'nodes': ['PAZIENTE', 'PROGRAMMA', 'SEDUTA', 'FISIOTERAPISTA', 'VALUTAZIONE', 'MISURA_VALUTAZIONE', 'TIPO_INDICATORE'],
        'edges': [
            ('PAZIENTE', 'PROGRAMMA', '1:N segue'),
            ('FISIOTERAPISTA', 'PROGRAMMA', '1:N referente'),
            ('PROGRAMMA', 'SEDUTA', '1:N include'),
            ('FISIOTERAPISTA', 'SEDUTA', '1:N conduce'),
            ('PAZIENTE', 'VALUTAZIONE', '1:N riceve'),
            ('PROGRAMMA', 'VALUTAZIONE', '1:N prevede'),
            ('VALUTAZIONE', 'MISURA_VALUTAZIONE', '1:N contiene'),
            ('TIPO_INDICATORE', 'MISURA_VALUTAZIONE', '1:N classifica'),
        ],
    },
    '02-er-finale': {
        'nodes': ['PAZIENTE', 'RICHIESTA', 'MEDICO_PRESCRITTORE', 'CAMPIONE', 'RICHIESTA_ESAME', 'ESAME', 'RISULTATO', 'STRUMENTO', 'REFERTO'],
        'edges': [
            ('PAZIENTE', 'RICHIESTA', '1:N apre'),
            ('MEDICO_PRESCRITTORE', 'RICHIESTA', '1:N prescrive'),
            ('RICHIESTA', 'CAMPIONE', '1:N genera'),
            ('RICHIESTA', 'RICHIESTA_ESAME', '1:N contiene'),
            ('ESAME', 'RICHIESTA_ESAME', '1:N richiesto'),
            ('CAMPIONE', 'RISULTATO', '1:N produce'),
            ('ESAME', 'RISULTATO', '1:N classifica'),
            ('STRUMENTO', 'RISULTATO', '1:N esegue'),
            ('REFERTO', 'RISULTATO', '1:N include'),
        ],
    },
    '03-er-finale': {
        'nodes': ['PAZIENTE', 'VIDEO_VISITA', 'MEDICO', 'PIANO_TERAPEUTICO', 'DISPOSITIVO', 'MISURA', 'TIPO_MISURA', 'ALERT'],
        'edges': [
            ('PAZIENTE', 'VIDEO_VISITA', '1:N effettua'),
            ('MEDICO', 'VIDEO_VISITA', '1:N conduce'),
            ('PAZIENTE', 'PIANO_TERAPEUTICO', '1:N segue'),
            ('MEDICO', 'PIANO_TERAPEUTICO', '1:N definisce'),
            ('PAZIENTE', 'DISPOSITIVO', '1:N usa'),
            ('DISPOSITIVO', 'MISURA', '1:N registra'),
            ('TIPO_MISURA', 'MISURA', '1:N classifica'),
            ('MISURA', 'ALERT', '1:N genera'),
            ('PIANO_TERAPEUTICO', 'ALERT', '1:N contestualizza'),
        ],
    },
    '04-er-finale': {
        'nodes': ['FARMACO', 'LOTTO', 'REPARTO', 'GIACENZA_REPARTO', 'MEDICO', 'PRESCRIZIONE', 'PAZIENTE', 'RIGA_PRESCRIZIONE', 'DISPENSAZIONE', 'MOVIMENTO'],
        'edges': [
            ('FARMACO', 'LOTTO', '1:N possiede'),
            ('REPARTO', 'GIACENZA_REPARTO', '1:N mantiene'),
            ('LOTTO', 'GIACENZA_REPARTO', '1:N presente'),
            ('MEDICO', 'PRESCRIZIONE', '1:N emette'),
            ('PAZIENTE', 'PRESCRIZIONE', '1:N riceve'),
            ('PRESCRIZIONE', 'RIGA_PRESCRIZIONE', '1:N contiene'),
            ('FARMACO', 'RIGA_PRESCRIZIONE', '1:N richiesto'),
            ('PRESCRIZIONE', 'DISPENSAZIONE', '1:N genera'),
            ('LOTTO', 'DISPENSAZIONE', '1:N utilizzato'),
            ('DISPENSAZIONE', 'MOVIMENTO', '1:N produce'),
        ],
    },
    '05-er-finale': {
        'nodes': ['PAZIENTE', 'ACCESSO', 'AREA', 'TRIAGE', 'MEDICO', 'VISITA', 'RICHIESTA_ESAME', 'ESAME', 'ESITO'],
        'edges': [
            ('PAZIENTE', 'ACCESSO', '1:N effettua'),
            ('AREA', 'ACCESSO', '1:N accoglie'),
            ('ACCESSO', 'TRIAGE', '1:N riceve'),
            ('MEDICO', 'TRIAGE', '1:N esegue'),
            ('ACCESSO', 'VISITA', '1:N genera'),
            ('MEDICO', 'VISITA', '1:N svolge'),
            ('VISITA', 'RICHIESTA_ESAME', '1:N produce'),
            ('ESAME', 'RICHIESTA_ESAME', '1:N classifica'),
            ('ACCESSO', 'ESITO', '1:1 termina_con'),
        ],
    },
    '06-er-finale': {
        'nodes': ['MAGAZZINO', 'DIPARTIMENTO', 'IMPIEGATO', 'PRODOTTO', 'COMPOSIZIONE', 'FORNITORE', 'FORNITURA'],
        'edges': [
            ('MAGAZZINO', 'DIPARTIMENTO', '1:N contiene'),
            ('DIPARTIMENTO', 'IMPIEGATO', '1:N include'),
            ('PRODOTTO', 'COMPOSIZIONE', '1:N composto'),
            ('PRODOTTO', 'COMPOSIZIONE', '1:N componente'),
            ('FORNITORE', 'FORNITURA', '1:N effettua'),
            ('PRODOTTO', 'FORNITURA', '1:N riguarda'),
            ('DIPARTIMENTO', 'FORNITURA', '1:N riceve'),
        ],
    },
}


def pretty_xml(el):
    rough = tostring(el, encoding='utf-8')
    return minidom.parseString(rough).toprettyxml(indent='  ', encoding='UTF-8')


def make_diagram(name, nodes, edges):
    mxfile = Element('mxfile', host='app.diagrams.net', modified='2026-05-13T10:00:00.000Z', agent='Codex', version='30.0.1')
    diagram = SubElement(mxfile, 'diagram', name='Page-1', id=name)
    model = SubElement(diagram, 'mxGraphModel', dx='1214', dy='711', grid='1', gridSize='10', guides='1', tooltips='1', connect='1', arrows='1', fold='1', page='1', pageScale='1', pageWidth='1600', pageHeight='1000', math='0', shadow='0')
    root = SubElement(model, 'root')
    SubElement(root, 'mxCell', id='0')
    SubElement(root, 'mxCell', id='1', parent='0')

    cols = 4
    node_ids = {}
    for i, node in enumerate(nodes):
        x = 60 + (i % cols) * 330
        y = 70 + (i // cols) * 180
        cid = f'n{i+2}'
        node_ids[node] = cid
        cell = SubElement(root, 'mxCell', id=cid, value=node, style='rounded=0;whiteSpace=wrap;html=1;strokeWidth=2;', vertex='1', parent='1')
        SubElement(cell, 'mxGeometry', x=str(x), y=str(y), width='210', height='70', attrib={'as': 'geometry'})

    for j, (src, dst, lbl) in enumerate(edges):
        eid = f'e{j+2+len(nodes)}'
        cell = SubElement(root, 'mxCell', id=eid, value=lbl, style='endArrow=block;html=1;rounded=0;strokeWidth=1.5;', edge='1', parent='1', source=node_ids[src], target=node_ids[dst])
        SubElement(cell, 'mxGeometry', relative='1', attrib={'as': 'geometry'})

    out = OUT / f'{name}.drawio'
    out.write_bytes(pretty_xml(mxfile))


for name, spec in DIAGRAMS.items():
    make_diagram(name, spec['nodes'], spec['edges'])

print('Generated', len(DIAGRAMS), 'drawio files in', OUT)
