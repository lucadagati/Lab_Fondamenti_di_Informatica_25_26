"""Soluzione esercizio 1."""

def classifica_voto(voto: int) -> str:
    # Decisione con if/elif/else
    if voto < 18:
        return "Insufficiente"
    if voto <= 24:
        return "Sufficiente"
    if voto <= 29:
        return "Buono"
    return "Ottimo"


def main() -> None:
    voto = int(input("Inserisci voto: "))
    print("Classe:", classifica_voto(voto))


if __name__ == "__main__":
    main()
