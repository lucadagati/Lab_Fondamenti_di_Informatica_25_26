# Lab 4 - Python con Jupyter (ambiente del Lab 2)

Questo laboratorio usa **lo stesso ambiente Python/Jupyter del Lab 2**.  
Obiettivo: lavorare su un piccolo dataset biomedico e creare un mini-report clinico.

---

## 1) Riusa l'ambiente del Lab 2

Dalla root del repository:

```bash
cd 02-vscode-agentic-coding
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements-jupyter.txt
```

Poi torna al Lab 4:

```bash
cd ../04-python-jupyter-analisi-biomedica
```

Su Windows, attiva con `.venv\\Scripts\\activate`.

---

## 2) Struttura del Lab 4

- `data/vitali_pazienti.csv` -> dataset di parametri vitali
- `esercizi/` -> script Python da completare
- `soluzioni/` -> script Python completi
- `jupyter/` -> notebook con celle `TODO`

---

## 3) Esercizi Python

## Esercizio 1 - Filtro pazienti a rischio

- **File:** `esercizi/es01_filtra_rischio.py`
- **Consegna:** caricare il CSV e stampare gli ID dei pazienti a rischio.
- **Regola rischio:** almeno una condizione vera:
  - `bpm >= 100`
  - `spo2 < 95`
  - `sistolica >= 140`
- **Hint:**
  1. usa `csv.DictReader`
  2. converti i campi numerici (`int`/`float`)
  3. crea funzione `paziente_a_rischio()`
- **Soluzione:** `soluzioni/es01_filtra_rischio_sol.py`

### Esecuzione

```bash
python3 esercizi/es01_filtra_rischio.py
```

---

## Esercizio 2 - Score clinico e classe rischio

- **File:** `esercizi/es02_score_clinico.py`
- **Consegna:** per ogni paziente calcolare score e classe.
- **Regole score:**
  - `+2` se `eta >= 70`
  - `+1` se `bpm >= 100`
  - `+2` se `spo2 < 95`
  - `+2` se `sistolica >= 140`
  - `+1` se `temperatura >= 37.5`
- **Classi rischio:**
  - `0-2` -> `Basso`
  - `3-5` -> `Medio`
  - `>=6` -> `Alto`
- **Soluzione:** `soluzioni/es02_score_clinico_sol.py`

### Esecuzione

```bash
python3 esercizi/es02_score_clinico.py
```

---

## 4) Notebook Jupyter

## Notebook 1 - Esplorazione parametri vitali

- **File:** `jupyter/01_esplorazione_vitali.ipynb`
- **TODO:**
  1. conteggio pazienti con `bpm >= 100`
  2. elenco `id` e `spo2` per `spo2 < 95`
  3. colonna booleana `flag_rischio`

## Notebook 2 - Score e grafico

- **File:** `jupyter/02_score_clinico.ipynb`
- **TODO:**
  1. colonna `score_clinico`
  2. colonna `classe_rischio`
  3. grafico a barre con numero pazienti per classe

Per avviare Jupyter:

```bash
jupyter lab
```

---

## 5) Consegna studenti

Consegna:
1. i due file completati in `esercizi/`,
2. notebook con celle `TODO` completate,
3. una breve nota (6-8 righe) su come cambia il lavoro tra script `.py` e notebook `.ipynb`.

