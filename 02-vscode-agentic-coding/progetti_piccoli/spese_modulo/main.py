"""
Livello 2 — Mini progetto multi-file
------------------------------------
Leggi `spese_esempio.txt`, usa utilita_io, stampa totale generale e totali per voce.

Invita l'agente a creare/riempire utilita_io.py e completare questo main.
"""

from pathlib import Path

from utilita_io import parse_riga_spesa, totale_per_categoria


def main() -> None:
    percorso = Path(__file__).parent / "spese_esempio.txt"
    raise NotImplementedError


if __name__ == "__main__":
    main()
