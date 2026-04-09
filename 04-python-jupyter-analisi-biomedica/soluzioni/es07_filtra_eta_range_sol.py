"""Soluzione esercizio 7 con commenti didattici estesi."""


def main() -> None:
    # Lista numerica di esempio.
    valori = [12, 5, 18, 21, 4, 30, 9]

    # Inizializziamo lista filtrata vuota.
    filtrati = []

    # Scorriamo ogni valore della lista originale.
    for v in valori:
        # Se il valore e almeno 10, lo conserviamo.
        if v >= 10:
            # Aggiungiamo valore alla lista filtrata.
            filtrati.append(v)

    # Stampiamo il risultato del filtro.
    print(filtrati)


# Esecuzione condizionale.
if __name__ == "__main__":
    # Avvio programma.
    main()
