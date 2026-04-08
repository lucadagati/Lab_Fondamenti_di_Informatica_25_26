from pathlib import Path
import csv


def score(r: dict) -> int:
    s = 0
    if int(r["eta"]) >= 70:
        s += 2
    if int(r["bpm"]) >= 100:
        s += 1
    if int(r["spo2"]) < 95:
        s += 2
    if int(r["sistolica"]) >= 140:
        s += 2
    if float(r["temperatura"]) >= 37.5:
        s += 1
    return s


def main() -> None:
    csv_path = Path(__file__).parent.parent / "data" / "vitali_pazienti.csv"

    with csv_path.open(newline="", encoding="utf-8") as f:
        rows = list(csv.DictReader(f))

    # Ordina dal punteggio più alto al più basso
    ordinati = sorted(rows, key=score, reverse=True)

    # Mostra solo i primi 3
    top3 = ordinati[:3]
    print("Top 3 pazienti per score:")
    for r in top3:
        print(r["id"], score(r))


if __name__ == "__main__":
    main()
