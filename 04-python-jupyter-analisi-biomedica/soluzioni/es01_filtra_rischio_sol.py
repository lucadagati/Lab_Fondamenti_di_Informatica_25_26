"""Soluzione esercizio 1: classificazione voto con commenti riga per riga."""


# Definiamo una funzione che classifica un voto numerico.
def classifica_voto(voto: int) -> str:
    # Controlliamo se il voto e sotto la soglia di sufficienza.
    if voto < 18:
        # Restituiamo la classe testuale per voto insufficiente.
        return "Insufficiente"
    # Controlliamo se il voto rientra nella fascia sufficiente.
    if voto <= 24:
        # Restituiamo la classe testuale per voto sufficiente.
        return "Sufficiente"
    # Controlliamo se il voto rientra nella fascia buona.
    if voto <= 29:
        # Restituiamo la classe testuale per voto buono.
        return "Buono"
    # Nei casi rimanenti il voto e ottimo.
    return "Ottimo"


# Definiamo la funzione principale del programma.
def main() -> None:
    # Chiediamo all'utente di inserire un voto.
    testo_voto = input("Inserisci voto: ")
    # Convertiamo il valore inserito da stringa a intero.
    voto = int(testo_voto)
    # Chiamiamo la funzione che produce la classe del voto.
    classe = classifica_voto(voto)
    # Stampiamo il risultato finale all'utente.
    print("Classe:", classe)


# Verifichiamo che il file sia eseguito come programma principale.
if __name__ == "__main__":
    # Avviamo la funzione principale.
    main()
