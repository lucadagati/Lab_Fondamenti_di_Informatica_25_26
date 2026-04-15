"""Soluzione esercizio 8 con commenti didattici estesi."""


def min_max(valori: list[int]) -> tuple[int, int]:
    # Inizializziamo minimo con il primo valore della lista.
    minimo = valori[0]
    # Inizializziamo massimo con lo stesso primo valore.
    massimo = valori[0]

    # Scorriamo tutti i valori della lista.
    for v in valori:
        # Se il valore corrente e minore del minimo, aggiorniamo minimo.
        if v < minimo:
            # Nuovo minimo.
            minimo = v
        # Se il valore corrente e maggiore del massimo, aggiorniamo massimo.
        if v > massimo:
            # Nuovo massimo.
            massimo = v

    # Restituiamo la tupla (minimo, massimo).
    return minimo, massimo


def main() -> None:
    # Definiamo lista numeri di test.
    nums = [4, 19, 2, 8, 11]
    # Calcoliamo minimo e massimo con la funzione dedicata.
    mn, mx = min_max(nums)
    # Stampiamo il minimo.
    print("Minimo:", mn)
    # Stampiamo il massimo.
    print("Massimo:", mx)


if __name__ == "__main__":
    # Eseguiamo il programma.
    main()
