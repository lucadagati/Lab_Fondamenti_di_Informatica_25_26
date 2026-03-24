"""
Livello 2 — Modulo riusabile (stesso package di main.py)
--------------------------------------------------------
Funzioni pure per parsing e calcolo; niente input() qui.
"""


def parse_riga_spesa(linea: str) -> tuple[str, float] | None:
    """
    Formato atteso: descrizione;importo
    Esempio: Caffè;2.50  -> ("Caffè", 2.5)
    Ritorna None se la riga è vuota o non valida.
    """
    raise NotImplementedError


def totale_per_categoria(righe: list[tuple[str, float]]) -> dict[str, float]:
    """Somma importi per descrizione (qui usiamo la descrizione come 'categoria' semplice)."""
    raise NotImplementedError
