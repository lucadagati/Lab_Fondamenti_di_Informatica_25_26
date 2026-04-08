"""Soluzione esercizio 6."""

def frequenze_caratteri(testo: str) -> dict[str, int]:
    freq: dict[str, int] = {}

    for ch in testo.lower():
        if ch == " ":
            continue
        if ch not in freq:
            freq[ch] = 0
        freq[ch] += 1

    return freq


def main() -> None:
    s = input("Inserisci testo: ")
    print(frequenze_caratteri(s))


if __name__ == "__main__":
    main()
