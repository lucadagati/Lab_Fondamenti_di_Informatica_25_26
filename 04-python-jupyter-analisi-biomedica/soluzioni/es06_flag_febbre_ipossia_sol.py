"""Soluzione esercizio 6: frequenze caratteri con dizionario esplicito."""


# Definiamo una funzione che calcola frequenze dei caratteri.
def frequenze_caratteri(testo: str) -> dict[str, int]:
    # Inizializziamo un dizionario vuoto.
    frequenze: dict[str, int] = {}
    # Convertiamo il testo in minuscolo per uniformare il conteggio.
    testo_minuscolo = testo.lower()
    # Inizializziamo l'indice di scorrimento.
    indice = 0

    # Scorriamo tutti i caratteri del testo.
    while indice < len(testo_minuscolo):
        # Leggiamo il carattere corrente.
        carattere = testo_minuscolo[indice]
        # Controlliamo se il carattere e uno spazio.
        if carattere != " ":
            # Verifichiamo se il carattere non e ancora nel dizionario.
            if carattere not in frequenze:
                # Inizializziamo la frequenza del carattere a zero.
                frequenze[carattere] = 0
            # Incrementiamo la frequenza del carattere corrente.
            frequenze[carattere] = frequenze[carattere] + 1
        # Avanziamo al carattere successivo.
        indice = indice + 1

    # Restituiamo il dizionario delle frequenze.
    return frequenze


# Definiamo la funzione principale.
def main() -> None:
    # Chiediamo all'utente di inserire un testo.
    testo = input("Inserisci testo: ")
    # Calcoliamo il dizionario delle frequenze.
    risultato = frequenze_caratteri(testo)
    # Stampiamo il risultato finale.
    print(risultato)


# Verifichiamo l'esecuzione diretta del file.
if __name__ == "__main__":
    # Avviamo la funzione principale.
    main()
