from pathlib import Path
import csv


def main() -> None:
    csv_path = Path(__file__).parent.parent / "data" / "vitali_pazienti.csv"

    # Leggiamo il CSV in una lista di righe (dict)
    with csv_path.open(newline="", encoding="utf-8") as f:
        rows = list(csv.DictReader(f))

    print("Pazienti a rischio:")

    # Un paziente è a rischio se almeno una regola è vera
    for r in rows:
        bpm_alto = int(r["bpm"]) >= 100
        spo2_bassa = int(r["spo2"]) < 95
        sistolica_alta = int(r["sistolica"]) >= 140

        if bpm_alto or spo2_bassa or sistolica_alta:
            print("-", r["id"])


if __name__ == "__main__":
    main()
