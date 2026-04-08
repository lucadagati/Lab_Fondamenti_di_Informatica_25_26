# Lab 3 - MATLAB: strutture di controllo (if, for, while, switch)

**Fondamenti di Informatica per Ingegneria Biomedica** - UniMe - A.A. 2025/26 - **Luca D'Agati**

Obiettivo: imparare a usare le principali strutture di controllo in MATLAB attraverso esercizi guidati in stile:
1. testo dell'esercizio,
2. hint progressivi,
3. soluzione completa.

---

## 1) Setup rapido

## 1.1 Software

Puoi usare:
- **MATLAB** (MathWorks, licenza universitaria o trial),
- **GNU Octave** (alternativa libera, compatibile per la maggior parte degli script base).

### MATLAB (consigliato)
1. Installa MATLAB dal portale MathWorks del tuo ateneo.
2. Apri MATLAB.
3. Vai su **Home -> Set Path** oppure apri direttamente la cartella del laboratorio con **Current Folder**.

### GNU Octave (alternativa)
1. Installa Octave dal sito ufficiale.
2. Apri Octave.
3. Spostati nella cartella `03-matlab-strutture-controllo`.

---

## 1.2 Esecuzione file

Dalla Command Window (MATLAB o Octave), dentro questa cartella:

```matlab
cd esercizi
es01_bmi_classificazione
```

Per confrontare con la soluzione:

```matlab
cd ../soluzioni
es01_bmi_classificazione_sol
```

---

## 2) Struttura cartelle

- `esercizi/` -> file da completare con `TODO`
- `soluzioni/` -> soluzioni complete

---

## 3) Esercizi guidati

## Esercizio 1 - Classificazione BMI (if / elseif / else)

**File:** `esercizi/es01_bmi_classificazione.m`  
**Concetto:** selezione condizionale.

Richiesta:
- leggere peso e altezza,
- calcolare BMI = peso / altezza^2,
- stampare categoria:
  - `< 18.5` sottopeso
  - `< 25` normopeso
  - `< 30` sovrappeso
  - altrimenti obesita

**Hint 1:** usa `input()` per leggere i valori.  
**Hint 2:** salva il BMI in una variabile prima dei controlli.  
**Hint 3:** usa una catena `if / elseif / else` con soglie in ordine crescente.

Soluzione: `soluzioni/es01_bmi_classificazione_sol.m`

---

## Esercizio 2 - Media frequenza cardiaca (for)

**File:** `esercizi/es02_media_bpm_for.m`  
**Concetto:** ciclo `for`.

Richiesta:
- data una lista di BPM (battiti/min), calcolare media e massimo.

**Hint 1:** inizializza `somma = 0` e `massimo = -inf`.  
**Hint 2:** scorri il vettore con `for i = 1:length(vettore)`.  
**Hint 3:** aggiorna `massimo` quando trovi un valore più alto.

Soluzione: `soluzioni/es02_media_bpm_for_sol.m`

---

## Esercizio 3 - Validazione input (while)

**File:** `esercizi/es03_input_valido_while.m`  
**Concetto:** ciclo `while`.

Richiesta:
- chiedere un valore di saturazione SpO2 finché non è tra 0 e 100.

**Hint 1:** leggi un valore iniziale prima del `while`.  
**Hint 2:** condizione: `while spo2 < 0 || spo2 > 100`.  
**Hint 3:** nel ciclo richiedi nuovamente il dato.

Soluzione: `soluzioni/es03_input_valido_while_sol.m`

---

## Esercizio 4 - Codici di priorita (switch)

**File:** `esercizi/es04_priorita_switch.m`  
**Concetto:** `switch / case`.

Richiesta:
- leggere un codice intero di priorita (`1`, `2`, `3`),
- stampare:
  - `1 -> Alta`
  - `2 -> Media`
  - `3 -> Bassa`
  - altro -> codice non valido

**Hint 1:** usa `switch codice`.  
**Hint 2:** inserisci un `otherwise` per i casi non previsti.

Soluzione: `soluzioni/es04_priorita_switch_sol.m`

---

## Esercizio 5 - Conteggi su matrice (for annidati)

**File:** `esercizi/es05_conta_ipertensione.m`  
**Concetto:** cicli annidati.

Richiesta:
- data una matrice di pressioni sistoliche (righe = pazienti, colonne = misure),
- contare quante misure sono >= 140.

**Hint 1:** usa due `for` annidati su righe e colonne.  
**Hint 2:** aumenta un contatore quando il valore supera la soglia.

Soluzione: `soluzioni/es05_conta_ipertensione_sol.m`

---

## 4) Consegna studenti

Consegna:
1. i file completati in `esercizi/`,
2. uno screenshot o testo dell'output per almeno 3 esercizi,
3. breve nota (5-8 righe): quale struttura di controllo ti ha creato più difficolta e perche.

---

## 5) Facoltativo: usare AI agentica anche in MATLAB

Se usi un assistente AI:
- chiedi modifiche su **un solo file per volta**,
- fai validare sempre output e logica,
- non copiare codice senza capirlo.

Prompt utile:

```text
Completa il file MATLAB corrente rispettando i TODO.
Vincoli:
- usa solo le strutture richieste dall'esercizio
- non cambiare nomi variabili gia presenti
- aggiungi solo commenti essenziali
Prima di chiudere, indica come eseguire il file e quale output aspettarsi.
```

