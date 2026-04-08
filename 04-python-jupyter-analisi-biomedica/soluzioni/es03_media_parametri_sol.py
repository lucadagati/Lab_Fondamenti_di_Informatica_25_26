"""Soluzione esercizio 3."""

def main() -> None:
    n = int(input("Inserisci un intero positivo: "))

    # Validazione con while
    while n <= 0:
        print("Valore non valido.")
        n = int(input("Inserisci un intero positivo: "))

    i = 1
    while i <= n:
        print(i)
        i += 1


if __name__ == "__main__":
    main()
