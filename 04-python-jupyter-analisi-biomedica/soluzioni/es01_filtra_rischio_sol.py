"""Soluzione esercizio 1 con commenti didattici estesi."""

# Importiamo Path per costruire percorsi file in modo robusto.
from pathlib import Path
# Importiamo csv per leggere il file CSV riga per riga.
import csv


def main() -> None:
    # Costruiamo il percorso assoluto al CSV di input.
    csv_path = Path(__file__).parent.parent / "data" / "vitali_pazienti.csv"

    # Apriamo il file CSV in lettura con encoding UTF-8.
    with csv_path.open(newline="", encoding="utf-8") as f:
        # Convertiamo il CSV in una lista di dizionari (una riga = un dict).
        rows = list(csv.DictReader(f))

    # Stampiamo l'intestazione del report.
    print("Pazienti a rischio:")

    # Iteriamo su ogni riga (paziente).
    for r in rows:
        # Verifichiamo se il BPM e alto.
        bpm_alto = int(r["bpm"]) >= 100
        # Verifichiamo se la saturazione e bassa.
        spo2_bassa = int(r["spo2"]) < 95
        # Verifichiamo se la pressione sistolica e alta.
        sistolica_alta = int(r["sistolica"]) >= 140

        # Se almeno una condizione e vera, il paziente e a rischio.
        if bpm_alto or spo2_bassa or sistolica_alta:
            # Stampiamo l'ID del paziente a rischio.
            print("-", r["id"])


# Eseguiamo main solo se il file viene lanciato direttamente.
if __name__ == "__main__":
    # Avviamo il programma.
    main()
