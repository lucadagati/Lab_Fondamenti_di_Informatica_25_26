"""Soluzione esercizio 7: filtro e quadrati con cicli espliciti."""


# Definiamo la funzione principale.
def main() -> None:
    # Creiamo la lista di partenza.
    valori = [12, 5, 18, 21, 4, 30, 9]
    # Inizializziamo una lista vuota per i valori filtrati.
    filtrati = []
    # Inizializziamo l'indice di scansione della lista originale.
    indice = 0

    # Scorriamo tutti i valori della lista originale.
    while indice < len(valori):
        # Leggiamo il valore corrente.
        valore = valori[indice]
        # Controlliamo se il valore rispetta la soglia minima.
        if valore >= 10:
            # Aggiungiamo il valore alla lista filtrata.
            filtrati.append(valore)
        # Incrementiamo l'indice per passare al prossimo valore.
        indice = indice + 1

    # Inizializziamo una lista vuota per i quadrati.
    quadrati = []
    # Inizializziamo l'indice di scansione della lista filtrata.
    indice_filtrati = 0

    # Scorriamo tutti i valori filtrati.
    while indice_filtrati < len(filtrati):
        # Leggiamo il valore filtrato corrente.
        valore_filtrato = filtrati[indice_filtrati]
        # Calcoliamo il quadrato del valore corrente.
        quadrato = valore_filtrato * valore_filtrato
        # Aggiungiamo il quadrato alla lista dei risultati.
        quadrati.append(quadrato)
        # Incrementiamo l'indice della lista filtrata.
        indice_filtrati = indice_filtrati + 1

    # Stampiamo la lista dei valori filtrati.
    print("Filtrati:", filtrati)
    # Stampiamo la lista dei quadrati corrispondenti.
    print("Quadrati:", quadrati)


# Verifichiamo l'esecuzione come programma principale.
if __name__ == "__main__":
    # Eseguiamo la funzione principale.
    main()
