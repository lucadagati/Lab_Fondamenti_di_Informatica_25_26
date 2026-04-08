from pathlib import Path
import csv


def carica_rows() -> list[dict]:
    csv_path = Path(__file__).parent.parent / "data" / "vitali_pazienti.csv"
    with csv_path.open(newline="", encoding="utf-8") as f:
        return list(csv.DictReader(f))


def conteggio_rischio(rows: list[dict]) -> int:
    cont = 0
    for r in rows:
        if int(r["bpm"]) >= 100 or int(r["spo2"]) < 95 or int(r["sistolica"]) >= 140:
            cont += 1
    return cont


def media_bpm(rows: list[dict]) -> float:
    somma = 0
    for r in rows:
        somma += int(r["bpm"])
    return somma / len(rows)


def main() -> None:
    rows = carica_rows()

    while True:
        print("1) Conteggio rischio")
        print("2) Media bpm")
        print("0) Esci")
        scelta = input("Scelta: ").strip()

        if scelta == "1":
            print("Rischio:", conteggio_rischio(rows))
        elif scelta == "2":
            print(f"Media bpm: {media_bpm(rows):.2f}")
        elif scelta == "0":
            break
        else:
            print("Scelta non valida")


if __name__ == "__main__":
    main()
