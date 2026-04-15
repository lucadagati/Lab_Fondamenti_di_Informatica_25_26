"""Soluzione esercizio 4 con commenti didattici estesi."""


def conta_vocali(testo: str) -> int:
    # Inizializziamo il contatore delle vocali trovate.
    c = 0
    # Convertiamo il testo in minuscolo e scorriamo ogni carattere.
    for ch in testo.lower():
        # Se il carattere corrente e una vocale, incrementiamo il contatore.
        if ch in "aeiou":
            # Incremento del contatore.
            c += 1
    # Restituiamo il totale delle vocali contate.
    return c


def main() -> None:
    # Leggiamo la frase dall'utente.
    frase = input("Inserisci una frase: ")
    # Calcoliamo il numero di vocali presenti.
    totale = conta_vocali(frase)
    # Stampiamo il risultato finale.
    print("Vocali:", totale)


if __name__ == "__main__":
    # Avviamo il programma principale.
    main()
