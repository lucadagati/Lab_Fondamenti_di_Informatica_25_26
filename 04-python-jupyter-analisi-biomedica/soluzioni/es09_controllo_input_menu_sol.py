"""Soluzione esercizio 9 con commenti didattici estesi."""


def main() -> None:
    # Iniziamo ciclo infinito del menu.
    while True:
        # Mostriamo opzione quadrato.
        print("1) Quadrato")
        # Mostriamo opzione cubo.
        print("2) Cubo")
        # Mostriamo opzione uscita.
        print("0) Esci")
        # Leggiamo la scelta utente e rimuoviamo spazi esterni.
        scelta = input("Scelta: ").strip()

        # Caso uscita.
        if scelta == "0":
            # Interrompiamo ciclo.
            break
        # Caso operazioni valide 1 o 2.
        elif scelta in ("1", "2"):
            # Chiediamo numero da elaborare.
            n = int(input("Numero: "))
            # Se scelta 1 calcoliamo quadrato.
            if scelta == "1":
                # Stampa quadrato.
                print("Quadrato:", n * n)
            else:
                # Stampa cubo.
                print("Cubo:", n * n * n)
        # Caso scelta non valida.
        else:
            # Messaggio errore input.
            print("Scelta non valida")


# Entrypoint.
if __name__ == "__main__":
    # Avvio programma.
    main()
