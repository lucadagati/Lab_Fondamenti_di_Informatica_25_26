"""Soluzione esercizio 5."""

def main() -> None:
    coppie = [("Luca", 3), ("Anna", 1), ("Marta", 2)]

    # Ordino per secondo elemento della tupla
    ordinate = sorted(coppie, key=lambda t: t[1])
    print(ordinate)


if __name__ == "__main__":
    main()
