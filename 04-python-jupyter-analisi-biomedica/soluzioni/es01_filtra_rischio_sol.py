"""Soluzione esercizio 1 con commenti didattici estesi."""


def classifica_voto(voto: int) -> str:
    # Se il voto e sotto 18, lo studente e insufficiente.
    if voto < 18:
        # Restituiamo la classe corrispondente.
        return "Insufficiente"
    # Se il voto e al massimo 24, classe sufficiente.
    if voto <= 24:
        # Restituiamo la classe corrispondente.
        return "Sufficiente"
    # Se il voto e al massimo 29, classe buona.
    if voto <= 29:
        # Restituiamo la classe corrispondente.
        return "Buono"
    # Nei casi restanti, voto ottimo.
    return "Ottimo"


def main() -> None:
    # Leggiamo un voto intero da tastiera.
    voto = int(input("Inserisci voto: "))
    # Calcoliamo la classe del voto.
    classe = classifica_voto(voto)
    # Stampiamo il risultato finale.
    print("Classe:", classe)


if __name__ == "__main__":
    # Avviamo l'esecuzione del programma.
    main()
