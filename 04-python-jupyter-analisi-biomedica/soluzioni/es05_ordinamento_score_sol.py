"""Soluzione esercizio 5 con commenti didattici estesi."""


def main() -> None:
    # Definiamo lista di tuple nel formato (nome, punteggio).
    coppie = [("Luca", 3), ("Anna", 1), ("Marta", 2)]

    # Copiamo la lista per poterla ordinare senza modificare l'originale.
    ordinate = coppie[:]
    # Calcoliamo la lunghezza della lista.
    n = len(ordinate)
    # Inizializziamo l'indice esterno del selection sort.
    i = 0

    # Continuiamo finche non arriviamo al penultimo elemento.
    while i < n - 1:
        # Supponiamo inizialmente che il minimo sia nella posizione i.
        min_idx = i
        # Inizializziamo indice interno dalla posizione successiva.
        j = i + 1

        # Scansione del blocco residuo per trovare il minimo.
        while j < n:
            # Confrontiamo i punteggi (secondo elemento della tupla).
            if ordinate[j][1] < ordinate[min_idx][1]:
                # Aggiorniamo la posizione del minimo trovato.
                min_idx = j
            # Passiamo all'elemento successivo.
            j += 1

        # Se il minimo trovato non e gia in posizione i, scambiamo gli elementi.
        if min_idx != i:
            # Salviamo temporaneamente l'elemento in posizione i.
            tmp = ordinate[i]
            # Portiamo il minimo in posizione i.
            ordinate[i] = ordinate[min_idx]
            # Mettiamo l'elemento temporaneo nella vecchia posizione del minimo.
            ordinate[min_idx] = tmp

        # Avanziamo all'iterazione successiva dell'indice esterno.
        i += 1

    # Stampiamo la lista ordinata finale.
    print(ordinate)


if __name__ == "__main__":
    # Avviamo il programma.
    main()
