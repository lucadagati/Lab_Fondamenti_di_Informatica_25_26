"""Soluzione esercizio 8: minimo e massimo con funzione dedicata."""


# Definiamo una funzione che restituisce minimo e massimo.
def min_max(valori: list[int]) -> tuple[int, int]:
    # Inizializziamo il minimo con il primo elemento della lista.
    minimo = valori[0]
    # Inizializziamo il massimo con il primo elemento della lista.
    massimo = valori[0]
    # Inizializziamo l'indice di scansione.
    indice = 0

    # Scorriamo tutti gli elementi della lista.
    while indice < len(valori):
        # Leggiamo il valore corrente.
        valore = valori[indice]
        # Verifichiamo se il valore corrente e minore del minimo attuale.
        if valore < minimo:
            # Aggiorniamo il minimo.
            minimo = valore
        # Verifichiamo se il valore corrente e maggiore del massimo attuale.
        if valore > massimo:
            # Aggiorniamo il massimo.
            massimo = valore
        # Incrementiamo l'indice di scansione.
        indice = indice + 1

    # Restituiamo la coppia (minimo, massimo).
    return minimo, massimo


# Definiamo la funzione principale.
def main() -> None:
    # Creiamo una lista di numeri di esempio.
    numeri = [4, 19, 2, 8, 11]
    # Chiamiamo la funzione che calcola minimo e massimo.
    minimo, massimo = min_max(numeri)
    # Stampiamo il valore minimo trovato.
    print("Minimo:", minimo)
    # Stampiamo il valore massimo trovato.
    print("Massimo:", massimo)


# Verifichiamo l'esecuzione diretta del file.
if __name__ == "__main__":
    # Avviamo il programma principale.
    main()
