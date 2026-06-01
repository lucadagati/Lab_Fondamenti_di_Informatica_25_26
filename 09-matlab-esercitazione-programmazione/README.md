# Lab 9 - MATLAB: esercitazione di programmazione

**Fondamenti di Informatica per Ingegneria Biomedica** - UniMe - A.A. 2025/26

Questo laboratorio contiene esercizi guidati di programmazione MATLAB con difficolta base/intermedia avanzata, in continuita con gli esercizi tipici su:
- scalari, vettori e indici,
- if/elseif/else,
- cicli for e while,
- struct, cell array e stringhe,
- file di testo e funzioni locali,
- ricorsione semplice.

Ogni file e scritto con:
- testo iniziale descrittivo,
- sezione "Implementazione consigliata" con strategia passo-passo,
- codice completamente commentato riga per riga,
- output stampato per verificare facilmente il risultato.

---

## 1) Setup rapido

1. Apri MATLAB.
2. Imposta `Current Folder` su `09-matlab-esercitazione-programmazione`.
3. Entra nella cartella `esercizi`.

---

## 2) Esecuzione

Esempio:

```matlab
cd esercizi
es01_scalari
```

---

## 3) Elenco esercizi

1. `es01_scalari.m` - Operazioni tra scalari e stampa formattata.
2. `es02_vettori_indici.m` - Selezione con indici e somme con cicli.
3. `es03_if_pari_dispari.m` - Classificazione segno e parita di un numero.
4. `es04_for_quadrati.m` - Somma e media dei quadrati.
5. `es05_while_prodotto.m` - Prodotto progressivo con condizione di arresto.
6. `es06_cell_mista.m` - Simulazione coda ticket helpdesk (FIFO con struct/cell).
7. `es07_struct_studente.m` - Struct e logica decisionale su un esito.
8. `es08_funzione_cubo.m` - Funzione locale e calcolo elemento per elemento.
9. `es09_struct_media.m` - Array di struct, media e filtro.
10. `es10_stringhe_conta.m` - Parsing log applicativo (conteggi ERROR/WARN/INFO).
11. `es11_file_seno.m` - While con condizione obiettivo (sblocco PIN o blocco account).
12. `es12_ricorsione_fattoriale.m` - Confronto fattoriale iterativo e ricorsivo.
13. `es13_ricerca_lineare.m` - Ricerca lineare estesa (prima/ultima occorrenza, conteggio, percentuale).
14. `es14_password_policy.m` - Verifica robustezza password con regole minime.
15. `es15_csv_voti_report.m` - Lettura CSV semplice e report su medie/insufficienti.
16. `es16_ricorsione_somma_cifre.m` - Ricorsione: somma delle cifre di un intero.
17. `es17_ricorsione_palindromo.m` - Ricorsione: verifica palindromo stringa.
18. `es18_ricorsione_potenza.m` - Ricorsione: calcolo potenza a^n.

---

## 4) Pacchetto per MATLAB Grader

E stato aggiunto un mini pacchetto in `grader/` con:
- 3 esercizi in formato funzione,
- 3 file di test automatici,
- 3 soluzioni di riferimento.

Ogni esercizio ha esattamente 3 test di validazione.

Dettagli e istruzioni operative in `grader/README.md`.
