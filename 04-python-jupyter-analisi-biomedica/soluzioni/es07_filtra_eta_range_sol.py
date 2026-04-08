"""Soluzione esercizio 7."""

def main() -> None:
    valori = [12, 5, 18, 21, 4, 30, 9]

    # List comprehension
    filtrati = [v for v in valori if v >= 10]
    print(filtrati)


if __name__ == "__main__":
    main()
