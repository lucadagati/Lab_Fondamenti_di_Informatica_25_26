# Lab 7 — Database relazionali: SQLite e interfaccia MATLAB

Laboratorio su **modellazione dati tabellare**, **linguaggio SQL** e uso di **SQLite** (database file locale) da **MATLAB** tramite [Database Toolbox](https://www.mathworks.com/help/database/matlab-interface-to-sqlite.html). Collegamento ai temi del corso (LIS, dati clinici strutturati, integrazione con sistemi informativi) già introdotti nelle slide teoriche.

Repository del corso: [Lab_Fondamenti_di_Informatica_25_26](https://github.com/lucadagati/Lab_Fondamenti_di_Informatica_25_26).

---

## 1) Obiettivi

- Capire **schema relazionale** minimale (chiavi, vincoli `FOREIGN KEY`, tipi di dato SQLite).
- Scrivere interrogazioni **SELECT** con **WHERE**, **JOIN**, **GROUP BY**.
- Eseguire **INSERT** con `execute` e inserimenti tabellari con `sqlwrite`.
- Aprire un file **`.db`**, leggere risultati come `table` MATLAB e chiudere la connessione in modo ordinato.

---

## 2) Prerequisiti

1. **MATLAB** (release recente consigliata, es. R2022a o successiva per le API mostrate).
2. **[Database Toolbox](https://www.mathworks.com/help/database/index.html)** con interfaccia SQLite: funzioni `sqlite`, `sqlread`, `fetch`, `execute`, `sqlwrite`, `close` ([documentazione interfaccia SQLite](https://www.mathworks.com/help/database/matlab-interface-to-sqlite.html)).
3. (Opzionale) **sqlite3** da terminale per rigenerare il database dallo script SQL senza MATLAB — vedi sezione 7.

Verifica rapida in MATLAB:

```matlab
license('test', 'database_toolbox')
```

Se restituisce `0`, installare/abilitare il toolbox o usare il percorso alternativo con `sqlite3` + file CSV descritto in fondo al README.

---

## 3) Struttura della cartella

| Percorso | Contenuto |
|----------|-----------|
| `sql/lab07_schema.sql` | Script SQL portabile (stesso schema dei dati di esempio; utile con `sqlite3`) |
| `codice/lab07_create_fresh_database.m` | Funzione che **elimina e ricrea** `dati/lab07_biomed.db` (schema + insert) |
| `codice/init_lab07_database.m` | Punto di ingresso: chiama la funzione sopra e stampa il path del file creato |
| `codice/demo_connessione_lettura.m` | Demo eseguibile con un Run: ricrea il DB, `sqlread` + `fetch` con `JOIN` |
| `codice/demo_sqlwrite_inserimento.m` | Demo: ricrea il DB, `sqlwrite`, verifica con `fetch` |
| `esercizi/` | Script **completi** (nessun `TODO`): ogni Run ricrea il DB e svolge l’esercizio |
| `soluzioni/` | Stessa logica degli esercizi (`*_sol.m`), per confronto |
| `dati/` | Qui viene creato `lab07_biomed.db` (non versionato; vedi `.gitignore` del repo) |

Ogni script in `esercizi/`, `soluzioni/` e le `demo` aggiunge `codice` al path MATLAB e chiama `lab07_create_fresh_database(labDir)` prima delle query, così il file SQLite è sempre coerente con lo schema di laboratorio.

---

## 4) Come eseguire

1. Imposta la **Current Folder** su `07-matlab-sqlite-database` (radice del lab).
2. Esegui un qualsiasi file `.m` con il pulsante **Run** (oppure `run('esercizi/es01_apri_db_sqlread.m')`, ecc.).

Non serve un ordine obbligato: **ogni script ricrea da zero** `dati/lab07_biomed.db`, apre la connessione, esegue le operazioni e chiude.

Opzionale — solo creazione DB da prompt:

```matlab
run('codice/init_lab07_database.m')
```

---

## 5) Esercizi (script autonomi)

| File | Argomento |
|------|-----------|
| `esercizi/es01_apri_db_sqlread.m` | Connessione, `sqlread`, `close` |
| `esercizi/es02_fetch_where.m` | `fetch` e filtri `WHERE` |
| `esercizi/es03_join_groupby.m` | `JOIN` + `COUNT` / `GROUP BY` |
| `esercizi/es04_execute_insert.m` | `INSERT` con `execute` |
| `esercizi/es05_sqlwrite_bulk.m` | Inserimento multiplo con `sqlwrite` |

Le soluzioni in `soluzioni/*_sol.m` replicano lo stesso comportamento degli esercizi corrispondenti.

---

## 6) Riferimenti MATLAB (ufficiali)

- [MATLAB Interface to SQLite](https://www.mathworks.com/help/database/matlab-interface-to-sqlite.html)
- [`sqlite`](https://www.mathworks.com/help/database/ref/sqlite.html) — connessione a file `.db`
- [`sqlread`](https://www.mathworks.com/help/database/ref/sqlite.sqlread.html) — tabella → `table`
- [`fetch`](https://www.mathworks.com/help/database/ref/sqlite.fetch.html) — `SELECT` arbitrario → `table`
- [`execute`](https://www.mathworks.com/help/database/ref/sqlite.execute.html) — DDL/DML senza risultato tabellare
- [`sqlwrite`](https://www.mathworks.com/help/database/ref/sqlite.sqlwrite.html) — `table` MATLAB → righe SQL

---

## 7) Opzionale: creare il DB con `sqlite3` (terminale)

Su macOS/Linux (con [SQLite](https://www.sqlite.org/) installato):

```bash
cd 07-matlab-sqlite-database
bash script_init_db.sh
```

Poi in MATLAB puoi aprire lo stesso file con `sqlite(fullfile('dati','lab07_biomed.db'))`.

---

## 8) Senza Database Toolbox (solo concettuale / alternativa)

- Eseguire query con `sqlite3` e reindirizzare l’output su **CSV**, poi `readtable` in MATLAB (perde l’obiettivo “live” SQL in sessione, ma utile in ambienti con licenza limitata).
- In alternativa didattica: usare **MATLAB Online** o laboratorio con toolbox abilitato.

---

*Materiale didattico — Fondamenti di Informatica per Ingegneria Biomedica — Università degli Studi di Messina — A.A. 2025/26*
