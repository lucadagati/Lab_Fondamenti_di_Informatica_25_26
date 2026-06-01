"""Soluzione esercizio 5: ordinamento tuple con selection sort esplicito."""


# Definiamo la funzione principale.
def main() -> None:
    # Creiamo la lista di tuple nel formato (nome, punteggio).
    coppie = [("Luca", 3), ("Anna", 1), ("Marta", 2)]
    # Copiamo la lista per lavorare su una versione separata.
    ordinate = coppie[:]
    # Salviamo la lunghezza della lista per non ricalcolarla continuamente.
    n = len(ordinate)
    # Inizializziamo l'indice esterno del selection sort.
    i = 0

    # Ripetiamo finche l'indice esterno non raggiunge il penultimo elemento.
    while i < n - 1:
        # Assumiamo che il minimo si trovi inizialmente nella posizione i.
        min_idx = i
        # Inizializziamo l'indice interno dalla posizione successiva.
        j = i + 1

        # Cerchiamo il minimo nella porzione non ordinata della lista.
        while j < n:
            # Confrontiamo il punteggio corrente con il minimo trovato finora.
            if ordinate[j][1] < ordinate[min_idx][1]:
                # Aggiorniamo la posizione del minimo trovato.
                min_idx = j
            # Passiamo all'elemento successivo della scansione interna.
            j = j + 1

        # Verifichiamo se e necessario eseguire uno scambio.
        if min_idx != i:
            # Salviamo temporaneamente l'elemento in posizione i.
            temporaneo = ordinate[i]
            # Spostiamo il minimo trovato in posizione i.
            ordinate[i] = ordinate[min_idx]
            # Ripristiniamo l'elemento temporaneo nella posizione del minimo.
            ordinate[min_idx] = temporaneo

        # Incrementiamo l'indice esterno per continuare l'ordinamento.
        i = i + 1

    # Stampiamo la lista ordinata finale.
    print("Ordinate:", ordinate)


# Verifichiamo se il file e eseguito come script principale.
if __name__ == "__main__":
    # Avviamo la funzione principale.
    main()
