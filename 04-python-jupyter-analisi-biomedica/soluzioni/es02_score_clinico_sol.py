from pathlib import Path
import csv


def score_clinico(p: dict) -> int:
    score = 0
    if p['eta'] >= 70:
        score += 2
    if p['bpm'] >= 100:
        score += 1
    if p['spo2'] < 95:
        score += 2
    if p['sistolica'] >= 140:
        score += 2
    if p['temperatura'] >= 37.5:
        score += 1
    return score


def classe_rischio(score: int) -> str:
    if score <= 2:
        return 'Basso'
    if score <= 5:
        return 'Medio'
    return 'Alto'


def main() -> None:
    csv_path = Path(__file__).parent.parent / 'data' / 'vitali_pazienti.csv'
    pazienti = []
    with csv_path.open(newline='', encoding='utf-8') as f:
        for r in csv.DictReader(f):
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

    print('Report rischio clinico')
    print('=====================')
    for p in pazienti:
        s = score_clinico(p)
        c = classe_rischio(s)
        print(f"{p['id']}: score={s}, classe={c}")


if __name__ == '__main__':
    main()
