"""Soluzione esercizio 3: validazione input con while e stampa sequenza."""


# Definiamo la funzione principale.
def main() -> None:
    # Chiediamo un intero positivo all'utente.
    testo_n = input("Inserisci un intero positivo: ")
    # Convertiamo il valore inserito in intero.
    n = int(testo_n)

    # Ripetiamo finche il valore non diventa positivo.
    while n <= 0:
        # Informiamo l'utente che il dato non e valido.
        print("Valore non valido")
        # Chiediamo di nuovo il valore all'utente.
        testo_n = input("Inserisci un intero positivo: ")
        # Convertiamo nuovamente il valore in intero.
        n = int(testo_n)

    # Inizializziamo il contatore di partenza.
    i = 1
    # Stampiamo i numeri da 1 a n.
    while i <= n:
        # Stampiamo il valore corrente del contatore.
        print(i)
        # Incrementiamo il contatore di una unita.
        i = i + 1


# Verifichiamo l'esecuzione come script principale.
if __name__ == "__main__":
    # Avviamo la funzione principale.
    main()
