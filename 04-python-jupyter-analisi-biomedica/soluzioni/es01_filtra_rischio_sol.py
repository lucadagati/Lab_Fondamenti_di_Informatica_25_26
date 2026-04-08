from pathlib import Path
import csv


def carica_pazienti(csv_path: Path) -> list[dict]:
    pazienti = []
    with csv_path.open(newline='', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        for r in reader:
            pazienti.append(
                {
                    'id': r['id'],
                    'eta': int(r['eta']),
                    'bpm': int(r['bpm']),
                    'spo2': int(r['spo2']),
                    'sistolica': int(r['sistolica']),
                    'diastolica': int(r['diastolica']),
                    'temperatura': float(r['temperatura']),
                }
            )
    return pazienti


def paziente_a_rischio(p: dict) -> bool:
    return p['bpm'] >= 100 or p['spo2'] < 95 or p['sistolica'] >= 140


def main() -> None:
    csv_path = Path(__file__).parent.parent / 'data' / 'vitali_pazienti.csv'
    pazienti = carica_pazienti(csv_path)
    print('Pazienti a rischio:')
    for p in pazienti:
        if paziente_a_rischio(p):
            print('-', p['id'])


if __name__ == '__main__':
    main()
