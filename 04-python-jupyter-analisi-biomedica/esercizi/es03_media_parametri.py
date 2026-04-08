from pathlib import Path
import csv


def main() -> None:
    csv_path = Path(__file__).parent.parent / "data" / "vitali_pazienti.csv"
    # TODO: calcolare media di bpm, spo2 e sistolica
    raise NotImplementedError


if __name__ == "__main__":
    main()
