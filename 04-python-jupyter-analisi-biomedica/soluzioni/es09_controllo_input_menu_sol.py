"""Soluzione esercizio 9: menu testuale con while e scelte esplicite."""


# Definiamo la funzione principale.
def main() -> None:
    # Avviamo un ciclo infinito per il menu.
    while True:
        # Mostriamo la prima opzione del menu.
        print("1) Quadrato")
        # Mostriamo la seconda opzione del menu.
        print("2) Cubo")
        # Mostriamo l'opzione di uscita.
        print("0) Esci")
        # Leggiamo la scelta dell'utente.
        scelta = input("Scelta: ").strip()

        # Controlliamo se l'utente ha scelto di uscire.
        if scelta == "0":
            # Interrompiamo il ciclo del menu.
            break
        # Controlliamo se l'utente ha scelto quadrato.
        elif scelta == "1":
            # Chiediamo il numero su cui calcolare il quadrato.
            testo_numero = input("Numero: ")
            # Convertiamo il testo in numero intero.
            numero = int(testo_numero)
            # Calcoliamo il quadrato del numero.
            risultato = numero * numero
            # Stampiamo il risultato del quadrato.
            print("Quadrato:", risultato)
        # Controlliamo se l'utente ha scelto cubo.
        elif scelta == "2":
            # Chiediamo il numero su cui calcolare il cubo.
            testo_numero = input("Numero: ")
            # Convertiamo il testo in numero intero.
            numero = int(testo_numero)
            # Calcoliamo il cubo del numero.
            risultato = numero * numero * numero
            # Stampiamo il risultato del cubo.
            print("Cubo:", risultato)
        # Gestiamo tutte le scelte non valide.
        else:
            # Stampiamo un messaggio di errore.
            print("Scelta non valida")


# Verifichiamo l'esecuzione del file come script principale.
if __name__ == "__main__":
    # Avviamo la funzione principale.
    main()
