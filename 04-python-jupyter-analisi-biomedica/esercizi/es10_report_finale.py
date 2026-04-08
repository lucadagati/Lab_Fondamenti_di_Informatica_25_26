from pathlib import Path
import csv


def main() -> None:
    csv_path = Path(__file__).parent.parent / "data" / "vitali_pazienti.csv"
    # TODO: stampare report finale con:
    # - totale pazienti
    # - numero rischio alto (score >= 6)
    # - id con score massimo
    raise NotImplementedError


if __name__ == "__main__":
    main()
