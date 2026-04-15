"""Soluzione esercizio 6 con commenti didattici estesi."""


def frequenze_caratteri(testo: str) -> dict[str, int]:
    # Creiamo un dizionario vuoto per le frequenze.
    freq: dict[str, int] = {}

    # Scorriamo ogni carattere del testo in minuscolo.
    for ch in testo.lower():
        # Se il carattere e uno spazio, lo ignoriamo.
        if ch == " ":
            # Passiamo direttamente al carattere successivo.
            continue
        # Se il carattere non e ancora nel dizionario, lo inizializziamo a 0.
        if ch not in freq:
            # Inizializzazione frequenza.
            freq[ch] = 0
        # Incrementiamo la frequenza del carattere corrente.
        freq[ch] += 1

    # Restituiamo il dizionario completo delle frequenze.
    return freq


def main() -> None:
    # Leggiamo il testo dall'utente.
    s = input("Inserisci testo: ")
    # Calcoliamo le frequenze dei caratteri.
    risultato = frequenze_caratteri(s)
    # Stampiamo il dizionario risultante.
    print(risultato)


if __name__ == "__main__":
    # Avviamo la funzione principale.
    main()
