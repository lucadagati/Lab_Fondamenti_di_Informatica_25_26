"""
Funzioni di calcolo per il mini-triage:
- BMI e categoria BMI
- punteggio rischio e priorità
"""

from __future__ import annotations


def calcola_bmi(peso_kg: float, altezza_m: float) -> float:
    """Calcola BMI = peso_kg / (altezza_m ** 2)."""
    raise NotImplementedError


def categoria_bmi(bmi: float) -> str:
    """Ritorna una categoria testuale per un dato BMI."""
    raise NotImplementedError


def punteggio_rischio(eta: int, bpm: float, sistolica: float) -> int:
    """Ritorna un punteggio di rischio intero (0..5) basato su età, bpm, sistolica."""
    raise NotImplementedError


def priorita(punteggio: int) -> str:
    """Mappa un punteggio di rischio a una priorità testuale."""
    raise NotImplementedError

