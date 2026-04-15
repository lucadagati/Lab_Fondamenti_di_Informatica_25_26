"""Soluzione esercizio 10: analisi parole con dizionario e passi espliciti."""


# Definiamo una funzione che conta le frequenze delle parole.
def analizza_parole(frase: str) -> dict[str, int]:
    # Inizializziamo il dizionario delle frequenze.
    frequenze: dict[str, int] = {}
    # Convertiamo la frase in minuscolo.
    frase_minuscola = frase.lower()
    # Dividiamo la frase in una lista di parole.
    parole = frase_minuscola.split()
    # Inizializziamo l'indice per scorrere la lista delle parole.
    indice = 0

    # Cicliamo su tutte le parole presenti nella lista.
    while indice < len(parole):
        # Leggiamo la parola corrente.
        parola = parole[indice]
        # Verifichiamo se la parola non e ancora nel dizionario.
        if parola not in frequenze:
            # Inizializziamo la frequenza della parola a zero.
            frequenze[parola] = 0
        # Incrementiamo la frequenza della parola corrente.
        frequenze[parola] = frequenze[parola] + 1
        # Incrementiamo l'indice per passare alla prossima parola.
        indice = indice + 1

    # Restituiamo il dizionario delle frequenze.
    return frequenze


# Definiamo la funzione principale.
def main() -> None:
    # Chiediamo all'utente una frase da analizzare.
    frase = input("Inserisci frase: ")
    # Calcoliamo le frequenze delle parole della frase.
    frequenze = analizza_parole(frase)
    # Inizializziamo il totale delle parole contate.
    totale_parole = 0

    # Scorriamo tutte le chiavi del dizionario frequenze.
    for parola in frequenze:
        # Aggiungiamo la frequenza corrente al totale complessivo.
        totale_parole = totale_parole + frequenze[parola]

    # Inizializziamo la variabile della parola piu frequente.
    parola_top = ""
    # Inizializziamo la frequenza massima con un valore minimo.
    frequenza_top = -1

    # Scorriamo tutte le chiavi per trovare la frequenza massima.
    for parola in frequenze:
        # Leggiamo la frequenza associata alla parola corrente.
        frequenza_corrente = frequenze[parola]
        # Verifichiamo se la frequenza corrente e la piu alta trovata finora.
        if frequenza_corrente > frequenza_top:
            # Aggiorniamo la frequenza massima.
            frequenza_top = frequenza_corrente
            # Aggiorniamo la parola piu frequente.
            parola_top = parola

    # Stampiamo il totale delle parole.
    print("Totale parole:", totale_parole)
    # Controlliamo se e stata trovata almeno una parola.
    if parola_top != "":
        # Stampiamo la parola piu frequente e la sua frequenza.
        print("Parola piu frequente:", parola_top, "->", frequenza_top)


# Verifichiamo l'esecuzione diretta del file.
if __name__ == "__main__":
    # Avviamo il programma principale.
    main()
