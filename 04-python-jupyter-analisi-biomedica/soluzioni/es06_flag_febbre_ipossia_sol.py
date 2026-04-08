from pathlib import Path
import csv


def main() -> None:
    csv_path = Path(__file__).parent.parent / "data" / "vitali_pazienti.csv"
    with csv_path.open(newline="", encoding="utf-8") as f:
        rows=list(csv.DictReader(f))
    for r in rows:
        if float(r["temperatura"]) >= 37.5 and int(r["spo2"]) < 95:
            print(r["id"])


if __name__ == "__main__":
    main()
