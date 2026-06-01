# Lab 2 - VS Code, prompting e coding in modalità agentica (fino a Jupyter)

**Fondamenti di Informatica per Ingegneria Biomedica** - UniMe - A.A. 2025/26 - **Luca D'Agati**  
**Repository del corso:** [lucadagati/Lab_Fondamenti_di_Informatica_25_26](https://github.com/lucadagati/Lab_Fondamenti_di_Informatica_25_26)

---

Questo è il documento **di riferimento** del Lab 2. Contiene:
1. installazione dei tool (quanto serve),
2. workflow agentico ripetibile,
3. esempi di **prompt** (copia/incolla),
4. come eseguire i file e come verificare.

Se usi un assistente in “modalità agentica”, l'idea è che tu gli dia un compito con vincoli e lui proponga modifiche e/o celle; poi **tu** verifichi eseguendo.

---

## 0) Cosa trovi in questa cartella

| Cartella/File | Uso nel laboratorio |
|---|---|
| `esercizi/` | Livello 0: script semplici a file singolo |
| `progetti_piccoli/` | Livelli 1-2: progetti piccoli e multi-file |
| `jupyter/` | Livelli 3-5: notebook (`.ipynb`) con dataset |
| `data/` | Dataset CSV usato dai notebook |
| `requirements-jupyter.txt` | Dipendenze Python opzionali per i notebook |

---

## 1) Setup step-by-step (installazione tool)

### 1.1 Controlla Python

Nel terminale integrato di VS Code/Cursor esegui:

```bash
python3 --version
```

Se `python3` non esiste, prova:

```bash
python --version
```

Per il resto useremo `python3` come comando.

### 1.2 (Consigliato) Crea un ambiente virtuale

Dentro `02-vscode-agentic-coding/`:

```bash
python3 -m venv .venv
source .venv/bin/activate
```

> Su Windows: `.venv\Scripts\activate`

### 1.3 Installa (solo) ciò che serve per Jupyter

Sempre dentro `02-vscode-agentic-coding/`:

```bash
pip install -r requirements-jupyter.txt
```

Se sei interessato solo ai livelli 0-2 (script), puoi anche saltare questo punto.

---

## 1.4 Installare Python (se non è presente) - per piattaforma

### macOS

1. Controlla se Python è già installato:
   ```bash
   python3 --version
   ```
2. Se non c’è, installa Python con Homebrew:
   ```bash
   brew install python
   ```
3. Verifica di nuovo:
   ```bash
   python3 --version
   ```

> Consiglio: se usi Homebrew, resta più facile mantenere comandi come `python3` e `pip`.

### Windows

1. Scarica e installa Python da https://www.python.org/downloads/ (scegli l’installer per Python 3).
2. Durante l’installazione, spunta l’opzione **“Add Python to PATH”**.
3. Verifica:
   ```bash
   python --version
   ```
   In alternativa puoi provare:
   ```bash
   py --version
   ```

### Linux (Debian/Ubuntu)

1. Installa Python e strumenti base:
   ```bash
   sudo apt update
   sudo apt install -y python3 python3-venv python3-pip
   ```
2. Verifica:
   ```bash
   python3 --version
   ```

---

## 1.5 Installare e avviare Jupyter (in locale)

Se hai creato il virtualenv (sezione 1.2) e hai installato:
```bash
pip install -r requirements-jupyter.txt
```

poi puoi avviare:

### JupyterLab (consigliato)
```bash
jupyter lab
```

### Jupyter Notebook (alternativa)
```bash
jupyter notebook
```

Se vuoi avviarlo senza aprire il browser (utile quando lavori su desktop/headless):
```bash
jupyter lab --no-browser
```

Per i laboratori di questo repo, i notebook si trovano in `jupyter/` e il dataset in `data/`.

---

## 1.6 Uso da tablet/iPad (due approcci)

### Approccio A (consigliato): iPad come “schermo/client”, Jupyter gira sul PC

Funziona bene perché non serve “VS Code su iPad”: basta il browser.

1. Avvia Jupyter **sul tuo PC** (che ha Python e dipendenze).
2. Nella finestra/terminal del PC, Jupyter ti stampa un URL (spesso con un token).
3. Apri quell’URL dal browser su iPad (Safari/Chrome).
4. Lavora sulle celle, esegui, e se salvi l’`.ipynb` sul PC i cambiamenti restano.

Nota: usa la stessa rete (Wi‑Fi) oppure la condivisione corretta se lavori in remoto. Non disattivare la sicurezza del token.

### Approccio B: app Jupyter su iPad (nota operativa)

Se vuoi eseguire notebook direttamente sull’iPad, serve un’app che:
- apra file `.ipynb`,
- supporti l’esecuzione di Python/Jupyter.

In quel caso:
1. apri/importa il notebook da `jupyter/`,
2. verifica che l’app possa eseguire un kernel Python,
3. installa/usa le librerie richieste (se supportato dall’app),
4. in caso di mancanza librerie, conviene tornare all’approccio A.

## 2) Aprire e usare l'ambiente in VS Code / Cursor

1. In VS Code/Cursor: `File -> Apri cartella` e scegli `02-vscode-agentic-coding/`.
2. Apri il terminale: ``Ctrl+` `` su Mac ``Cmd+` ``.
3. Installa/usa l'estensione **Jupyter** (se richiesta dal tuo editor).
4. Apri:
   - un file `.py` in `esercizi/` oppure `progetti_piccoli/`
   - oppure un notebook in `jupyter/`.

---

## 3) Workflow agentico “da seguire sempre” (prompting didattico)

Usa questo ciclo 4-step quando lavori con l'assistente. Anche se l'assistente è “agentic”, tu non devi saltare la verifica.

1. **Piano**: chiedi come risolvere (senza cambiare subito il codice).
2. **Implementa con vincoli**: chiedi modifiche mirate con regole chiare.
3. **Esegui e controlla**: prova con input semplici e controlla l'output.
4. **Debug/Correzione**: se fallisce, chiedi solo il fix minimo e fai riferimento all'errore osservato.

### 3.1 Prompt template (copia/incolla)

#### A) Piano + checklist

```text
Proponi un piano in 5 punti per completare l’esercizio richiesto.
Vincoli:
 - Usa solo libreria standard (se non diversamente richiesto).
 - Messaggi all'utente in italiano.
 - Crea soluzioni semplici, leggibili e verificabili.
Output atteso: descrivi esattamente cosa deve stampare/eseguire il programma.
Cosa verifico in terminale: indica un comando di test (con input) che produce l'output atteso.
Se manca info, fai 1 domanda sola.
Non scrivere codice finché non viene fornita la checklist finale del piano.
```

#### B) Implementazione con vincoli

```text
Ok, implementa seguendo il piano.
Regole:
- Modifica SOLO i file necessari per completare l'obiettivo.
- Messaggi all'utente in italiano.
- Aggiungi funzioni piccole e leggibili.
- Non introdurre dipendenze esterne.
Prima di rispondere, dimmi come verifico e quali input usare.
```

#### C) Debug assistito (quando l'esecuzione fallisce)

```text
L'esecuzione fallisce con un errore quando lancio il comando (oppure lo script).
Output di errore (copialo qui):
INC0LLA QUI L'OUTPUT DEL TERMINALE
Correggi con il fix minimo.
Non cambiare l'obiettivo.
Spiega in 2 righe cosa era sbagliato e come lo verifichi.
```

---

## 4) Percorso “da zero a hero” (livelli 0 -> 5)

Qui trovi, per ogni livello:
- cosa fare,
- prompt suggeriti,
- vincoli,
- come verificare.

### Livello 0 - script singolo file (`esercizi/`)

#### Esercizio 0.1 - Da specifica a programma

**File:** `esercizi/es01_scaffold.py`  
**Obiettivo:** chiedere quanti numeri inserire, leggerli e stampare media aritmetica, minimo e massimo.

**Prompt iniziale (copia/incolla):**

```text
Completa `esercizi/es01_scaffold.py`.
Obiettivo: chiedere all'utente n (intero positivo), leggere n numeri e stampare:
- media aritmetica
- minimo
- massimo
Vincoli:
- Solo Python 3, libreria standard
- Messaggi in italiano
Output di esempio da verificare:
Input: n=3, valori 10, 20, 30
Atteso: media 20.0, min 10, max 30
```

**Verifica (terminal):**

```bash
cd esercizi
printf "3\n10\n20\n30\n" | python3 es01_scaffold.py
```

#### Esercizio 0.2 - Refactoring (senza cambiare comportamento)

**File:** `esercizi/es02_refactor_messy.py`

**Prompt:**

```text
Rifattorizza `esercizi/es02_refactor_messy.py` per renderlo più leggibile:
- nomi più chiari
- funzioni piccole (se utili)
- commenti solo dove servono
Vincolo: non cambiare output con input equivalenti.
```

**Verifica:**

```bash
cd esercizi
printf "5\n2\n4\n6\n8\n10\n" | python3 es02_refactor_messy.py
```

#### Esercizio 0.3 - Debug assistito (bisestili)

**File:** `esercizi/es03_buggy.py`  
**Obiettivo:** correggere la regola anno bisestile.

**Prompt:**

```text
In `esercizi/es03_buggy.py` la funzione per l'anno bisestile è sbagliata.
Trova l'errore e correggi.
Regola corretta:
- bisestile se divisibile per 4
- eccetto se divisibile per 100
- salvo se divisibile per 400
Per favore:
- prima proponi la diagnosi (senza riscrivere tutto)
- poi fai il fix minimo
```

**Verifica:**

```bash
cd esercizi
printf "1900\n" | python3 es03_buggy.py
printf "2024\n" | python3 es03_buggy.py
printf "2000\n" | python3 es03_buggy.py
```

#### Esercizio 0.4 - Prompt e vincoli (nuovo file)

**Crea:** `esercizi/es04_mio.py`

**Richiesta:**
- funzione `conta_vocali(s: str) -> int` che conta le vocali italiane (a,e,i,o,u; maiuscole/minuscole),
- `if __name__ == "__main__":` che legge una riga e stampa il risultato,
- vincolo: niente regex, solo cicli e `if`.

**Prompt iniziale:**

```text
Crea `esercizi/es04_mio.py`.
Richiesta:
- funzione `conta_vocali(s: str) -> int` che conta le vocali italiane
- main: legge una riga da tastiera e stampa il numero di vocali
Vincoli:
- Solo libreria standard
- Non usare regex (niente re)
- Solo cicli e if
```

**Verifica rapida:**

```bash
cd esercizi
printf "Ciao Mondo\n" | python3 es04_mio.py
```

---

### Livelli 1-2 - progettini in `progetti_piccoli/`

#### Esercizio 1 - Convertitore valute

**File:** `progetti_piccoli/cambio_valuta.py`

**Prompt:**

```text
Completa `progetti_piccoli/cambio_valuta.py`.
Vincoli:
- Usa un tasso costante definito nello scheletro (in alto nel file)
- Implementa `eur_to_usd(eur)` e `usd_to_eur(usd)`
- Crea un menu a ciclo che permette conversioni ripetute
Vincolo extra: niente librerie esterne, solo Python standard.
```

**Verifica:**

```bash
python3 progetti_piccoli/cambio_valuta.py
```

#### Esercizio 2 - Quiz da file

**File:** `progetti_piccoli/quiz_da_file.py` + `progetti_piccoli/domande_quiz.txt`

**Prompt:**

```text
Completa `progetti_piccoli/quiz_da_file.py`:
- parsing del file `domande_quiz.txt` (formato: domanda | A | B | C | lettera_corretta)
- ignora righe che iniziano con '#'
- input utente case-insensitive per A/B/C
- conteggio punteggio e output finale
Vincolo: se una riga è invalida, gestiscila senza crash.
```

**Verifica:** esegui e controlla che con il file fornito il punteggio sia coerente.

---

### Livello 2 - progetto multi-file (`progetti_piccoli/spese_modulo/`)

Struttura:
- `utilita_io.py`: parsing e aggregazione (funzioni pure, niente `input()`).
- `main.py`: I/O (legge `spese_esempio.txt`, stampa risultati).

**Esecuzione:**

```bash
cd progetti_piccoli/spese_modulo
python3 main.py
```

**Prompt implementazione (da dare all'agente):**

```text
Completa `progetti_piccoli/spese_modulo/utilita_io.py`:
1) `parse_riga_spesa(linea)`:
   - formato: descrizione;importo
   - ritorna None se vuota o invalida
2) `totale_per_categoria(righe)`:
   - somma importi per descrizione
Vincoli:
- `utilita_io.py` NON deve usare input() né stampare a schermo.

Poi completa `main.py` per:
- leggere `spese_esempio.txt`
- stampare totale generale e totali per voce.

Verifica attesa:
- "Caffè" somma 2.50 + 1.80
- "Trasporto" somma 5.00 + 5.00
```

---

### Livelli 3-5 - Jupyter (`jupyter/`)

#### Regola d'oro
Esegui sempre dall'alto verso il basso e dopo modifiche usa:
- `Kernel -> Restart & Run All` (quando serve).

#### Notebook disponibili
- `jupyter/00_prima_notebook.ipynb` (Markdown vs codice, mini-esercizio)
- `jupyter/01_playground_numeri.ipynb` (calcoli in celle)
- `jupyter/02_dati_tabella.ipynb` (pandas + colonna derivata + grafico)
- `jupyter/03_mini_analisi_vendite.ipynb` (hero: domande, 2 figure, sintesi)

#### Prompt didattici per le celle

Se una cella ha `# TODO`, usa:

```text
Completa SOLO la parte con `# TODO` in questa cella.
Non cambiare il resto del notebook.
Se aggiungi una funzione, spiegala in una cella Markdown separata.
```

Se il notebook fallisce per percorsi file:

```text
Il notebook non trova `../data/vendite_esempio.csv`.
Spiega da dove parte il working directory quando eseguo il notebook in VS Code e dimmi come correggere il percorso relativo.
```

---

## 5) Lab extra biomedico: mini-triage da dati pazienti (con prompt)

Se hai finito i livelli 0–5 (o vuoi un “progettino vero” legato al settore biomedico), fai questo lab aggiuntivo.

L’obiettivo è costruire un piccolo programma che:
- carica un file CSV con dati fittizi di pazienti,
- calcola BMI (Body Mass Index),
- assegna una categoria di priorità basata su età, frequenza cardiaca e pressione sistolica,
- stampa un report leggibile.

Trovi i file e i prompt pronti in:
`02-vscode-agentic-coding/biomedico_progettino_triage/`

In sintesi:
1. Apri il folder in VS Code/Cursor.
2. Usa i prompt presenti nel suo `README.md` per far implementare all’agente funzioni specifiche.
3. Completa i TODO e verifica con lo script `verify.py`.

---

## 6) Consegna (studenti)

Consegna un breve testo (PDF o markdown) con:
1. ambiente usato (editor + estensioni, versione Python),
2. quali parti hai completato (livelli 0–5 e/o lab extra biomedico),
3. per ogni parte: 1 prompt esemplare + 1 difficoltà + come l'hai risolta,
4. un esempio in cui l’AI ha suggerito qualcosa di sbagliato/rischioso oppure come l’hai verificato,
5. riflessione (max 10-15 righe) su quando l’agente aiuta e quando ostacola.

---

## 6) Regole di laboratorio (etichetta e sicurezza)

- Non incollare password, token o dati personali nei prompt.
- Non accettare comandi di terminale se non capisci cosa fanno.
- Tratta il codice generato come bozza: correttezza e comprensione restano tue responsabilità.

---

*Materiale didattico - Fondamenti di Informatica per Ingegneria Biomedica - Università degli Studi di Messina - A.A. 2025/26 - Docente: Luca D'Agati*

