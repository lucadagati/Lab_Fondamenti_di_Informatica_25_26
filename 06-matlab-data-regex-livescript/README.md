# Lab 6 - MATLAB: file formattati, RegEx/Patterns, Live Scripts e grafici

Questo laboratorio e progettato per chiarire **cosa fare** e **perche** in ogni esercizio.
Per ogni esercizio trovi:
- obiettivo,
- input (file di partenza),
- output atteso,
- passi consigliati.

---

## 1) Setup

1. Apri MATLAB.
2. Imposta `Current Folder` su `06-matlab-data-regex-livescript`.
3. Se manca il file Excel di partenza, genera `.xlsx` da CSV:

```matlab
run('dati/crea_xlsx_da_csv.m')
```

---

## 2) Struttura

- `dati/` -> file sorgente (`.csv`, `.xml`) + script per creare `.xlsx`
- `esercizi/` -> tracce con `TODO`
- `soluzioni/` -> implementazioni commentate
- `live_scripts/` -> spazio per `.mlx`

---

## 3) Esercizi (spiegati)

## Esercizio 1 - CSV: lettura, filtro, scrittura
- **File:** `esercizi/es01_csv_read_write.m`
- **Obiettivo:** leggere un CSV, filtrare i pazienti a rischio, salvare un nuovo CSV.
- **Input:** `dati/pazienti_lab6.csv`
- **Output:** `dati/pazienti_rischio.csv`
- **Passi:**
  1. `readtable` sul CSV.
  2. Crea condizione rischio (`bpm >= 100` OR `spo2 < 95` OR `sistolica >= 140`).
  3. Filtra tabella.
  4. `writetable` su file output.

## Esercizio 2 - XLSX: import/export con colonna derivata
- **File:** `esercizi/es02_xlsx_import_export.m`
- **Obiettivo:** leggere `.xlsx`, classificare pressione, scrivere nuovo `.xlsx`.
- **Input:** `dati/pazienti_lab6.xlsx`
- **Output:** `dati/pazienti_lab6_classificato.xlsx`
- **Passi:**
  1. `readtable` su file Excel.
  2. Crea colonna `classe_pressione` con regole (Normale / Pre-ipertensione / Ipertensione).
  3. Aggiungi colonna alla tabella.
  4. `writetable` su output.

## Esercizio 3 - XML: estrazione campi
- **File:** `esercizi/es03_xml_extract.m`
- **Obiettivo:** leggere XML e trasformarlo in tabella MATLAB.
- **Input:** `dati/pazienti_lab6.xml`
- **Output:** tabella con colonne `id,nome,eta,bpm,spo2,sistolica`
- **Passi:**
  1. `readstruct` sul file XML.
  2. Scorri i nodi `paziente`.
  3. Estrai campi testuali e numerici.
  4. Costruisci `table` e visualizzala.

## Esercizio 4 - RegEx: validazione codici
- **File:** `esercizi/es04_regex_codici.m`
- **Obiettivo:** validare codici paziente con formato `P` + 3 cifre.
- **Input:** lista codici di esempio.
- **Output:** stampa per ogni codice: valido/non valido.
- **Passi:**
  1. Definisci pattern regex (`^P\d{3}$`).
  2. Usa `regexp(..., 'once')`.
  3. Stampa esito con `fprintf`.

## Esercizio 5 - Patterns: parsing stringhe
- **File:** `esercizi/es05_patterns_string.m`
- **Obiettivo:** estrarre chiave numerica da stringhe tipo `bpm:101`.
- **Input:** vettore stringhe.
- **Output:** tabella con colonne `chiavi`, `valori`.
- **Passi:**
  1. Definisci pattern con `lettersPattern` e `digitsPattern`.
  2. Verifica formato con `matches`.
  3. Se valido, `split` su `:`.
  4. Accumula risultati e crea tabella.

## Esercizio 6 - Live Script: mini dashboard
- **File:** `esercizi/es06_live_script_dashboard.m`
- **Obiettivo:** convertire in `.mlx` e creare mini dashboard.
- **Input:** `dati/pazienti_lab6.csv`
- **Output:** Live Script con testo, tabella, 2 grafici, commento finale.
- **Passi:**
  1. Apri il file e salva come Live Script.
  2. Inserisci sezioni testuali esplicative.
  3. Aggiungi tabella dati.
  4. Aggiungi bar chart BPM e scatter SpO2 vs sistolica.

## Esercizio 7 - Grafici MATLAB
- **File:** `esercizi/es07_plot_vitali.m`
- **Obiettivo:** creare tre grafici con titoli e assi corretti.
- **Input:** `dati/pazienti_lab6.csv`
- **Output:** line plot, bar plot, scatter plot.
- **Passi:**
  1. Leggi tabella.
  2. Crea i tre grafici in figure separate.
  3. Aggiungi `title`, `xlabel`, `ylabel`.

## Esercizio 8 - Export grafici per Web
- **File:** `esercizi/es08_export_web_plot.m`
- **Obiettivo:** esportare una figura in formati web-friendly.
- **Input:** dati BPM e figura MATLAB.
- **Output:** `bpm_plot.png`, `bpm_plot.svg`, opzionale export HTML con Plotly.
- **Passi:**
  1. Crea figura.
  2. `saveas` in PNG e SVG.
  3. Se disponibile `fig2plotly`, esporta in HTML/offline.

---

## 4) Soluzioni

Ogni esercizio ha il corrispondente file `_sol.m` in `soluzioni/`.
Le soluzioni sono commentate per mostrare i passaggi principali.

---

## 5) Risorse ufficiali e approfondimenti

- **CSV/XLS/XML**
  - [Import and Export Data](https://www.mathworks.com/help/matlab/import_export.html)
  - [readtable](https://www.mathworks.com/help/matlab/ref/readtable.html)
  - [writetable](https://www.mathworks.com/help/matlab/ref/writetable.html)
  - [readstruct](https://www.mathworks.com/help/matlab/ref/readstruct.html)

- **Espressioni regolari**
  - [regexp](https://www.mathworks.com/help/matlab/ref/regexp.html)

- **Patterns**
  - [pattern (MathWorks)](https://www.mathworks.com/help/matlab/ref/pattern.html)
  - [Text Patterns](https://www.mathworks.com/help/matlab/matlab_prog/text-patterns.html)

- **Live Scripts**
  - [MATLAB Live Editor](https://www.mathworks.com/help/matlab/live-editor.html)
  - [Create Live Scripts](https://www.mathworks.com/help/matlab/matlab_prog/create-live-scripts.html)
  - [MATLAB Live Editor Examples](https://www.mathworks.com/help/matlab/live-editor-examples.html)

- **Grafici MATLAB**
  - [Creating Plots](https://www.mathworks.com/help/matlab/creating_plots.html)
  - [Plot Types](https://www.mathworks.com/help/matlab/creating_plots/types-of-matlab-plots.html)

- **Export Web (terze parti)**
  - [Plotly for MATLAB](https://plotly.com/matlab/)
