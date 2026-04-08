"""
Lab 4 - Esercizio 2
Calcola uno score clinico semplice e stampa un report.
"""

from pathlib import Path
import csv


def score_clinico(p: dict) -> int:
    """
    Score:
    +2 se eta >= 70
    +1 se bpm >= 100
    +2 se spo2 < 95
    +2 se sistolica >= 140
    +1 se temperatura >= 37.5
    """
    # TODO
    raise NotImplementedError


def classe_rischio(score: int) -> str:
    # TODO: 0-2 Basso, 3-5 Medio, >=6 Alto
    raise NotImplementedError


def main() -> None:
    csv_path = Path(__file__).parent.parent / 'data' / 'vitali_pazienti.csv'
    # TODO: carica dati, calcola score e classe, stampa report finale
    raise NotImplementedError


if __name__ == '__main__':
    main()
