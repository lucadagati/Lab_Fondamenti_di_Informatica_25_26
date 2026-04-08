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

    totale = len(rows)

    rischio_alto = 0
    for r in rows:
        if score(r) >= 6:
            rischio_alto += 1

    top = max(rows, key=score)

    print("Report finale")
    print("============")
    print("Totale pazienti:", totale)
    print("Rischio alto (score >= 6):", rischio_alto)
    print("ID score massimo:", top["id"], "score", score(top))


if __name__ == "__main__":
    main()
