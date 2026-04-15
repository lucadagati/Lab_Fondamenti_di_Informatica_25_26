"""Soluzione esercizio 2: somma, media e massimo con commenti riga per riga."""


# Definiamo la funzione principale.
def main() -> None:
    # Creiamo la lista dei numeri da analizzare.
    numeri = [7, 3, 12, 5, 9, 12, 1]
    # Inizializziamo la variabile della somma totale.
    somma = 0
    # Inizializziamo il massimo con il primo elemento della lista.
    massimo = numeri[0]
    # Inizializziamo l'indice di scorrimento.
    indice = 0

    # Ripetiamo il ciclo finche non abbiamo letto tutta la lista.
    while indice < len(numeri):
        # Leggiamo il valore corrente della lista.
        valore = numeri[indice]
        # Aggiorniamo la somma totale aggiungendo il valore corrente.
        somma = somma + valore
        # Controlliamo se il valore corrente supera il massimo attuale.
        if valore > massimo:
            # Aggiorniamo il massimo con il nuovo valore trovato.
            massimo = valore
        # Incrementiamo l'indice per passare all'elemento successivo.
        indice = indice + 1

    # Calcoliamo la media dividendo la somma per il numero di elementi.
    media = somma / len(numeri)
    # Stampiamo la somma calcolata.
    print("Somma:", somma)
    # Stampiamo la media calcolata.
    print("Media:", round(media, 2))
    # Stampiamo il massimo trovato.
    print("Massimo:", massimo)


# Verifichiamo che il file sia eseguito direttamente.
if __name__ == "__main__":
    # Eseguiamo la funzione principale.
    main()
