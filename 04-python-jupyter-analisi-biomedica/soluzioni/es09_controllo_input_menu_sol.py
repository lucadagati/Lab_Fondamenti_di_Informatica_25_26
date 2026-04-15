"""Soluzione esercizio 9 con commenti didattici estesi."""


def main() -> None:
    # Avviamo un ciclo infinito per ripetere il menu.
    while True:
        # Stampiamo opzione 1.
        print("1) Quadrato")
        # Stampiamo opzione 2.
        print("2) Cubo")
        # Stampiamo opzione uscita.
        print("0) Esci")
        # Leggiamo scelta dell'utente.
        scelta = input("Scelta: ").strip()

        # Se l'utente sceglie 0, usciamo dal ciclo.
        if scelta == "0":
            # Uscita menu.
            break
        # Se la scelta e 1 o 2, eseguiamo operazione numerica.
        elif scelta in ("1", "2"):
            # Chiediamo un numero all'utente.
            n = int(input("Numero: "))
            # Se scelta 1, calcoliamo quadrato.
            if scelta == "1":
                # Stampiamo quadrato del numero.
                print("Quadrato:", n * n)
            else:
                # Stampiamo cubo del numero.
                print("Cubo:", n * n * n)
        # In tutti gli altri casi, la scelta e non valida.
        else:
            # Messaggio per scelta non valida.
            print("Scelta non valida")


if __name__ == "__main__":
    # Avviamo la funzione principale.
    main()
