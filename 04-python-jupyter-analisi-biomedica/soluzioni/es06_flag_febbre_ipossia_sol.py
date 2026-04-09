"""Soluzione esercizio 6 con commenti didattici estesi."""

# Importiamo Path per percorsi robusti.
from pathlib import Path
# Importiamo csv per lettura file.
import csv


def main() -> None:
    # Definiamo percorso CSV.
    csv_path = Path(__file__).parent.parent / "data" / "vitali_pazienti.csv"

    # Apriamo file CSV.
    with csv_path.open(newline="", encoding="utf-8") as f:
        # Leggiamo tutte le righe in lista.
        rows = list(csv.DictReader(f))

    # Intestazione output.
    print("Pazienti con febbre e ipossia:")

    # Cicliamo sulle righe.
    for r in rows:
        # Condizione febbre.
        febbre = float(r["temperatura"]) >= 37.5
        # Condizione ipossia.
        ipossia = int(r["spo2"]) < 95

        # Se entrambe le condizioni sono vere stampiamo ID.
        if febbre and ipossia:
            # Stampa paziente idoneo.
            print("-", r["id"])


# Blocco di avvio.
if __name__ == "__main__":
    # Esecuzione main.
    main()
