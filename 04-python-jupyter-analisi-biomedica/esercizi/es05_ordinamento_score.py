from pathlib import Path
import csv


def score(p: dict) -> int:
    # TODO: stessa logica score esercizio 2
    raise NotImplementedError


def main() -> None:
    csv_path = Path(__file__).parent.parent / "data" / "vitali_pazienti.csv"
    # TODO: ordinare pazienti per score decrescente e stampare top 3
    raise NotImplementedError


if __name__ == "__main__":
    main()
