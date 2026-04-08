# Lab 4 - Programmazione Python con Jupyter e script

Laboratorio orientato a:
- strutture di controllo (`if`, `for`, `while`)
- stringhe
- liste
- tuple
- dizionari
- funzioni

Ogni esercizio e disponibile in doppio formato:
- notebook in `jupyter/`
- script in `esercizi/`

Sono presenti anche le soluzioni:
- `jupyter_soluzioni/`
- `soluzioni/`

---

## 1) Setup ambiente

```bash
cd 02-vscode-agentic-coding
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements-jupyter.txt
cd ../04-python-jupyter-analisi-biomedica
```

Su Windows: `.venv\\Scripts\\activate`.

---

## 2) Esecuzione

Notebook:

```bash
jupyter lab
```

Script esempio:

```bash
python3 esercizi/es01_filtra_rischio.py
```

---

## 3) Mappa esercizi (notebook + script + soluzione)

| Esercizio | Notebook | Script | Soluzione notebook | Soluzione script |
|---|---|---|---|---|
| 1 | `jupyter/es01_filtra_rischio.ipynb` | `esercizi/es01_filtra_rischio.py` | `jupyter_soluzioni/es01_filtra_rischio_sol.ipynb` | `soluzioni/es01_filtra_rischio_sol.py` |
| 2 | `jupyter/es02_score_clinico.ipynb` | `esercizi/es02_score_clinico.py` | `jupyter_soluzioni/es02_score_clinico_sol.ipynb` | `soluzioni/es02_score_clinico_sol.py` |
| 3 | `jupyter/es03_medie_parametri.ipynb` | `esercizi/es03_media_parametri.py` | `jupyter_soluzioni/es03_medie_parametri_sol.ipynb` | `soluzioni/es03_media_parametri_sol.py` |
| 4 | `jupyter/es04_conta_ipertesi.ipynb` | `esercizi/es04_conta_ipertesi.py` | `jupyter_soluzioni/es04_conta_ipertesi_sol.ipynb` | `soluzioni/es04_conta_ipertesi_sol.py` |
| 5 | `jupyter/es05_top3_score.ipynb` | `esercizi/es05_ordinamento_score.py` | `jupyter_soluzioni/es05_top3_score_sol.ipynb` | `soluzioni/es05_ordinamento_score_sol.py` |
| 6 | `jupyter/es06_febbre_ipossia.ipynb` | `esercizi/es06_flag_febbre_ipossia.py` | `jupyter_soluzioni/es06_febbre_ipossia_sol.ipynb` | `soluzioni/es06_flag_febbre_ipossia_sol.py` |
| 7 | `jupyter/es07_fascia_eta.ipynb` | `esercizi/es07_filtra_eta_range.py` | `jupyter_soluzioni/es07_fascia_eta_sol.ipynb` | `soluzioni/es07_filtra_eta_range_sol.py` |
| 8 | `jupyter/es08_classi_pressione.ipynb` | `esercizi/es08_classifica_pressione.py` | `jupyter_soluzioni/es08_classi_pressione_sol.ipynb` | `soluzioni/es08_classifica_pressione_sol.py` |
| 9 | `jupyter/es09_menu_interattivo.ipynb` | `esercizi/es09_controllo_input_menu.py` | `jupyter_soluzioni/es09_menu_interattivo_sol.ipynb` | `soluzioni/es09_controllo_input_menu_sol.py` |
| 10 | `jupyter/es10_report_finale.ipynb` | `esercizi/es10_report_finale.py` | `jupyter_soluzioni/es10_report_finale_sol.ipynb` | `soluzioni/es10_report_finale_sol.py` |

---

## 4) Esercizi e diagrammi di flusso

## Esercizio 1 - Classifica voto (`if/elif/else`)
```mermaid
flowchart TD
    A[Leggi voto] --> B{voto < 18?}
    B -- Si --> C[Insufficiente]
    B -- No --> D{voto <= 24?}
    D -- Si --> E[Sufficiente]
    D -- No --> F{voto <= 29?}
    F -- Si --> G[Buono]
    F -- No --> H[Ottimo]
```

## Esercizio 2 - Somma, media, massimo (`for`)
```mermaid
flowchart TD
    A[Inizializza somma e massimo] --> B[Ciclo for]
    B --> C[Aggiorna somma]
    C --> D{Nuovo massimo?}
    D --> E[Fine ciclo]
    E --> F[Calcola media]
    F --> G[Stampa risultati]
```

## Esercizio 3 - Validazione input (`while`)
```mermaid
flowchart TD
    A[Leggi n] --> B{n positivo?}
    B -- No --> C[Richiedi di nuovo]
    C --> B
    B -- Si --> D[Stampa 1..n con while]
```

## Esercizio 4 - Conteggio vocali (stringhe)
```mermaid
flowchart TD
    A[Leggi frase] --> B[Scorri caratteri]
    B --> C{Vocale?}
    C -- Si --> D[Incrementa contatore]
    C -- No --> E[Continua]
    D --> E
    E --> F[Stampa totale]
```

## Esercizio 5 - Ordinamento tuple
```mermaid
flowchart TD
    A[Lista di tuple] --> B[Ordina per secondo elemento]
    B --> C[Mostra lista ordinata]
```

## Esercizio 6 - Dizionario frequenze
```mermaid
flowchart TD
    A[Leggi testo] --> B[Scorri caratteri]
    B --> C{Spazio?}
    C -- Si --> B
    C -- No --> D[Aggiorna dizionario]
    D --> E[Stampa frequenze]
```

## Esercizio 7 - Filtri su lista
```mermaid
flowchart TD
    A[Lista iniziale] --> B[Filtra valori >= 10]
    B --> C[Calcola quadrati]
    C --> D[Stampa liste]
```

## Esercizio 8 - Funzione con tuple return
```mermaid
flowchart TD
    A[Lista numeri] --> B[Inizializza min e max]
    B --> C[Ciclo elementi]
    C --> D[Aggiorna min/max]
    D --> E[Restituisci tupla]
```

## Esercizio 9 - Menu con while
```mermaid
flowchart TD
    A[Mostra menu] --> B[Leggi scelta]
    B --> C{1 / 2 / 0 / altro}
    C -->|1| D[Calcola quadrato]
    C -->|2| E[Calcola cubo]
    C -->|0| F[Esci]
    C -->|altro| G[Messaggio errore]
    D --> A
    E --> A
    G --> A
```

## Esercizio 10 - Analisi parole
```mermaid
flowchart TD
    A[Leggi frase] --> B[Split in parole]
    B --> C[Conta frequenze]
    C --> D[Calcola totale parole]
    D --> E[Trova parola top]
    E --> F[Stampa report]
```

---

## 5) Dataset

`data/vitali_pazienti.csv` e presente per continuita con i laboratori precedenti.

