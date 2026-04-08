from pathlib import Path
import csv


def main() -> None:
    csv_path = Path(__file__).parent.parent / "data" / "vitali_pazienti.csv"
    rows=[]
    with csv_path.open(newline="", encoding="utf-8") as f:
        rows=list(csv.DictReader(f))
    n=len(rows)
    mbpm=sum(int(r["bpm"]) for r in rows)/n
    mspo2=sum(int(r["spo2"]) for r in rows)/n
    msis=sum(int(r["sistolica"]) for r in rows)/n
    print(f"Media bpm: {mbpm:.2f}")
    print(f"Media spo2: {mspo2:.2f}")
    print(f"Media sistolica: {msis:.2f}")


if __name__ == "__main__":
    main()
