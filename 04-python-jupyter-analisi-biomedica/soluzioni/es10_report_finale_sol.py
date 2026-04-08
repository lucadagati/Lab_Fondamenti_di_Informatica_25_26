"""Soluzione esercizio 10."""

def analizza_parole(frase: str) -> dict[str, int]:
    freq: dict[str, int] = {}

    # split su spazi + minuscole
    for parola in frase.lower().split():
        if parola not in freq:
            freq[parola] = 0
        freq[parola] += 1

    return freq


def main() -> None:
    frase = input("Inserisci frase: ")
    freq = analizza_parole(frase)

    totale_parole = sum(freq.values())
    parola_top = max(freq, key=freq.get) if freq else ""

    print("Totale parole:", totale_parole)
    if parola_top:
        print("Parola piu frequente:", parola_top, "->", freq[parola_top])


if __name__ == "__main__":
    main()
