"""
Report finale: mini-triage da dati pazienti.
"""

from __future__ import annotations

from pathlib import Path

from src.io_pazienti import carica_pazienti
from src.metriche import (
    calcola_bmi,
    categoria_bmi,
    punteggio_rischio,
    priorita,
)


def main() -> None:
    # Percorso CSV relativo a questo file
    percorso_csv = Path(__file__).parent / "dati" / "pazienti_esempio.csv"
    pazienti = carica_pazienti(percorso_csv)

    # TODO: calcolare BMI, categoria BMI, punteggio rischio e priorità
    #       poi stampare un report leggibile.
    raise NotImplementedError


if __name__ == "__main__":
    main()

