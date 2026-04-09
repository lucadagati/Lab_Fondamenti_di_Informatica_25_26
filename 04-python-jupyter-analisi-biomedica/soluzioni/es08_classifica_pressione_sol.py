"""Soluzione esercizio 8 con commenti didattici estesi."""

# Importiamo Path per percorsi file.
from pathlib import Path
# Importiamo csv per lettura del dataset.
import csv


def classe_pressione(sistolica: int) -> str:
    # Se sistolica e sotto 130 la classe e Normale.
    if sistolica < 130:
        # Restituiamo classe Normale.
        return "Normale"
    # Se sistolica e sotto 140 la classe e Pre-ipertensione.
    if sistolica < 140:
        # Restituiamo classe Pre-ipertensione.
        return "Pre-ipertensione"
    # Negli altri casi la classe e Ipertensione.
    return "Ipertensione"


def main() -> None:
    # Percorso file CSV.
    csv_path = Path(__file__).parent.parent / "data" / "vitali_pazienti.csv"

    # Apertura CSV.
    with csv_path.open(newline="", encoding="utf-8") as f:
        # Lettura righe.
        rows = list(csv.DictReader(f))

    # Ciclo su tutte le righe per classificare ogni paziente.
    for r in rows:
        # Conversione sistolica in intero.
        sistolica = int(r["sistolica"])
        # Calcolo classe pressione.
        classe = classe_pressione(sistolica)
        # Stampa risultato paziente.
        print(r["id"], classe)


# Blocco main.
if __name__ == "__main__":
    # Avviamo l'esecuzione.
    main()
