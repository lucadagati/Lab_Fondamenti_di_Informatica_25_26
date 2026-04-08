# Lab 4 - Python con Jupyter (ambiente del Lab 2)

Questo laboratorio riusa l'ambiente Python/Jupyter del Lab 2 e contiene **10 esercizi**.
Ogni esercizio include:
- consegna,
- hint,
- diagramma di flusso Mermaid,
- file soluzione.

---

## 1) Setup (stesso ambiente del Lab 2)

```bash
cd 02-vscode-agentic-coding
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements-jupyter.txt
cd ../04-python-jupyter-analisi-biomedica
```

Su Windows: `.venv\\Scripts\\activate`.

---

## 2) Struttura

- `data/vitali_pazienti.csv`
- `esercizi/`
- `soluzioni/`
- `jupyter/`

---

## 3) Esercizi Python

## Esercizio 1 - Filtro pazienti a rischio
- **File:** `esercizi/es01_filtra_rischio.py`
- **Consegna:** stampa gli ID dei pazienti a rischio.
- **Hint:** usa `csv.DictReader` + funzione booleana `paziente_a_rischio`.
- **Soluzione:** `soluzioni/es01_filtra_rischio_sol.py`

```mermaid
flowchart TD
    A[Carica CSV] --> B[Scorri pazienti]
    B --> C{Rischio?}
    C -- Si --> D[Stampa ID]
    C -- No --> E[Prossimo paziente]
    D --> E
```

## Esercizio 2 - Score clinico e classe rischio
- **File:** `esercizi/es02_score_clinico.py`
- **Consegna:** calcola score e classe per ogni paziente.
- **Hint:** funzione `score_clinico` + `classe_rischio`.
- **Soluzione:** `soluzioni/es02_score_clinico_sol.py`

```mermaid
flowchart TD
    A[Carica CSV] --> B[Per ogni paziente]
    B --> C[Calcola score]
    C --> D[Assegna classe]
    D --> E[Stampa riga report]
```

## Esercizio 3 - Medie parametri vitali
- **File:** `esercizi/es03_media_parametri.py`
- **Consegna:** calcola medie di `bpm`, `spo2`, `sistolica`.
- **Hint:** somma colonne e dividi per numero righe.
- **Soluzione:** `soluzioni/es03_media_parametri_sol.py`

```mermaid
flowchart TD
    A[Carica CSV] --> B[Inizializza somme]
    B --> C[Scorri righe]
    C --> D[Aggiorna somme]
    D --> E[Calcola medie]
    E --> F[Stampa medie]
```

## Esercizio 4 - Conteggio pazienti ipertesi
- **File:** `esercizi/es04_conta_ipertesi.py`
- **Consegna:** conta pazienti con `sistolica >= 140`.
- **Hint:** contatore + `if` nel ciclo.
- **Soluzione:** `soluzioni/es04_conta_ipertesi_sol.py`

```mermaid
flowchart TD
    A[Carica CSV] --> B[contatore = 0]
    B --> C[Scorri pazienti]
    C --> D{Sistolica alta?}
    D -- Si --> E[contatore += 1]
    D -- No --> F[continua]
    E --> F
    F --> G[Stampa contatore]
```

## Esercizio 5 - Ordinamento per score
- **File:** `esercizi/es05_ordinamento_score.py`
- **Consegna:** ordina pazienti per score decrescente e stampa top 3.
- **Hint:** `sorted(..., key=..., reverse=True)`.
- **Soluzione:** `soluzioni/es05_ordinamento_score_sol.py`

```mermaid
flowchart TD
    A[Carica CSV] --> B[Calcola score per paziente]
    B --> C[Ordina per score desc]
    C --> D[Prendi primi 3]
    D --> E[Stampa top 3]
```

## Esercizio 6 - Flag febbre + ipossia
- **File:** `esercizi/es06_flag_febbre_ipossia.py`
- **Consegna:** stampa ID con `temperatura >= 37.5` e `spo2 < 95`.
- **Hint:** condizione con `and`.
- **Soluzione:** `soluzioni/es06_flag_febbre_ipossia_sol.py`

```mermaid
flowchart TD
    A[Carica CSV] --> B[Scorri pazienti]
    B --> C{Febbre e ipossia?}
    C -- Si --> D[Stampa ID]
    C -- No --> E[Prossimo]
    D --> E
```

## Esercizio 7 - Filtro fascia d'eta
- **File:** `esercizi/es07_filtra_eta_range.py`
- **Consegna:** stampa ID con `50 <= eta <= 75`.
- **Hint:** condizione composta con doppio confronto.
- **Soluzione:** `soluzioni/es07_filtra_eta_range_sol.py`

```mermaid
flowchart TD
    A[Carica CSV] --> B[Scorri pazienti]
    B --> C{Eta nel range?}
    C -- Si --> D[Stampa ID]
    C -- No --> E[Prossimo]
    D --> E
```

## Esercizio 8 - Classifica pressione sistolica
- **File:** `esercizi/es08_classifica_pressione.py`
- **Consegna:** classifica ogni paziente in `Normale`, `Pre-ipertensione`, `Ipertensione`.
- **Hint:** funzione separata `classe_pressione`.
- **Soluzione:** `soluzioni/es08_classifica_pressione_sol.py`

```mermaid
flowchart TD
    A[Leggi sistolica] --> B{<130?}
    B -- Si --> C[Normale]
    B -- No --> D{<140?}
    D -- Si --> E[Pre-ipertensione]
    D -- No --> F[Ipertensione]
```

## Esercizio 9 - Menu testuale con controllo input
- **File:** `esercizi/es09_controllo_input_menu.py`
- **Consegna:** crea menu `1/2/0` con `while`.
- **Hint:** `while True` + `if/elif/else` + `break`.
- **Soluzione:** `soluzioni/es09_controllo_input_menu_sol.py`

```mermaid
flowchart TD
    A[Mostra menu] --> B[Leggi scelta]
    B --> C{Scelta valida?}
    C -- 1 --> D[Mostra conteggio rischio]
    C -- 2 --> E[Mostra media bpm]
    C -- 0 --> F[Esci]
    C -- Altro --> G[Messaggio errore]
    D --> A
    E --> A
    G --> A
```

## Esercizio 10 - Report clinico finale
- **File:** `esercizi/es10_report_finale.py`
- **Consegna:** stampa totale pazienti, numero rischio alto, ID con score massimo.
- **Hint:** funzione score + `max(..., key=...)`.
- **Soluzione:** `soluzioni/es10_report_finale_sol.py`

```mermaid
flowchart TD
    A[Carica CSV] --> B[Calcola score per tutti]
    B --> C[Conta score alti]
    C --> D[Trova score massimo]
    D --> E[Stampa report finale]
```

---

## 4) Notebook Jupyter

- `jupyter/01_esplorazione_vitali.ipynb`
- `jupyter/02_score_clinico.ipynb`

Avvio:

```bash
jupyter lab
```

---

## 5) Consegna studenti

Consegna:
1. almeno 8 script completati su 10,
2. notebook completati,
3. nota breve (6-8 righe) sulle differenze tra `.py` e `.ipynb`.

