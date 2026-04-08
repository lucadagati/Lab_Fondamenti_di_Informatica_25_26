from pathlib import Path
import csv


def main() -> None:
    csv_path = Path(__file__).parent.parent / "data" / "vitali_pazienti.csv"

    with csv_path.open(newline="", encoding="utf-8") as f:
        rows = list(csv.DictReader(f))

    print("Pazienti con febbre e ipossia:")
    for r in rows:
        febbre = float(r["temperatura"]) >= 37.5
        ipossia = int(r["spo2"]) < 95

        if febbre and ipossia:
            print("-", r["id"])


if __name__ == "__main__":
    main()
