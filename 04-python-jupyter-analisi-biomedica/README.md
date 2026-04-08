# Lab 4 - Programmazione Python: prima Jupyter, poi script `.py`

Questo laboratorio e orientato alle basi di programmazione:
- strutture di controllo (`if`, `for`, `while`)
- stringhe
- liste
- tuple
- dizionari
- funzioni

L'ordine consigliato e:
1. **Jupyter** (`jupyter/`)
2. **Python script** (`esercizi/`)

---

## 1) Setup (riuso ambiente del Lab 2)

```bash
cd 02-vscode-agentic-coding
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements-jupyter.txt
cd ../04-python-jupyter-analisi-biomedica
```

Su Windows: `.venv\\Scripts\\activate`.

---

## 2) Parte A - Jupyter (prima)

Avvio:

```bash
jupyter lab
```

Notebook esercizi (`jupyter/`):
- `es01_filtra_rischio.ipynb` -> classifica voto con `if/elif/else`
- `es02_score_clinico.ipynb` -> somma/media/massimo con `for`
- `es03_medie_parametri.ipynb` -> validazione con `while`
- `es04_conta_ipertesi.ipynb` -> stringhe e conteggio vocali
- `es05_top3_score.ipynb` -> tuple e ordinamento
- `es06_febbre_ipossia.ipynb` -> dizionari (frequenze)
- `es07_fascia_eta.ipynb` -> list comprehension
- `es08_classi_pressione.ipynb` -> funzioni con ritorno tuple
- `es09_menu_interattivo.ipynb` -> menu con `while`/`if`
- `es10_report_finale.ipynb` -> analisi parole (stringhe + dizionario)

Notebook soluzioni (`jupyter_soluzioni/`):
- `es01_filtra_rischio_sol.ipynb`
- `es02_score_clinico_sol.ipynb`
- `es03_medie_parametri_sol.ipynb`
- `es04_conta_ipertesi_sol.ipynb`
- `es05_top3_score_sol.ipynb`
- `es06_febbre_ipossia_sol.ipynb`
- `es07_fascia_eta_sol.ipynb`
- `es08_classi_pressione_sol.ipynb`
- `es09_menu_interattivo_sol.ipynb`
- `es10_report_finale_sol.ipynb`

---

## 3) Parte B - Python `.py` (dopo)

Stessi temi dei notebook, ma in formato script.

Esercizi:
- `esercizi/es01_filtra_rischio.py`
- `esercizi/es02_score_clinico.py`
- `esercizi/es03_media_parametri.py`
- `esercizi/es04_conta_ipertesi.py`
- `esercizi/es05_ordinamento_score.py`
- `esercizi/es06_flag_febbre_ipossia.py`
- `esercizi/es07_filtra_eta_range.py`
- `esercizi/es08_classifica_pressione.py`
- `esercizi/es09_controllo_input_menu.py`
- `esercizi/es10_report_finale.py`

Soluzioni:
- `soluzioni/es01_filtra_rischio_sol.py`
- `soluzioni/es02_score_clinico_sol.py`
- `soluzioni/es03_media_parametri_sol.py`
- `soluzioni/es04_conta_ipertesi_sol.py`
- `soluzioni/es05_ordinamento_score_sol.py`
- `soluzioni/es06_flag_febbre_ipossia_sol.py`
- `soluzioni/es07_filtra_eta_range_sol.py`
- `soluzioni/es08_classifica_pressione_sol.py`
- `soluzioni/es09_controllo_input_menu_sol.py`
- `soluzioni/es10_report_finale_sol.py`

Esecuzione esempio:

```bash
python3 esercizi/es01_filtra_rischio.py
```

---

## 4) Dataset

`data/vitali_pazienti.csv` e mantenuto nel repo per compatibilita con i laboratori precedenti, ma in questo Lab 4 il focus e sulla programmazione generale.

