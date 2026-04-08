from pathlib import Path
import csv


def classe_pressione(sistolica: int) -> str:
    if sistolica < 130:
        return "Normale"
    if sistolica < 140:
        return "Pre-ipertensione"
    return "Ipertensione"


def main() -> None:
    csv_path = Path(__file__).parent.parent / "data" / "vitali_pazienti.csv"
    with csv_path.open(newline="", encoding="utf-8") as f:
        rows=list(csv.DictReader(f))
    for r in rows:
        s=int(r["sistolica"])
        print(r["id"], classe_pressione(s))


if __name__ == "__main__":
    main()
