from pathlib import Path
import csv


def score(p: dict) -> int:
    s=0
    if int(p["eta"]) >= 70: s += 2
    if int(p["bpm"]) >= 100: s += 1
    if int(p["spo2"]) < 95: s += 2
    if int(p["sistolica"]) >= 140: s += 2
    if float(p["temperatura"]) >= 37.5: s += 1
    return s


def main() -> None:
    csv_path = Path(__file__).parent.parent / "data" / "vitali_pazienti.csv"
    with csv_path.open(newline="", encoding="utf-8") as f:
        rows=list(csv.DictReader(f))
    top=sorted(rows, key=score, reverse=True)[:3]
    for r in top:
        print(r["id"], score(r))


if __name__ == "__main__":
    main()
