# Laboratori – Fondamenti di Informatica (Ingegneria Biomedica)

**Fondamenti di Informatica per Ingegneria Biomedica**  
Università degli Studi di Messina – Anno accademico 2025/26  

**Docente:** Luca D'Agati  

---

Questo repository raccoglie i **laboratori** del corso. Ogni laboratorio è in una cartella numerata; all’interno trovi la guida, l’**installazione dei tool** (quando serve) e le istruzioni passo-passo. Il **Lab 1** è dedicato a crittografia e sicurezza informatica; il **Lab 2** a VS Code, coding assistito in modalità agentica e un percorso fino a **Jupyter** con Python; il **Lab 3** a **MATLAB** e strutture di controllo con esercizi, hint e soluzioni; il **Lab 4** a Python in notebook Jupyter, riusando l’ambiente predisposto nel Lab 2; il **Lab 5** a MATLAB bioinformatica, HL7 e NCBI; il **Lab 6** a MATLAB su file formattati, RegEx/Patterns, Live Scripts e grafici; il **Lab 7** a database relazionali con **SQLite** e interfaccia **MATLAB** (Database Toolbox).

---

## Struttura del repository

```mermaid
flowchart TD
    ROOT[Lab_Biomed]
    ROOT --> README[README.md - presentazione]
    ROOT --> LAB1[01-crittografia-chiavi]
    ROOT --> LAB2[02-vscode-agentic-coding]
    ROOT --> LAB3[03-matlab-strutture-controllo]
    ROOT --> LAB4[04-python-jupyter-analisi-biomedica]
    ROOT --> LAB5[05-matlab-bioinfo-hl7-ncbi]
    ROOT --> LAB6[06-matlab-data-regex-livescript]
    ROOT --> LAB7[07-matlab-sqlite-database]

    LAB1 --> L1README[README.md - guida e installazione]
    LAB1 --> L1PWD[passwords.txt]
    LAB1 --> L1SCRIPT[brute_force_demo.sh]
    LAB1 --> L1SOL[soluzioni/]

    LAB2 --> L2README[README.md - guida Lab 2]
    LAB2 --> L2DOC[laboratorio_vscode_agentic.md]
    LAB3 --> L3README[README.md - guida Lab 3]
    LAB3 --> L3EX[esercizi/]
    LAB3 --> L3SOL[soluzioni/]
    LAB4 --> L4README[README.md - guida Lab 4]
    LAB4 --> L4DATA[data/]
    LAB4 --> L4NB[jupyter/]
    LAB5 --> L5README[README.md - guida Lab 5]
    LAB5 --> L5CODE[codice/L15 + codice/L16]
    LAB6 --> L6README[README.md - guida Lab 6]
    LAB6 --> L6EX[esercizi/]
    LAB6 --> L6SOL[soluzioni/]
    LAB7 --> L7README[README.md - guida Lab 7]
    LAB7 --> L7SQL[sql/]
    LAB7 --> L7CODE[codice/]
    LAB7 --> L7EX[esercizi/]
    LAB7 --> L7SOL[soluzioni/]
```

```
Lab_Biomed/
├── README.md                         ← Sei qui: presentazione
├── 01-crittografia-chiavi/           ← Lab 1: chiavi, AES, RSA, firma, crittoanalisi
│   ├── README.md
│   ├── passwords.txt
│   ├── brute_force_demo.sh
│   └── soluzioni/
├── 02-vscode-agentic-coding/         ← Lab 2: VS Code, AI agentica, Python, Jupyter
    ├── README.md
    ├── laboratorio_vscode_agentic.md
    ├── esercizi/
    ├── progetti_piccoli/
    ├── jupyter/
    └── data/
├── 03-matlab-strutture-controllo/     ← Lab 3: MATLAB, if/for/while/switch
    ├── README.md
    ├── esercizi/
    └── soluzioni/
├── 04-python-jupyter-analisi-biomedica/  ← Lab 4: Python + Jupyter su dataset biomedico
    ├── README.md
    ├── data/
    ├── esercizi/
    ├── soluzioni/
    └── jupyter/
├── 05-matlab-bioinfo-hl7-ncbi/        ← Lab 5: MATLAB bioinformatica, HL7, NCBI, codice completo da slide
│   ├── README.md
│   └── codice/
│       ├── L15/
│       └── L16/
├── 06-matlab-data-regex-livescript/ ← Lab 6: MATLAB dati, regex, live script, grafici
│   ├── README.md
│   ├── dati/
│   ├── esercizi/
│   ├── soluzioni/
│   └── live_scripts/
└── 07-matlab-sqlite-database/         ← Lab 7: SQLite, SQL, Database Toolbox da MATLAB
    ├── README.md
    ├── sql/
    ├── dati/
    ├── codice/
    ├── esercizi/
    ├── soluzioni/
    └── script_init_db.sh
```

---

## Elenco laboratori

| Lab | Cartella | Argomento |
|-----|----------|-----------|
| 1 | [01-crittografia-chiavi](01-crittografia-chiavi/README.md) | Chiavi, crittografia simmetrica (AES) e asimmetrica (RSA), firma digitale, crittoanalisi e brute force |
| 2 | [02-vscode-agentic-coding](02-vscode-agentic-coding/README.md) | VS Code (o equivalente), assistenti in modalità agentica, Python da script a notebook Jupyter |
| 3 | [03-matlab-strutture-controllo](03-matlab-strutture-controllo/README.md) | MATLAB: script con strutture di controllo (`if`, `for`, `while`, `switch`) in formato esercizio + hint + soluzione |
| 4 | [04-python-jupyter-analisi-biomedica](04-python-jupyter-analisi-biomedica/README.md) | Python + Jupyter per analisi di parametri vitali, riusando l’ambiente del Lab 2 |
| 5 | [05-matlab-bioinfo-hl7-ncbi](05-matlab-bioinfo-hl7-ncbi/README.md) | MATLAB: bioinformatica, HL7, NCBI; codice di riferimento dalle slide L15/L16 |
| 6 | [06-matlab-data-regex-livescript](06-matlab-data-regex-livescript/README.md) | MATLAB: CSV/XLS/XML, RegEx/Patterns, Live Scripts, grafici ed export |
| 7 | [07-matlab-sqlite-database](07-matlab-sqlite-database/README.md) | SQLite e SQL; accesso da MATLAB (`sqlite`, `fetch`, `sqlread`, `execute`, `sqlwrite`) |
| 8, … | *(in arrivo)* | Saranno aggiunti nella stessa struttura (es. `08-nome-lab/`) |

Apri la cartella del laboratorio assegnato e segui il **README** al suo interno (installazione dei tool e svolgimento).

---

*Materiale didattico – Fondamenti di Informatica per Ingegneria Biomedica – Università degli Studi di Messina – A.A. 2025/26 – Docente: Luca D'Agati*
