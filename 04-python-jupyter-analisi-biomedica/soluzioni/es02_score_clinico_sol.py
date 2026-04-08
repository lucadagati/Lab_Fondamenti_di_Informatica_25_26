"""Soluzione esercizio 2."""

def main() -> None:
    numeri = [7, 3, 12, 5, 9, 12, 1]

    somma = 0
    massimo = numeri[0]

    # Ciclo for classico
    for n in numeri:
        somma += n
        if n > massimo:
            massimo = n

    media = somma / len(numeri)

    print("Somma:", somma)
    print(f"Media: {media:.2f}")
    print("Massimo:", massimo)


if __name__ == "__main__":
    main()
