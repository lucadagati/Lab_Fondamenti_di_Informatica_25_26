import subprocess
import sys
from pathlib import Path


def main() -> None:
    # Aggiunge la cartella del progetto allo scope import
    base = Path(__file__).parent
    sys.path.insert(0, str(base))

    from src.io_pazienti import carica_pazienti
    from src.metriche import (
        calcola_bmi,
        categoria_bmi,
        priorita,
        punteggio_rischio,
    )

    # ---- Test metriche (valori attesi) ----
    bmi = calcola_bmi(60.0, 1.6)
    assert abs(bmi - (60.0 / (1.6**2))) < 1e-9
    assert categoria_bmi(17.0) == "Sottopeso"
    assert categoria_bmi(22.0) == "Normopeso"
    assert categoria_bmi(27.0) == "Sovrappeso"
    assert categoria_bmi(33.0) == "Obesità"

    assert punteggio_rischio(70, 110, 150) == 5
    assert punteggio_rischio(30, 80, 120) == 0
    assert punteggio_rischio(65, 99, 120) == 2
    assert punteggio_rischio(40, 100, 140) == 3

    assert priorita(0) == "Bassa"
    assert priorita(1) == "Bassa"
    assert priorita(2) == "Media"
    assert priorita(3) == "Media"
    assert priorita(4) == "Alta"
    assert priorita(5) == "Alta"

    # ---- Test parsing CSV (minimo) ----
    csv_path = base / "dati" / "pazienti_esempio.csv"
    pazienti = carica_pazienti(csv_path)
    assert isinstance(pazienti, list) and len(pazienti) >= 1
    for p in pazienti:
        for key in ("id", "sesso", "eta", "peso_kg", "altezza_m", "bpm", "sistolica"):
            assert key in p

    # ---- Run main (deve non crashare) ----
    # Nota: non controlliamo testo preciso; verifichiamo solo che stampi un report.
    proc = subprocess.run(
        [sys.executable, str(base / "main.py")],
        cwd=str(base),
        capture_output=True,
        text=True,
    )
    assert proc.returncode == 0, proc.stderr
    out = proc.stdout.lower()
    assert "totale" in out
    assert "categoria" in out
    assert "priorit" in out

    print("OK: verify completato (metriche, parsing CSV e main).")


if __name__ == "__main__":
    main()

