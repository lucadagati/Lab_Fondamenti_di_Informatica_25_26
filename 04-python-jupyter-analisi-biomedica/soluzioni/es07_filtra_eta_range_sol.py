from pathlib import Path
import csv


def main() -> None:
    csv_path = Path(__file__).parent.parent / "data" / "vitali_pazienti.csv"

    with csv_path.open(newline="", encoding="utf-8") as f:
        rows = list(csv.DictReader(f))

    print("Pazienti con eta tra 50 e 75:")
    for r in rows:
        eta = int(r["eta"])
        if 50 <= eta <= 75:
            print("-", r["id"], f"(eta={eta})")


if __name__ == "__main__":
    main()
