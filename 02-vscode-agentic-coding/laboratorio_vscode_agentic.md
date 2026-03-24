# Laboratorio — VS Code e coding in modalità agentica

**Fondamenti di Informatica per Ingegneria Biomedica** – UniMe – A.A. 2025/26 – **Luca D’Agati**  
**Repository del corso:** [Lab_Fondamenti_di_Informatica_25_26](https://github.com/lucadagati/Lab_Fondamenti_di_Informatica_25_26) (questo materiale è nella cartella `02-vscode-agentic-coding/`).

**Corso:** Fondamenti di informatica  
**Durata indicativa:** da **2 ore** (solo livelli 0–1) fino a **8–12 ore** (percorso completo fino al livello 5, anche in più sessioni).  
**Prerequisiti:** account su un editor con assistente AI (vedi sotto), nozioni base di file, cartelle e terminale; per i livelli 4–5, comandi `pip` e (opzionale) ambiente virtuale.

---

## Indice rapido

| Sezione | Contenuto |
|---------|-----------|
| §1–3 | Obiettivi, strumenti (VS Code / agent), concetti chiave |
| **§4** | **Percorso da zero a hero** (tabella livelli) |
| **§5** | **Jupyter** — installazione e uso con agent |
| §6–10 | Esercizi per livello (script + notebook) |
| §11 | Consegna e regole |

---

## 1. Obiettivi del laboratorio

Al termine dovresti essere in grado di:

1. **Distinguere** completamento automatico, chat e modalità **agentica** (l’assistente che propone modifiche su più file e comandi nel tempo).
2. **Formulare richieste** chiare, con contesto e vincoli (linguaggio, librerie, stile).
3. **Verificare** sempre il codice generato (lettura, esecuzione, test mentali) prima di considerarlo “corretto”.
4. **Passare gradualmente** da script in un solo file a **progetti multi-file** e a **notebook Jupyter** per esplorazione dati e piccole analisi.
5. **Riflettere** su limiti, errori possibili e responsabilità (il codice è sempre tuo da controllare).

---

## 2. Strumenti: VS Code e “modalità agentica”

**Visual Studio Code** è l’editor di riferimento. La *modalità agentica* dipende dall’estensione o dal prodotto:

| Ambiente | Idea pratica |
|----------|----------------|
| **Cursor** (basato su VS Code) | **Agent** / **Composer**: l’assistente può leggere il progetto, modificare file, suggerire comandi nel terminale, in più passaggi. |
| **VS Code + GitHub Copilot** | **Copilot Chat** e funzioni evolute (editing su più file): comportamento simile a un “agente” quando orchestra più azioni. |
| **Notebook** | Stesso editor: estensione **Jupyter** (Microsoft) o apertura `.ipynb` nativa; l’agente può modificare **celle** singole o intere sezione. |

**Per questo laboratorio** usa **Cursor** oppure **VS Code con Copilot** (o quanto indicato dal docente). L’importante è una modalità in cui l’assistente **non si limita a una risposta in chat**, ma può **proporre modifiche concrete** al codice e al progetto.

### 2.1 Setup minimo (script)

1. Installa l’editor scelto e accedi con l’account richiesto.
2. Apri la cartella del laboratorio: **File → Apri cartella** → la cartella `02-vscode-agentic-coding/` (se hai clonato tutto il repo, è `Lab_Fondamenti_di_Informatica_25_26/02-vscode-agentic-coding`).
3. Apri il **terminale integrato** (`Ctrl+`` ` o `Cmd+`` ` su Mac).
4. Individua Chat / Agent / Composer nel tuo strumento.

---

## 3. Concetti chiave (da ricordare)

- **Contesto:** l’assistente “vede” ciò che gli mostri (file aperti, `@file`, cartella). Più contesto è pertinente, migliori spesso le risposte.
- **Prompt:** istruzione in linguaggio naturale; conviene essere **specifici** (linguaggio, input/output, vincoli).
- **Iterazione:** raramente il primo risultato è perfetto; è normale correggere: “aggiungi controllo errori”, “usa solo libreria standard”, “rinomina in italiano”.
- **Verifica umana:** l’AI può sbagliare (logica, sicurezza, stile). **Tu** consegni il compito: devi capire e approvare ogni modifica importante.
- **Notebook:** ogni cella è un piccolo programma; conviene **eseguire dall’alto verso il basso** dopo modifiche (kernel → Restart & Run All quando serve).

---

## 4. Percorso “da zero a hero”

Obiettivo: partire da **microlavori** in cui l’agente è quasi un “copilota su un file”, arrivare a un **mini-report dati** in Jupyter (progetto **medio** per fondamenti: pandas + grafici + testo).

### 4.1 Mappa dei livelli

| Livello | Focus | Dove nel repo | Complessità | Ruolo dell’agente |
|--------|--------|---------------|-------------|-------------------|
| **0** | Un file, I/O, logica base | `esercizi/` | Molto bassa | Completare, rifattorizzare, debuggare |
| **1** | “Progettini” autonomi (menu, file di testo) | `progetti_piccoli/` | Bassa | Implementare scheletri, parser, test veloci |
| **2** | Più moduli, responsabilità separate | `progetti_piccoli/spese_modulo/` | Media-bassa | Architettura a file, import, `main` snello |
| **3** | Jupyter: celle, Markdown, flusso | `jupyter/00`, `01` | Media (nuova UI) | Spiegare output, spezzare idee in celle |
| **4** | Tabelle CSV, pandas, primo grafico | `jupyter/02`, `data/` | Media | Query/groupby, matplotlib con vincoli |
| **5** | Narrativa analitica: domande + figure + sintesi | `jupyter/03` | Medio-alta (per il corso) | Revisione testo, refactoring celle, coerenza |

### 4.2 Suggerimento di tempo (indicativo)

- **Sprint “zero → base”:** livelli 0–1 (≈ 2–3 h).
- **Sprint “script → progetto”:** + livello 2 (≈ +1–2 h).
- **Sprint “hero Jupyter”:** livelli 3–5 (≈ +4–6 h, anche diviso in 2 laboratori).

Non è obbligatorio fare tutto: il docente può assegnare un sottoinsieme per CFU o per prerequisiti della classe.

---

## 5. Jupyter — installazione e uso con l’agente

### 5.1 Dipendenze

Dalla root di questa cartella di laboratorio — `02-vscode-agentic-coding/` (meglio dentro un **virtualenv**):

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements-jupyter.txt
```

Su Windows: `.venv\Scripts\activate` al posto di `source .venv/bin/activate`.

### 5.2 Aprire i notebook

- **VS Code / Cursor:** apri il file `.ipynb` in `jupyter/`; seleziona l’interprete Python del venv quando richiesto.
- **Jupyter Lab:** `jupyter lab` dalla root, poi naviga in `jupyter/`.

### 5.3 Prompt utili con l’agente (notebook)

- *“Non cambiare la prima cella; completa solo le celle con `# TODO` in questo notebook.”*
- *“Dopo ogni blocco di codice, aggiungi una cella Markdown che spiega in due frasi cosa mostra il grafico.”*
- *“Usa percorsi relativi a `jupyter/` verso `../data/vendite_esempio.csv` come negli esempi.”*

---

## 6. Livello 0 — Esercizi su singolo file (`esercizi/`)

### Parte guidata (≈ 15 min)

1. Chiedi all’assistente: *“Spiega in 5 righe cosa fa `esercizi/es01_scaffold.py` e cosa manca.”*
2. Osserva se propone **patch** ai file; leggi prima di accettare.

### Esercizio 0.1 — Da specifica a programma

**File:** `esercizi/es01_scaffold.py`  

- Chiedi quanti numeri, leggili, stampa **media**, **min**, **max**.  
- Vincoli prompt: Python 3, solo libreria standard, messaggi in italiano.  
- **Verifica:** `3` numeri `10`, `20`, `30` → media `20.0`, min `10`, max `30`.

### Esercizio 0.2 — Refactoring

**File:** `esercizi/es02_refactor_messy.py` — rifattorizza senza cambiare output.  
**Verifica:** input `5` e `2 4 6 8 10` → somma `30`.

### Esercizio 0.3 — Debug

**File:** `esercizi/es03_buggy.py` — anni bisestili.  
**Verifica:** 2024 sì; 1900 no; 2000 sì.

### Esercizio 0.4 — Prompt e vincoli

Crea `esercizi/es04_mio.py`: funzione `conta_vocali`, main da tastiera; poi secondo prompt: niente regex.

---

## 7. Livello 1 — Progettini semplici (`progetti_piccoli/`)

### 7.1 Convertitore valute

**File:** `progetti_piccoli/cambio_valuta.py`  

Implementa `eur_to_usd`, `usd_to_eur`, menu a ciclo. Usa un **tasso costante** in cima al file (es. 1 EUR = 1.08 USD) e chiedi nell’esercizio di provare almeno due conversioni a mano.

### 7.2 Quiz da file

**File:** `progetti_piccoli/quiz_da_file.py` + `domande_quiz.txt`  

Parser del formato `domanda | A | B | C | lettera`; ignora righe `#`.  
**Verifica:** con il file fornito, tutte e tre le domande hanno risposta nota; controlla punteggio 3/3 con input corretti.

---

## 8. Livello 2 — Progetto multi-file (`progetti_piccoli/spese_modulo/`)

- `utilita_io.py` — funzioni pure (parsing `descrizione;importo`, aggregazione).
- `main.py` — legge `spese_esempio.txt`, stampa totale e totali per voce.

**Esecuzione:** dalla cartella `spese_modulo/`:

```bash
cd progetti_piccoli/spese_modulo
python3 main.py
```

**Verifica rapida:** dai dati di esempio, “Caffè” deve sommare `2.50 + 1.80`, “Trasporto” `5.00 + 5.00`, ecc.

Chiedi all’agente di **non** mettere `input()` in `utilita_io.py` (separa I/O da logica).

---

## 9. Livelli 3–5 — Jupyter (`jupyter/`)

| Notebook | Scopo |
|----------|--------|
| `00_prima_notebook.ipynb` | Prima esecuzione, Markdown vs codice, mini-esercizio input |
| `01_playground_numeri.ipynb` | Spezzare calcoli in celle, media e filtri |
| `02_dati_tabella.ipynb` | CSV, colonna derivata, groupby, un grafico a barre |
| `03_mini_analisi_vendite.ipynb` | **Hero:** tre domande di business, due figure, sintesi critica |

**Dataset:** `data/vendite_esempio.csv` (percorsi `../data/...` dai notebook in `jupyter/`).

---

## 10. Consegna (per il docente) — versione estesa

Consegna un documento breve (PDF o testo) con:

1. **Ambiente** (Cursor / VS Code + estensioni; versione Python).
2. **Livelli completati** (0–5) e tempo approssimativo.
3. Per **ogni livello affrontato**: 1 prompt esemplare, una difficoltà, come l’hai risolta.
4. **Esempio di errore dell’AI** (o “non osservato” + come avresti verificato).
5. **Riflessione** (10–15 righe): quando l’agente accelera l’apprendimento e quando ostacola (es. compiti d’esame senza comprensione).

Opzionale: esporta `03_mini_analisi_vendite.ipynb` come **HTML** o PDF (dal menu Jupyter / VS Code) e allega.

---

## 11. Regole di laboratorio (etichetta e sicurezza)

- Non incollare **password**, token o dati personali nei prompt.
- Non eseguire comandi suggeriti dall’AI se **non capisci** cosa fanno.
- Il codice generato è **bozza**: correttezza e comprensione restano tue responsabilità.

### Riferimenti rapidi (terminale, script)

```bash
cd esercizi
python3 es01_scaffold.py
```

Su Windows, se `python3` non esiste, prova `python`.

---

*Adattare nomi prodotti e versioni a quanto usato in aula.*
