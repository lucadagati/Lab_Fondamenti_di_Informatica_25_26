"""Soluzione esercizio 4: conteggio vocali con commenti riga per riga."""


# Definiamo una funzione che conta le vocali in un testo.
def conta_vocali(testo: str) -> int:
    # Inizializziamo il contatore delle vocali trovate.
    conteggio = 0
    # Convertiamo il testo in minuscolo per semplificare i controlli.
    testo_minuscolo = testo.lower()
    # Inizializziamo l'indice di scorrimento dei caratteri.
    indice = 0

    # Scorriamo il testo carattere per carattere.
    while indice < len(testo_minuscolo):
        # Leggiamo il carattere corrente.
        carattere = testo_minuscolo[indice]
        # Controlliamo se il carattere corrente e una vocale.
        if carattere in "aeiou":
            # Incrementiamo il contatore delle vocali.
            conteggio = conteggio + 1
        # Avanziamo al carattere successivo.
        indice = indice + 1

    # Restituiamo il numero totale di vocali.
    return conteggio


# Definiamo la funzione principale del programma.
def main() -> None:
    # Chiediamo una frase all'utente.
    frase = input("Inserisci una frase: ")
    # Calcoliamo il numero di vocali della frase.
    totale_vocali = conta_vocali(frase)
    # Stampiamo il risultato finale.
    print("Vocali:", totale_vocali)


# Verifichiamo che il file sia eseguito direttamente.
if __name__ == "__main__":
    # Eseguiamo la funzione principale.
    main()
