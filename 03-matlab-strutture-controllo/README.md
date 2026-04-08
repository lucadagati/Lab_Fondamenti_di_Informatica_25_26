# Lab 3 - MATLAB: strutture di controllo

**Fondamenti di Informatica per Ingegneria Biomedica** - UniMe - A.A. 2025/26

Questo laboratorio e pronto per gli studenti: ogni esercizio include:
- consegna,
- hint,
- diagramma di flusso (Mermaid),
- file soluzione.

---

## 1) Setup MATLAB

1. Installa MATLAB (licenza universitaria o trial).
2. Apri MATLAB.
3. Imposta `Current Folder` su `03-matlab-strutture-controllo`.

---

## 2) Come eseguire i file

Esempio (esercizio 1):

```matlab
cd esercizi
es01_bmi_classificazione
```

Per vedere la soluzione:

```matlab
cd ../soluzioni
es01_bmi_classificazione_sol
```

---

## 3) Struttura cartelle

- `esercizi/` -> file con `TODO`
- `soluzioni/` -> soluzioni complete

---

## 4) Esercizi

## Esercizio 1 - Classificazione BMI (`if/elseif/else`)

- **File:** `esercizi/es01_bmi_classificazione.m`
- **Consegna:** leggere peso/altezza, calcolare BMI e stampare categoria.
- **Hint:** soglie in ordine (`18.5`, `25`, `30`) con `if/elseif/else`.
- **Soluzione:** `soluzioni/es01_bmi_classificazione_sol.m`

```mermaid
flowchart TD
    A[Leggi peso e altezza] --> B[Calcola BMI]
    B --> C{BMI < 18.5?}
    C -- Si --> D[Stampa Sottopeso]
    C -- No --> E{BMI < 25?}
    E -- Si --> F[Stampa Normopeso]
    E -- No --> G{BMI < 30?}
    G -- Si --> H[Stampa Sovrappeso]
    G -- No --> I[Stampa Obesita]
```

---

## Esercizio 2 - Media e massimo BPM (`for`)

- **File:** `esercizi/es02_media_bpm_for.m`
- **Consegna:** su un vettore BPM, calcolare media e massimo.
- **Hint:** usa `somma`, `massimo`, ciclo `for`.
- **Soluzione:** `soluzioni/es02_media_bpm_for_sol.m`

```mermaid
flowchart TD
    A[Inizializza somma e massimo] --> B[for i da 1 a N]
    B --> C[Leggi bpm(i)]
    C --> D[Somma = Somma + bpm(i)]
    D --> E{bpm(i) > massimo?}
    E -- Si --> F[Aggiorna massimo]
    E -- No --> G[Continua]
    F --> G
    G --> H[Fine ciclo]
    H --> I[Calcola media]
    I --> J[Stampa media e massimo]
```

---

## Esercizio 3 - Validazione SpO2 (`while`)

- **File:** `esercizi/es03_input_valido_while.m`
- **Consegna:** accettare input solo tra `0` e `100`.
- **Hint:** `while spo2 < 0 || spo2 > 100`.
- **Soluzione:** `soluzioni/es03_input_valido_while_sol.m`

```mermaid
flowchart TD
    A[Leggi SpO2] --> B{SpO2 valida 0..100?}
    B -- No --> C[Mostra errore]
    C --> D[Leggi nuovo valore]
    D --> B
    B -- Si --> E[Stampa valore accettato]
```

---

## Esercizio 4 - Codice priorita (`switch`)

- **File:** `esercizi/es04_priorita_switch.m`
- **Consegna:** mappare `1/2/3` in `Alta/Media/Bassa`.
- **Hint:** usa `switch` e `otherwise`.
- **Soluzione:** `soluzioni/es04_priorita_switch_sol.m`

```mermaid
flowchart TD
    A[Leggi codice] --> B{switch codice}
    B -->|1| C[Stampa Alta]
    B -->|2| D[Stampa Media]
    B -->|3| E[Stampa Bassa]
    B -->|altro| F[Stampa codice non valido]
```

---

## Esercizio 5 - Conteggio ipertensione (for annidati)

- **File:** `esercizi/es05_conta_ipertensione.m`
- **Consegna:** in una matrice, contare i valori `>= 140`.
- **Hint:** due cicli `for` e contatore.
- **Soluzione:** `soluzioni/es05_conta_ipertensione_sol.m`

```mermaid
flowchart TD
    A[contatore = 0] --> B[for ogni riga]
    B --> C[for ogni colonna]
    C --> D{valore >= 140?}
    D -- Si --> E[contatore = contatore + 1]
    D -- No --> F[continua]
    E --> F
    F --> G[prossimo elemento]
    G --> H[Fine cicli]
    H --> I[Stampa contatore]
```

---

## Esercizio 6 - Istogramma categorie BMI

- **File:** `esercizi/es06_istogramma_bmi.m`
- **Consegna:** contare quanti BMI in ogni categoria.
- **Hint:** 4 contatori e `if/elseif/else` nel `for`.
- **Soluzione:** `soluzioni/es06_istogramma_bmi_sol.m`

```mermaid
flowchart TD
    A[Inizializza 4 contatori] --> B[for su tutti i BMI]
    B --> C{BMI < 18.5?}
    C -- Si --> D[Incrementa sottopeso]
    C -- No --> E{BMI < 25?}
    E -- Si --> F[Incrementa normopeso]
    E -- No --> G{BMI < 30?}
    G -- Si --> H[Incrementa sovrappeso]
    G -- No --> I[Incrementa obesita]
    D --> J[Elemento successivo]
    F --> J
    H --> J
    I --> J
    J --> K[Stampa i 4 conteggi]
```

---

## Esercizio 7 - Primo tratto stabile FC

- **File:** `esercizi/es07_stabilita_fc.m`
- **Consegna:** trovare il primo indice con 3 valori consecutivi in range `60..100`.
- **Hint:** `while` con indice e `break` quando trovi la prima tripla valida.
- **Soluzione:** `soluzioni/es07_stabilita_fc_sol.m`

```mermaid
flowchart TD
    A[i=1, indice=-1] --> B{i <= N-2?}
    B -- No --> C[Stampa indice]
    B -- Si --> D{fc(i),fc(i+1),fc(i+2) nel range?}
    D -- Si --> E[indice = i]
    E --> C
    D -- No --> F[i = i + 1]
    F --> B
```

---

## Esercizio 8 - Alert pressione per paziente

- **File:** `esercizi/es08_alert_pressione.m`
- **Consegna:** per ogni paziente contare le misure `>= 140` e stampare livello alert.
- **Hint:** annida due `for`; poi mappa anomalie in `Basso/Medio/Alto`.
- **Soluzione:** `soluzioni/es08_alert_pressione_sol.m`

```mermaid
flowchart TD
    A[for ogni paziente] --> B[anomalie = 0]
    B --> C[for ogni misura]
    C --> D{misura >= 140?}
    D -- Si --> E[anomalie++]
    D -- No --> F[continua]
    E --> F
    F --> G[Fine misure paziente]
    G --> H{anomalie = 0 / 1 / >=2}
    H --> I[Stampa alert]
    I --> J[Paziente successivo]
```

---

## Esercizio 9 - Picchi ECG semplificati

- **File:** `esercizi/es09_picchi_ecg.m`
- **Consegna:** contare picchi locali sopra soglia.
- **Hint:** ciclo da `2` a `N-1`; confronta con vicini.
- **Soluzione:** `soluzioni/es09_picchi_ecg_sol.m`

```mermaid
flowchart TD
    A[n_picchi = 0] --> B[for i = 2 .. N-1]
    B --> C{x(i) > x(i-1) e x(i) > x(i+1)?}
    C -- No --> D[continua]
    C -- Si --> E{x(i) > soglia?}
    E -- Si --> F[n_picchi++]
    E -- No --> D
    F --> D
    D --> G[Fine ciclo]
    G --> H[Stampa n_picchi]
```

---

## Esercizio 10 - Score rischio combinato

- **File:** `esercizi/es10_score_rischio_combinato.m`
- **Consegna:** per `n` pazienti, validare input, calcolare score e classe rischio.
- **Hint:** `while` per età valida, `if` per score incrementale, `for` sui pazienti.
- **Soluzione:** `soluzioni/es10_score_rischio_combinato_sol.m`

```mermaid
flowchart TD
    A[Leggi n pazienti] --> B[for p=1..n]
    B --> C[Leggi eta]
    C --> D{eta valida?}
    D -- No --> C
    D -- Si --> E[Leggi bpm e sistolica]
    E --> F[score = 0]
    F --> G{eta >= 65?}
    G -- Si --> H[score += 2]
    G -- No --> I[continua]
    H --> J{bpm >= 100?}
    I --> J
    J -- Si --> K[score += 1]
    J -- No --> L[continua]
    K --> M{sistolica >= 140?}
    L --> M
    M -- Si --> N[score += 2]
    M -- No --> O[classifica rischio]
    N --> O
    O --> P[Stampa risultato paziente]
```

---

## 5) Consegna studenti

Consegna:
1. file completati in `esercizi/`,
2. output (screenshot o testo) di almeno 6 esercizi,
3. breve riflessione (8-10 righe): differenza pratica tra `for` e `while`.

---

## 6) Supporto AI (facoltativo)

```text
Completa il file MATLAB corrente rispettando i TODO.
Vincoli:
- usa solo le strutture richieste dall'esercizio
- non cambiare nomi variabili gia presenti
- non usare toolbox esterni
Alla fine indica:
1) come eseguire il file
2) un input di test
3) output atteso
```

