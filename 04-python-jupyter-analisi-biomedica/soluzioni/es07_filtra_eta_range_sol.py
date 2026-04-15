"""Soluzione esercizio 7 con commenti didattici estesi."""


def main() -> None:
    # Definiamo la lista di partenza.
    valori = [12, 5, 18, 21, 4, 30, 9]

    # Inizializziamo lista vuota per i valori filtrati.
    filtrati = []

    # Cicliamo su tutti i valori iniziali.
    for v in valori:
        # Se il valore e almeno 10, lo aggiungiamo ai filtrati.
        if v >= 10:
            # Aggiungiamo il valore alla lista filtrata.
            filtrati.append(v)

    # Inizializziamo lista vuota per i quadrati.
    quadrati = []

    # Cicliamo sui valori filtrati.
    for v in filtrati:
        # Calcoliamo il quadrato del valore corrente.
        q = v * v
        # Aggiungiamo il quadrato alla lista quadrati.
        quadrati.append(q)

    # Stampiamo la lista filtrata.
    print("Filtrati:", filtrati)
    # Stampiamo la lista dei quadrati.
    print("Quadrati:", quadrati)


if __name__ == "__main__":
    # Avviamo il programma principale.
    main()
