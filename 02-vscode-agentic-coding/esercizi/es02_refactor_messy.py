"""
Esercizio 2 — Codice funzionante ma disordinato
------------------------------------------------
Rifattorizza senza cambiare il comportamento osservabile.
"""


def main() -> None:
    n = int(input("Quanti numeri? "))
    s = 0
    i = 0
    while i < n:
        x = int(input())
        s = s + x
        i = i + 1
    print("Somma:", s)


if __name__ == "__main__":
    main()
