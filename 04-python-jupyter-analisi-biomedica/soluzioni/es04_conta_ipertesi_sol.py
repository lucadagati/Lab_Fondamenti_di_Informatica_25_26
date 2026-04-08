from pathlib import Path
import csv


def main() -> None:
    csv_path = Path(__file__).parent.parent / "data" / "vitali_pazienti.csv"

    with csv_path.open(newline="", encoding="utf-8") as f:
        rows = list(csv.DictReader(f))

    contatore = 0
    for r in rows:
        if int(r["sistolica"]) >= 140:
            contatore += 1

    print("Pazienti con sistolica >= 140:", contatore)


if __name__ == "__main__":
    main()
