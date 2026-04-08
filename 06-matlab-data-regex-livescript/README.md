# Lab 6 - MATLAB: dati formattati, RegEx/Patterns, Live Scripts e grafici

Laboratorio su:
- lettura/scrittura di file formattati (CSV, XLSX, XML),
- espressioni regolari e patterns,
- Live Scripts,
- visualizzazione ed esportazione grafici.

---

## 1) Setup

1. Apri MATLAB.
2. Imposta `Current Folder` su `06-matlab-data-regex-livescript`.
3. Se serve il file Excel di partenza, esegui:

```matlab
run('dati/crea_xlsx_da_csv.m')
```

---

## 2) Struttura

- `dati/` -> dataset di partenza (`.csv`, `.xml`) e utility per `.xlsx`
- `esercizi/` -> file da completare (`TODO`)
- `soluzioni/` -> soluzioni complete
- `live_scripts/` -> spazio per i `.mlx` creati in aula

---

## 3) Esercizi

1. `es01_csv_read_write.m`  
   CSV: leggi tabella, filtra righe, riscrivi CSV.

2. `es02_xlsx_import_export.m`  
   XLSX: importa, aggiungi colonna classificata, esporta.

3. `es03_xml_extract.m`  
   XML: estrai campi e costruisci tabella MATLAB.

4. `es04_regex_codici.m`  
   RegEx: valida codici con pattern formale.

5. `es05_patterns_string.m`  
   Patterns: estrai chiave e valore da stringhe strutturate.

6. `es06_live_script_dashboard.m`  
   Live Script: dashboard con testo + tabella + grafici.

7. `es07_plot_vitali.m`  
   Grafici MATLAB: line, bar, scatter.

8. `es08_export_web_plot.m`  
   Export grafico su file web-friendly (`.png`, `.svg`), opzionale Plotly.

---

## 4) Soluzioni

Ogni esercizio ha il corrispondente file `_sol.m` in `soluzioni/`.

---

## 5) Risorse ufficiali e approfondimenti

- Documentazione MathWorks: lettura/scrittura documenti formattati (CSV/XLS/XML)  
  - [Import and Export Data](https://www.mathworks.com/help/matlab/import_export.html)  
  - [readtable](https://www.mathworks.com/help/matlab/ref/readtable.html)  
  - [writetable](https://www.mathworks.com/help/matlab/ref/writetable.html)  
  - [readstruct](https://www.mathworks.com/help/matlab/ref/readstruct.html)

- Documentazione MathWorks: espressioni regolari  
  - [regexp](https://www.mathworks.com/help/matlab/ref/regexp.html)

- Approfondimento: Patterns  
  - [pattern (MathWorks)](https://www.mathworks.com/help/matlab/ref/pattern.html)  
  - [Text Patterns](https://www.mathworks.com/help/matlab/matlab_prog/text-patterns.html)

- Documentazione MathWorks: sviluppo interfacce utente e Live Scripts  
  - [MATLAB Live Editor](https://www.mathworks.com/help/matlab/live-editor.html)  
  - [Create Live Scripts](https://www.mathworks.com/help/matlab/matlab_prog/create-live-scripts.html)

- Esempi / galleria Live Script  
  - [MATLAB Live Editor Examples](https://www.mathworks.com/help/matlab/live-editor-examples.html)

- Documentazione MathWorks: rappresentazione grafica  
  - [Creating Plots](https://www.mathworks.com/help/matlab/creating_plots.html)  
  - [Plot Types](https://www.mathworks.com/help/matlab/creating_plots/types-of-matlab-plots.html)

- Approfondimento terze parti per export web  
  - [Plotly for MATLAB](https://plotly.com/matlab/)

