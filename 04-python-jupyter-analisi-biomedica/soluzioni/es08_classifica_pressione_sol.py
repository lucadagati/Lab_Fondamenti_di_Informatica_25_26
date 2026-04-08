from pathlib import Path
import csv


def classe_pressione(sistolica: int) -> str:
    # Classificazione molto semplice su 3 classi
    if sistolica < 130:
        return "Normale"
    if sistolica < 140:
        return "Pre-ipertensione"
    return "Ipertensione"


def main() -> None:
    csv_path = Path(__file__).parent.parent / "data" / "vitali_pazienti.csv"

    with csv_path.open(newline="", encoding="utf-8") as f:
        rows = list(csv.DictReader(f))

    for r in rows:
        sistolica = int(r["sistolica"])
        classe = classe_pressione(sistolica)
        print(r["id"], classe)


if __name__ == "__main__":
    main()
