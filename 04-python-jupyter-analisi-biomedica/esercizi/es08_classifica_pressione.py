from pathlib import Path
import csv


def classe_pressione(sistolica: int) -> str:
    # TODO: Normale (<130), Pre-ipertensione (130-139), Ipertensione (>=140)
    raise NotImplementedError


def main() -> None:
    csv_path = Path(__file__).parent.parent / "data" / "vitali_pazienti.csv"
    # TODO: stampare id e classe pressione
    raise NotImplementedError


if __name__ == "__main__":
    main()
