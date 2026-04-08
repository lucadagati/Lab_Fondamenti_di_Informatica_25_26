from pathlib import Path
import csv


def main() -> None:
    csv_path = Path(__file__).parent.parent / "data" / "vitali_pazienti.csv"
    with csv_path.open(newline="", encoding="utf-8") as f:
        rows=list(csv.DictReader(f))
    c=sum(1 for r in rows if int(r["sistolica"]) >= 140)
    print("Pazienti con sistolica >= 140:", c)


if __name__ == "__main__":
    main()
