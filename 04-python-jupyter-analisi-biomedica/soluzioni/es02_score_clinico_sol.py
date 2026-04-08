from pathlib import Path
import csv


def calcola_score(r: dict) -> int:
    """Calcola uno score semplice con regole additive."""
    score = 0

    if int(r["eta"]) >= 70:
        score += 2
    if int(r["bpm"]) >= 100:
        score += 1
    if int(r["spo2"]) < 95:
        score += 2
    if int(r["sistolica"]) >= 140:
        score += 2
    if float(r["temperatura"]) >= 37.5:
        score += 1

    return score


def classe_rischio(score: int) -> str:
    """Converte score in classe testuale."""
    if score <= 2:
        return "Basso"
    if score <= 5:
        return "Medio"
    return "Alto"


def main() -> None:
    csv_path = Path(__file__).parent.parent / "data" / "vitali_pazienti.csv"

    with csv_path.open(newline="", encoding="utf-8") as f:
        rows = list(csv.DictReader(f))

    print("Report rischio clinico")
    print("=====================")

    for r in rows:
        s = calcola_score(r)
        c = classe_rischio(s)
        print(f"{r['id']}: score={s}, classe={c}")


if __name__ == "__main__":
    main()
