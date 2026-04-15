"""Soluzione esercizio 3 con commenti didattici estesi."""


def main() -> None:
    # Leggiamo il valore iniziale fornito dall'utente.
    n = int(input("Inserisci un intero positivo: "))

    # Finche n non e positivo, continuiamo a richiederlo.
    while n <= 0:
        # Informiamo che il valore inserito non va bene.
        print("Valore non valido.")
        # Richiediamo nuovamente un valore.
        n = int(input("Inserisci un intero positivo: "))

    # Inizializziamo il contatore da stampare.
    i = 1

    # Cicliamo finche i non supera n.
    while i <= n:
        # Stampiamo il valore corrente del contatore.
        print(i)
        # Incrementiamo il contatore di 1.
        i += 1


if __name__ == "__main__":
    # Avviamo la funzione principale.
    main()
