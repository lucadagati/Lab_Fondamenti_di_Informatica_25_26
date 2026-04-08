"""Soluzione esercizio 4."""

def conta_vocali(testo: str) -> int:
    count = 0
    for ch in testo.lower():
        if ch in "aeiou":
            count += 1
    return count


def main() -> None:
    s = input("Inserisci una frase: ")
    print("Vocali:", conta_vocali(s))


if __name__ == "__main__":
    main()
