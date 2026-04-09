"""Soluzione esercizio 3 con commenti didattici estesi."""

# Importiamo Path per percorso file.
from pathlib import Path
# Importiamo csv per leggere il dataset.
import csv


def main() -> None:
    # Costruiamo il percorso del file CSV.
    csv_path = Path(__file__).parent.parent / "data" / "vitali_pazienti.csv"

    # Apriamo il file CSV.
    with csv_path.open(newline="", encoding="utf-8") as f:
        # Convertiamo tutte le righe in lista di dizionari.
        rows = list(csv.DictReader(f))

    # Inizializziamo accumulatore per bpm.
    somma_bpm = 0
    # Inizializziamo accumulatore per spo2.
    somma_spo2 = 0
    # Inizializziamo accumulatore per sistolica.
    somma_sistolica = 0

    # Cicliamo su ogni riga del dataset.
    for r in rows:
        # Sommiamo il valore bpm corrente.
        somma_bpm += int(r["bpm"])
        # Sommiamo il valore spo2 corrente.
        somma_spo2 += int(r["spo2"])
        # Sommiamo il valore sistolica corrente.
        somma_sistolica += int(r["sistolica"])

    # Calcoliamo il numero totale di righe.
    n = len(rows)

    # Calcoliamo media bpm.
    media_bpm = somma_bpm / n
    # Calcoliamo media spo2.
    media_spo2 = somma_spo2 / n
    # Calcoliamo media sistolica.
    media_sistolica = somma_sistolica / n

    # Stampiamo media bpm formattata.
    print(f"Media bpm: {media_bpm:.2f}")
    # Stampiamo media spo2 formattata.
    print(f"Media spo2: {media_spo2:.2f}")
    # Stampiamo media sistolica formattata.
    print(f"Media sistolica: {media_sistolica:.2f}")


# Avvio condizionato.
if __name__ == "__main__":
    # Eseguiamo il main.
    main()
