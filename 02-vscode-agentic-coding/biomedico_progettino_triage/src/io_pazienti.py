"""
Lettura CSV dei pazienti (dataset fittizio per il laboratorio).
"""

from __future__ import annotations

import csv
import sys
from pathlib import Path


def carica_pazienti(percorso_csv: str | Path) -> list[dict]:
    """
    Carica un CSV con intestazioni:
    id,sesso,eta,peso_kg,altezza_m,bpm,sistolica

    - per righe invalide: stampa un messaggio su stderr e salta la riga
    - per righe valide: converte i tipi (int/float) e restituisce dict
    """
    raise NotImplementedError

