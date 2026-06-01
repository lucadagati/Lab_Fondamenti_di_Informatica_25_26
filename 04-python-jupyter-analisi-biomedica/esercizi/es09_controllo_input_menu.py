"""Esercizio 9: menu testuale con while."""


def main() -> None:
    # Ciclo infinito del menu.
    while True:
        # Mostriamo le opzioni.
        print("1) Quadrato")
        print("2) Cubo")
        print("0) Esci")

        # Leggiamo scelta.
        scelta = input("Scelta: ").strip()

        # TODO: se scelta == "0" esci dal ciclo
        # TODO: se scelta == "1" chiedi numero e stampa quadrato
        # TODO: se scelta == "2" chiedi numero e stampa cubo
        # TODO: altrimenti stampa messaggio errore
        raise NotImplementedError


if __name__ == "__main__":
    main()
