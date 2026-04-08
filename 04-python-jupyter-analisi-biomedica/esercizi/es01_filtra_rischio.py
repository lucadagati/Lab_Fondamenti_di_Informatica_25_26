"""
Lab 4 - Esercizio 1
Filtra i pazienti a rischio da un CSV di parametri vitali.
"""

from pathlib import Path
import csv


def carica_pazienti(csv_path: Path) -> list[dict]:
    # TODO: carica il CSV e converti i campi numerici
    raise NotImplementedError


def paziente_a_rischio(p: dict) -> bool:
    """
    Regole rischio (almeno una vera):
    - bpm >= 100
    - spo2 < 95
    - sistolica >= 140
    """
    # TODO
    raise NotImplementedError


def main() -> None:
    csv_path = Path(__file__).parent.parent / 'data' / 'vitali_pazienti.csv'
    pazienti = carica_pazienti(csv_path)

    # TODO: stampa solo gli id dei pazienti a rischio
    raise NotImplementedError


if __name__ == '__main__':
    main()
