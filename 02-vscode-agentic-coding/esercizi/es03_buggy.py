"""
Esercizio 3 — Anno bisestile (contiene un errore logico)
--------------------------------------------------------
Regola corretta (Gregorio):
- bisestile se divisibile per 4,
- eccetto se divisibile per 100,
- salvo se divisibile per 400.
"""


def is_leap_year(year: int) -> bool:
    # ATTENZIONE: la logica sotto non è completamente corretta
    if year % 4 == 0:
        return True
    if year % 100 == 0:
        return True
    if year % 400 == 0:
        return True
    return False


def main() -> None:
    y = int(input("Anno: "))
    if is_leap_year(y):
        print("Bisestile")
    else:
        print("Non bisestile")


if __name__ == "__main__":
    main()
