"""Soluzione esercizio 2 con commenti didattici estesi."""


def main() -> None:
    # Definiamo la lista di numeri su cui lavorare.
    numeri = [7, 3, 12, 5, 9, 12, 1]

    # Inizializziamo la somma totale a zero.
    somma = 0
    # Inizializziamo il massimo con il primo elemento della lista.
    massimo = numeri[0]

    # Scorriamo ogni valore nella lista.
    for n in numeri:
        # Aggiorniamo la somma totale.
        somma += n
        # Se il valore corrente e maggiore del massimo, aggiorniamo massimo.
        if n > massimo:
            # Salviamo il nuovo massimo.
            massimo = n

    # Calcoliamo la media dividendo somma per numero elementi.
    media = somma / len(numeri)

    # Stampiamo la somma.
    print("Somma:", somma)
    # Stampiamo la media con due cifre decimali.
    print(f"Media: {media:.2f}")
    # Stampiamo il valore massimo.
    print("Massimo:", massimo)


if __name__ == "__main__":
    # Avviamo il programma principale.
    main()
