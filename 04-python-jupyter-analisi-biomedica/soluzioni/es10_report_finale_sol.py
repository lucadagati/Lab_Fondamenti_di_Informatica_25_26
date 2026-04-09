"""Soluzione esercizio 10 con commenti didattici estesi."""


def analizza_parole(frase: str) -> dict[str, int]:
    # Inizializziamo dizionario frequenze vuoto.
    freq: dict[str, int] = {}

    # Convertiamo in minuscolo e separiamo in parole.
    for parola in frase.lower().split():
        # Se parola non presente, inizializziamo contatore.
        if parola not in freq:
            # Inizializzazione a zero.
            freq[parola] = 0
        # Incrementiamo frequenza della parola corrente.
        freq[parola] += 1

    # Restituiamo dizionario frequenze.
    return freq


def main() -> None:
    # Leggiamo frase dall'utente.
    frase = input("Inserisci frase: ")
    # Calcoliamo frequenze parole.
    freq = analizza_parole(frase)

    # Calcoliamo numero totale parole come somma frequenze.
    totale_parole = sum(freq.values())
    # Se il dizionario non e vuoto, troviamo parola piu frequente.
    parola_top = max(freq, key=freq.get) if freq else ""

    # Stampiamo totale parole.
    print("Totale parole:", totale_parole)
    # Se esiste parola top, stampiamo dettaglio.
    if parola_top:
        # Stampa parola con frequenza massima.
        print("Parola piu frequente:", parola_top, "->", freq[parola_top])


# Avvio condizionale.
if __name__ == "__main__":
    # Eseguiamo il programma.
    main()
