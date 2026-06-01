"""
Livello 1 — Quiz da file di testo
---------------------------------
Leggi `domande_quiz.txt`, parsa le righe non-commento, chiedi all'utente
e conta le risposte corrette. Usa l'agente ma verifica il parser a mano.

Suggerimento nel prompt: gestisci input case-insensitive per A/B/C.
"""

from pathlib import Path


def carica_domande(percorso: Path) -> list[tuple[str, str, str, str, str]]:
    """Restituisce lista di (domanda, a, b, c, corretta)."""
    raise NotImplementedError


def main() -> None:
    raise NotImplementedError


if __name__ == "__main__":
    main()
