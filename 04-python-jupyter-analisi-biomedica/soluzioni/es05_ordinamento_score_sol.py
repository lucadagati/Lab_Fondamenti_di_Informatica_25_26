"""Soluzione esercizio 5 con commenti didattici estesi."""


def main() -> None:
    # Definiamo lista di tuple (nome, punteggio).
    coppie = [("Luca", 3), ("Anna", 1), ("Marta", 2)]

    # Copiamo la lista originale per non modificarla direttamente.
    ordinate = coppie[:]
    # Calcoliamo lunghezza lista.
    n = len(ordinate)
    # Inizializziamo indice esterno.
    i = 0

    # Ciclo esterno fino al penultimo elemento.
    while i < n - 1:
        # Assumiamo che il minimo sia in posizione i.
        min_idx = i
        # Inizializziamo indice interno dalla posizione successiva.
        j = i + 1

        # Ciclo interno per trovare minimo nel blocco residuo.
        while j < n:
            # Confrontiamo il secondo elemento della tupla.
            if ordinate[j][1] < ordinate[min_idx][1]:
                # Aggiorniamo indice del minimo.
                min_idx = j
            # Passiamo all'elemento successivo.
            j += 1

        # Se il minimo non e gia in posizione i, scambiamo.
        if min_idx != i:
            # Salviamo temporaneamente elemento in posizione i.
            tmp = ordinate[i]
            # Mettiamo il minimo in posizione i.
            ordinate[i] = ordinate[min_idx]
            # Ripristiniamo elemento vecchio nella posizione del minimo.
            ordinate[min_idx] = tmp

        # Avanziamo l'indice esterno.
        i += 1

    # Stampiamo lista ordinata.
    print(ordinate)


# Entrypoint file.
if __name__ == "__main__":
    # Esecuzione funzione principale.
    main()
