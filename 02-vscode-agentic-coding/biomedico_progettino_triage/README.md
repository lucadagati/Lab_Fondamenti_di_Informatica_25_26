# Lab biomedico (mini-triage): dati pazienti + BMI + priorità

Obiettivo: creare un progettino concreto in ambito biomedico usando un approccio **agentico** controllato da te.

Il programma deve:
1. caricare un CSV con dati fittizi di pazienti,
2. calcolare BMI,
3. assegnare una priorità (bassa/media/alta) basata su età, bpm e sistolica,
4. stampare un report leggibile.

---

## Struttura

- `dati/pazienti_esempio.csv` (dataset fittizio)
- `src/metriche.py` (funzioni: BMI, categorie, punteggio priorità)
- `src/io_pazienti.py` (caricamento CSV)
- `main.py` (report finale)
- `verify.py` (controlli automatici)

---

## Setup ed esecuzione

Dentro `biomedico_progettino_triage/`:

```bash
cd biomedico_progettino_triage
python3 main.py
```

Per verificare dopo le modifiche:

```bash
cd biomedico_progettino_triage
python3 verify.py
```

---

## Prompts didattici (da copiare/incollare)

### Prompt 1 (calcoli in `src/metriche.py`)

```text
Agente: completa SOLO `src/metriche.py`.
Implementa queste funzioni:
- calcola_bmi(peso_kg: float, altezza_m: float) -> float
- categoria_bmi(bmi: float) -> str con categorie:
  - < 18.5: "Sottopeso"
  - < 25.0: "Normopeso"
  - < 30.0: "Sovrappeso"
  - altrimenti: "Obesità"
- punteggio_rischio(eta: int, bpm: float, sistolica: float) -> int (0..5)
  regole:
  - +2 se eta >= 65
  - +1 se bpm >= 100
  - +2 se sistolica >= 140
- priorita(punteggio: int) -> str:
  - 0..1: "Bassa"
  - 2..3: "Media"
  - 4..5: "Alta"

Vincoli:
- usa solo libreria standard
- aggiungi docstring brevi
- non cambiare firme delle funzioni

Prima di scrivere codice, proponi un piano minimo e chiedimi conferma.
```

### Prompt 2 (CSV in `src/io_pazienti.py`)

```text
Completa SOLO `src/io_pazienti.py`.
Implementa:
- carica_pazienti(percorso_csv: str | Path) -> list[dict]

CSV formato con intestazioni:
id,sesso,eta,peso_kg,altezza_m,bpm,sistolica

Vincoli:
- usa solo csv + pathlib (libreria standard)
- per righe invalide: non crashare, salta con messaggio su stderr

Prima di rispondere, dimmi come verifichiamo che il parsing funzioni.
```

### Prompt 3 (report in `main.py`)

```text
Completa `main.py` usando:
- src/io_pazienti.carica_pazienti
- src/metriche (calcolo BMI, categoria, punteggio e priorità)

Output richiesto (testo libero ma con questi concetti):
- stampa numero totale pazienti
- stampa conteggio per categoria BMI
- stampa conteggio per priorità
- stampa elenco Top 3 per priorità (ordinando per punteggio decrescente)

Vincoli:
- nessuna libreria esterna
- percorso CSV relativo a `dati/pazienti_esempio.csv` partendo da `__file__`

Prima di scrivere codice: chiedimi quali righe devo stampare e in che formato.
```

### Prompt 4 (debug)

```text
Sto eseguendo `python3 verify.py` e fallisce.
Ecco l'errore/traceback:
[INC0LLA OUTPUT]

1) dimmi la causa probabile
2) proponi il fix minimo (solo i file necessari)
3) dimmi come verificare con verify.py
```

---

## Nota didattica (importante)

Non serve “scrivere tutto perfetto”: l’obiettivo è usare l’agente come supporto operativo.
Tu però devi:
- leggere le modifiche,
- controllare output con `verify.py`,
- capire almeno la logica principale (BMI e priorità).

