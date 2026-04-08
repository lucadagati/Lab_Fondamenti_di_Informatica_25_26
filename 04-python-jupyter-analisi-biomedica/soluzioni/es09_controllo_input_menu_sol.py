from pathlib import Path
import csv


def carica_rows():
    csv_path = Path(__file__).parent.parent / "data" / "vitali_pazienti.csv"
    with csv_path.open(newline="", encoding="utf-8") as f:
        return list(csv.DictReader(f))


def main() -> None:
    rows = carica_rows()
    while True:
        print("1) Conteggio rischio  2) Media bpm  0) Esci")
        scelta = input("Scelta: ").strip()
        if scelta == "1":
            c=sum(1 for r in rows if int(r["bpm"])>=100 or int(r["spo2"])<95 or int(r["sistolica"])>=140)
            print("Rischio:", c)
        elif scelta == "2":
            m=sum(int(r["bpm"]) for r in rows)/len(rows)
            print(f"Media bpm: {m:.2f}")
        elif scelta == "0":
            break
        else:
            print("Scelta non valida")


if __name__ == "__main__":
    main()
