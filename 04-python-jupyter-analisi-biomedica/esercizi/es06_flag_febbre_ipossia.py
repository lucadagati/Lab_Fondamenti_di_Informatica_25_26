from pathlib import Path
import csv


def main() -> None:
    csv_path = Path(__file__).parent.parent / "data" / "vitali_pazienti.csv"
    # TODO: stampare ID pazienti con temperatura >= 37.5 e spo2 < 95
    raise NotImplementedError


if __name__ == "__main__":
    main()
