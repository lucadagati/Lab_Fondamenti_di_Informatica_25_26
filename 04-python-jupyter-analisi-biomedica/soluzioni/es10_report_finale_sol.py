"""Soluzione esercizio 10 con commenti didattici estesi."""


def analizza_parole(frase: str) -> dict[str, int]:
    # Inizializziamo dizionario frequenze vuoto.
    freq: dict[str, int] = {}

    # Convertiamo in minuscolo e dividiamo la frase in parole.
    for parola in frase.lower().split():
        # Se la parola non esiste nel dizionario, la inizializziamo.
        if parola not in freq:
            # Inseriamo chiave con valore iniziale 0.
            freq[parola] = 0
        # Incrementiamo frequenza della parola corrente.
        freq[parola] += 1

    # Restituiamo il dizionario frequenze.
    return freq


def main() -> None:
    # Leggiamo la frase dall'utente.
    frase = input("Inserisci frase: ")
    # Analizziamo la frase per ottenere frequenze parole.
    freq = analizza_parole(frase)

    # Calcoliamo il totale parole come somma delle frequenze.
    totale_parole = sum(freq.values())

    # Se il dizionario non e vuoto, troviamo la parola piu frequente.
    if freq:
        # Troviamo chiave con frequenza massima.
        parola_top = max(freq, key=freq.get)
    else:
        # Se non ci sono parole, usiamo stringa vuota.
        parola_top = ""

    # Stampiamo numero totale di parole.
    print("Totale parole:", totale_parole)

    # Se esiste una parola top, stampiamo il dettaglio.
    if parola_top:
        # Stampa parola e frequenza associata.
        print("Parola piu frequente:", parola_top, "->", freq[parola_top])


if __name__ == "__main__":
    # Avvio del programma.
    main()
