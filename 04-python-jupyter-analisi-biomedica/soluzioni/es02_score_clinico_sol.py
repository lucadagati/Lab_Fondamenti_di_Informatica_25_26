"""Soluzione esercizio 2 con commenti didattici estesi."""

# Importiamo Path per costruire il percorso del CSV.
from pathlib import Path
# Importiamo csv per la lettura tabellare semplice.
import csv


def calcola_score(r: dict) -> int:
    """Calcola lo score usando regole additive."""
    # Inizializziamo lo score a zero.
    score = 0

    # Se eta e almeno 70 aggiungiamo 2 punti.
    if int(r["eta"]) >= 70:
        # Incremento dello score.
        score += 2
    # Se bpm e almeno 100 aggiungiamo 1 punto.
    if int(r["bpm"]) >= 100:
        # Incremento dello score.
        score += 1
    # Se spo2 e sotto 95 aggiungiamo 2 punti.
    if int(r["spo2"]) < 95:
        # Incremento dello score.
        score += 2
    # Se sistolica e almeno 140 aggiungiamo 2 punti.
    if int(r["sistolica"]) >= 140:
        # Incremento dello score.
        score += 2
    # Se temperatura e almeno 37.5 aggiungiamo 1 punto.
    if float(r["temperatura"]) >= 37.5:
        # Incremento dello score.
        score += 1

    # Restituiamo il valore finale dello score.
    return score


def classe_rischio(score: int) -> str:
    """Mappa score numerico in classe testuale."""
    # Se score e tra 0 e 2, rischio basso.
    if score <= 2:
        # Restituiamo etichetta Basso.
        return "Basso"
    # Se score e tra 3 e 5, rischio medio.
    if score <= 5:
        # Restituiamo etichetta Medio.
        return "Medio"
    # Negli altri casi il rischio e alto.
    return "Alto"


def main() -> None:
    # Costruiamo percorso del file dati.
    csv_path = Path(__file__).parent.parent / "data" / "vitali_pazienti.csv"

    # Apriamo CSV in lettura.
    with csv_path.open(newline="", encoding="utf-8") as f:
        # Carichiamo tutte le righe in memoria.
        rows = list(csv.DictReader(f))

    # Stampiamo intestazione report.
    print("Report rischio clinico")
    # Stampiamo separatore visivo.
    print("=====================")

    # Iteriamo su ogni paziente.
    for r in rows:
        # Calcoliamo score del paziente.
        s = calcola_score(r)
        # Ricaviamo classe testuale dal punteggio.
        c = classe_rischio(s)
        # Stampiamo risultato finale per il paziente.
        print(f"{r['id']}: score={s}, classe={c}")


# Punto di ingresso del programma.
if __name__ == "__main__":
    # Eseguiamo main.
    main()
