"""Soluzione esercizio 9."""

def main() -> None:
    while True:
        print("1) Quadrato")
        print("2) Cubo")
        print("0) Esci")
        scelta = input("Scelta: ").strip()

        if scelta == "0":
            break
        elif scelta in ("1", "2"):
            n = int(input("Numero: "))
            if scelta == "1":
                print("Quadrato:", n * n)
            else:
                print("Cubo:", n * n * n)
        else:
            print("Scelta non valida")


if __name__ == "__main__":
    main()
