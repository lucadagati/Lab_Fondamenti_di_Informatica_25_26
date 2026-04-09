"""Soluzione esercizio 4 con commenti didattici estesi."""

# Importiamo Path per gestire percorsi.
from pathlib import Path
# Importiamo csv per leggere dati tabellari.
import csv


def main() -> None:
    # Percorso del dataset.
    csv_path = Path(__file__).parent.parent / "data" / "vitali_pazienti.csv"

    # Apertura file CSV.
    with csv_path.open(newline="", encoding="utf-8") as f:
        # Carichiamo righe del CSV.
        rows = list(csv.DictReader(f))

    # Inizializziamo il contatore pazienti ipertesi.
    contatore = 0

    # Scorriamo tutte le righe.
    for r in rows:
        # Se la sistolica e almeno 140 incrementiamo il contatore.
        if int(r["sistolica"]) >= 140:
            # Incremento contatore.
            contatore += 1

    # Stampiamo il risultato finale.
    print("Pazienti con sistolica >= 140:", contatore)


# Blocco di avvio.
if __name__ == "__main__":
    # Avvio main.
    main()
