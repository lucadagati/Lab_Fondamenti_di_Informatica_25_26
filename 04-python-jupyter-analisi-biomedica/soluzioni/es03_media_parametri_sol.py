from pathlib import Path
import csv


def main() -> None:
    csv_path = Path(__file__).parent.parent / "data" / "vitali_pazienti.csv"

    with csv_path.open(newline="", encoding="utf-8") as f:
        rows = list(csv.DictReader(f))

    # Somme iniziali
    somma_bpm = 0
    somma_spo2 = 0
    somma_sistolica = 0

    for r in rows:
        somma_bpm += int(r["bpm"])
        somma_spo2 += int(r["spo2"])
        somma_sistolica += int(r["sistolica"])

    n = len(rows)

    media_bpm = somma_bpm / n
    media_spo2 = somma_spo2 / n
    media_sistolica = somma_sistolica / n

    print(f"Media bpm: {media_bpm:.2f}")
    print(f"Media spo2: {media_spo2:.2f}")
    print(f"Media sistolica: {media_sistolica:.2f}")


if __name__ == "__main__":
    main()
