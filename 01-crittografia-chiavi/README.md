# Lab 1 – Crittografia: chiavi, AES, RSA, firma digitale e crittoanalisi

**Fondamenti di Informatica per Ingegneria Biomedica** – UniMe – A.A. 2025/26 – **Luca D'Agati**

Questo è il **primo laboratorio** su crittografia e sicurezza. Generazione delle chiavi, crittografia simmetrica (AES) e asimmetrica (RSA), firma digitale e introduzione a crittoanalisi (brute force, dictionary attack).

---

## Installazione dell’ambiente

**OpenSSL e terminale** vanno configurati una sola volta. Segui la sezione **[Installazione](../README.md#installazione)** nel [README principale del repository](../README.md#installazione) (macOS, Windows o Linux). Quando `openssl version` funziona, torna qui e segui i passaggi sotto.

---

## Preparazione: passaggi per macOS e Windows

Eseguire i passaggi del proprio sistema, **dalla cartella `01-crittografia-chiavi`**.

### macOS

1. Apri **Terminal** (Cmd+Spazio → “Terminal”).
2. Vai nella cartella del lab (es. se `Lab_Biomed` è sul Desktop):
   ```bash
   cd ~/Desktop/Lab_Biomed/01-crittografia-chiavi
   ```
3. Verifica:
   ```bash
   ls
   ```
   **Risultato atteso:** `README.md`, `passwords.txt`, `brute_force_demo.sh`, `soluzioni/`.
4. Tutti i comandi delle Parti 1–6 vanno eseguiti in questo terminale, restando in `01-crittografia-chiavi`.

### Windows (WSL o Git Bash – consigliato)

1. Apri **WSL (Ubuntu)** oppure **Git Bash**.
2. Vai nella cartella del lab (es. materiale in `C:\Users\TuoNome\Desktop\Lab_Biomed`):
   - **WSL:** `cd /mnt/c/Users/TuoNome/Desktop/Lab_Biomed/01-crittografia-chiavi`
   - **Git Bash:** `cd /c/Users/TuoNome/Desktop/Lab_Biomed/01-crittografia-chiavi`
3. Verifica: `ls` → vedi `README.md`, `passwords.txt`, `brute_force_demo.sh`.
4. Per la Parte 5: `chmod +x brute_force_demo.sh` e `./brute_force_demo.sh`.

### Windows (PowerShell)

1. Apri **PowerShell**, vai nella cartella del lab:
   ```powershell
   cd C:\Users\TuoNome\Desktop\Lab_Biomed\01-crittografia-chiavi
   dir
   ```
2. Per creare il file referto (Parte 1) usa la sintassi PowerShell (vedi [README principale](../README.md) Opzione C) o Notepad; per visualizzare file: `Get-Content file.txt` (invece di `cat`). Per lo script della Parte 5 usa WSL o Git Bash.

---

## Struttura di questa cartella (Lab 1)

| File / cartella | Descrizione |
|-----------------|-------------|
| `README.md` | Questa guida: comandi e risultati attesi per tutte le parti |
| `passwords.txt` | Dizionario per l’esercizio di attacco a dizionario |
| `brute_force_demo.sh` | Script didattico per provare le password su un file cifrato |
| `soluzioni/` | Note per il docente |

Eseguire **tutti i comandi** dalla directory **`01-crittografia-chiavi`** (dove si trovano questi file).

---

# Parte 1 – Preparazione del materiale

Creare un file di testo che simula un referto sanitario da proteggere.

### Comando

```bash
echo "Paziente: Mario Rossi
Pressione: 120/80
Glucosio: 95 mg/dL
Diagnosi: nessuna anomalia rilevata" > referto.txt
```

### Verifica

```bash
cat referto.txt
```

**Risultato atteso:** il contenuto del referto su più righe (Paziente, Pressione, Glucosio, Diagnosi).

*PowerShell:* usa il blocco `@" ... "@ | Out-File -Encoding utf8 referto.txt` o Crea il file con Notepad come descritto nel [README principale](../README.md).

---

# Parte 2 – Crittografia a chiave simmetrica (AES)

Si usa **una sola chiave** (derivata dalla password) per cifrare e decifrare. È veloce e adatta a grandi quantità di dati; il problema è la **distribuzione sicura** della chiave.

## 2.1 Cifrare il referto con AES

### Comando

```bash
openssl enc -aes-256-cbc -salt -in referto.txt -out referto.enc
```

OpenSSL chiederà una password (es. `laboratorio2024`). Inserirla due volte.

**Risultato atteso:** nessun messaggio di errore; il file `referto.enc` viene creato.

## 2.2 Visualizzare il file cifrato

### Comando

```bash
cat referto.enc
```

**Risultato atteso:** output non leggibile (caratteri binari/codifica base64 a seconda della versione). Si vede che il contenuto è cifrato.

## 2.3 Decifrare il file

### Comando

```bash
openssl enc -d -aes-256-cbc -in referto.enc -out referto_decifrato.txt
```

Inserire la **stessa password** usata in 2.1.

**Risultato atteso:** nessun errore; creato `referto_decifrato.txt`.

## 2.4 Verificare il contenuto decifrato

### Comando

```bash
cat referto_decifrato.txt
```

**Risultato atteso:** stesso testo del referto originale (Paziente: Mario Rossi, Pressione, Glucosio, Diagnosi).

## 2.5 Test con password errata (opzionale)

### Comando

```bash
openssl enc -d -aes-256-cbc -in referto.enc -out test_sbagliato.txt
```

Inserire una **password sbagliata**.

**Risultato atteso:** messaggio di errore tipo `bad decrypt` o simile; il file `test_sbagliato.txt` non è utilizzabile (contenuto corrotto). Si può eliminare con `rm -f test_sbagliato.txt`.

---

# Parte 3 – Crittografia a chiave asimmetrica (RSA)

Si usano **due chiavi**: pubblica (condivisibile) e privata (segreta). Utile per scambio chiavi, autenticazione e firma digitale. Più lenta della simmetrica.

## 3.1 Generare la chiave privata RSA

### Comando

```bash
openssl genpkey -algorithm RSA -out chiave_privata.pem -pkeyopt rsa_keygen_bits:2048
```

**Risultato atteso:** nessun output; creato il file `chiave_privata.pem`. 2048 bit è lo standard attuale.

## 3.2 Estrarre la chiave pubblica

### Comando

```bash
openssl rsa -pubout -in chiave_privata.pem -out chiave_pubblica.pem
```

**Risultato atteso:** messaggio tipo `writing RSA key`; creato `chiave_pubblica.pem`.

## 3.3 Visualizzare la chiave pubblica (opzionale)

### Comando

```bash
cat chiave_pubblica.pem
```

**Risultato atteso:** blocco di testo che inizia con `-----BEGIN PUBLIC KEY-----` e termina con `-----END PUBLIC KEY-----`.

## 3.4 Creare un messaggio breve e cifrarlo con la chiave pubblica

RSA è adatto a messaggi piccoli (es. una chiave simmetrica o un identificativo). Per file grandi si usa l’approccio ibrido.

### Comandi

```bash
echo "ID paziente 12345" > messaggio.txt
openssl pkeyutl -encrypt -pubin -inkey chiave_pubblica.pem -in messaggio.txt -out messaggio.enc
```

**Risultato atteso:** nessun errore; creato `messaggio.enc` (contenuto non leggibile).

## 3.5 Decifrare con la chiave privata

### Comando

```bash
openssl pkeyutl -decrypt -inkey chiave_privata.pem -in messaggio.enc -out messaggio_decifrato.txt
```

**Risultato atteso:** nessun errore; creato `messaggio_decifrato.txt`.

## 3.6 Verificare il messaggio decifrato

### Comando

```bash
cat messaggio_decifrato.txt
```

**Risultato atteso:** una riga: `ID paziente 12345`.

---

# Parte 4 – Firma digitale

La firma digitale garantisce **autenticità** (chi ha firmato), **integrità** (il file non è stato modificato) e **non ripudio**.

## 4.1 Firmare il referto (prima di modificarlo)

Si usa la **chiave privata** per firmare. La firma è un hash del file (SHA-256) cifrato con la chiave privata.

### Comando

```bash
openssl dgst -sha256 -sign chiave_privata.pem -out firma.bin referto.txt
```

**Risultato atteso:** nessun output; creato il file binario `firma.bin`.

## 4.2 Verificare la firma (file originale)

### Comando

```bash
openssl dgst -sha256 -verify chiave_pubblica.pem -signature firma.bin referto.txt
```

**Risultato atteso:** una riga:

```
Verified OK
```

## 4.3 Modificare il file e verificare di nuovo

Si simula una modifica non autorizzata al referto.

### Comandi

```bash
echo "Modifica non autorizzata" >> referto.txt
openssl dgst -sha256 -verify chiave_pubblica.pem -signature firma.bin referto.txt
```

**Risultato atteso:** la verifica **fallisce**. Messaggio tipo:

```
Verification Failure
```

Questo dimostra che la firma è legata al contenuto: se il file cambia, la verifica non va a buon fine.

### Ripristinare il referto per la Parte 5 (opzionale)

Se si vuole riportare `referto.txt` allo stato originale per gli step successivi, ricrearlo con il comando della Parte 1 prima di eseguire la Parte 5.

---

# Parte 5 – Criptoanalisi e attacchi (brute force / dictionary)

Obiettivo: capire che la **sicurezza dipende dalla forza della chiave**; password deboli possono essere individuate con un attacco a dizionario.

## 5.1 Cifrare il referto con una password debole

Si crea un file cifrato con una password **molto debole** (es. `1234`), presente in molti dizionari.

### Comando

```bash
openssl enc -aes-256-cbc -salt -in referto.txt -out referto_debole.enc -pass pass:1234
```

**Risultato atteso:** nessun prompt; il file `referto_debole.enc` viene creato (la password è passata da riga di comando).

## 5.2 Contenuto del dizionario

Il file `passwords.txt` contiene una lista di password comuni (es. `password`, `1234`, `admin`, `test`, `mario`, ecc.). È un piccolo dizionario **didattico**; in contesti reali si usano liste molto più grandi.

### Verifica (opzionale)

```bash
cat passwords.txt
```

**Risultato atteso:** una password per riga; tra queste c’è `1234`.

## 5.3 Eseguire lo script di attacco (didattico)

Lo script prova ogni password del dizionario sul file cifrato fino a trovare quella corretta.

### Comandi

```bash
chmod +x brute_force_demo.sh
./brute_force_demo.sh
```

Per usare un altro file cifrato o altro dizionario:

```bash
./brute_force_demo.sh referto_debole.enc passwords.txt
```

**Risultato atteso:** output simile al seguente (l’ordine può variare in base a `passwords.txt`):

```
=== Attacco dictionary (didattico) ===
File da attaccare: referto_debole.enc
Dizionario: passwords.txt

Provo password: password ... no
Provo password: 1234 ... OK

*** PASSWORD TROVATA: 1234 ***
Contenuto decifrato (prime righe):
Paziente: Mario Rossi
Pressione: 120/80
...
```

Lo script termina con codice 0 quando trova la password.

## 5.4 Cosa osservare

- La **password debole** è stata recuperata senza conoscere la chiave, solo provando voci del dizionario.
- Con una **password lunga e casuale** (es. 20 caratteri) un attacco a dizionario non sarebbe riuscito; un brute force completo sarebbe impraticabile (vedi stime sotto).
- Conclusione: l’algoritmo (AES) è sicuro; il punto debole è la **scelta della password**.

### Stima tempi di brute force (riferimento)

Supponendo circa 1 miliardo di tentativi al secondo:

| Lunghezza / tipo password | Tempo indicativo |
|---------------------------|------------------|
| 4 cifre                   | Meno di 1 secondo |
| 6 caratteri               | Minuti           |
| 8 caratteri               | Ore / giorni     |
| 12 caratteri              | Anni             |
| 16 caratteri              | Milioni di anni  |

---

# Parte 6 – Approccio ibrido (discussione)

Nei sistemi reali (TLS, PGP, ecc.) si combina simmetrica e asimmetrica:

1. Si genera una **chiave simmetrica** casuale (es. per AES).
2. Il **file** (grande) viene cifrato con questa chiave simmetrica.
3. La **chiave simmetrica** viene cifrata con la **chiave pubblica** del destinatario.
4. Il destinatario usa la **chiave privata** per recuperare la chiave simmetrica e poi decifra il file.

In questo modo si ha la velocità della crittografia simmetrica e la sicurezza dello scambio chiavi tramite crittografia asimmetrica.

---

# Riepilogo comandi (checklist)

Eseguire in ordine dalla directory **`01-crittografia-chiavi`**:

| # | Comando / azione | Risultato atteso |
|---|-------------------|------------------|
| 1 | `openssl version` | Versione OpenSSL |
| 2 | Creare `referto.txt` (echo multi-riga) | File referto leggibile |
| 3 | `openssl enc -aes-256-cbc -salt -in referto.txt -out referto.enc` | File cifrato (con password a richiesta) |
| 4 | `cat referto.enc` | Output non leggibile |
| 5 | `openssl enc -d -aes-256-cbc -in referto.enc -out referto_decifrato.txt` | Decifratura OK con password corretta |
| 6 | `cat referto_decifrato.txt` | Testo uguale al referto originale |
| 7 | `openssl genpkey -algorithm RSA -out chiave_privata.pem -pkeyopt rsa_keygen_bits:2048` | Creato `chiave_privata.pem` |
| 8 | `openssl rsa -pubout -in chiave_privata.pem -out chiave_pubblica.pem` | Creato `chiave_pubblica.pem` |
| 9 | Creare `messaggio.txt` e cifrarlo con `pkeyutl -encrypt` | Creato `messaggio.enc` |
| 10 | `openssl pkeyutl -decrypt ... -out messaggio_decifrato.txt` | Decifratura OK |
| 11 | `cat messaggio_decifrato.txt` | `ID paziente 12345` |
| 12 | `openssl dgst -sha256 -sign chiave_privata.pem -out firma.bin referto.txt` | Creato `firma.bin` |
| 13 | `openssl dgst -sha256 -verify ... referto.txt` | `Verified OK` |
| 14 | Modificare `referto.txt` e verificare di nuovo | `Verification Failure` |
| 15 | `openssl enc ... -out referto_debole.enc -pass pass:1234` | Creato `referto_debole.enc` |
| 16 | `./brute_force_demo.sh` | Output con "PASSWORD TROVATA: 1234" |

*Su Windows con PowerShell:* usa `Get-Content file.txt` (o `type file.txt`) al posto di `cat`; per lo script della Parte 5 usa WSL o Git Bash (vedi [README principale](../README.md)).

---

# Domande per la discussione

- Perché il file cifrato (AES) non è leggibile? E cosa succede con una password sbagliata?
- Qual è il vantaggio principale della crittografia simmetrica? E il limite?
- Perché la crittografia asimmetrica è più adatta alla firma digitale?
- Perché nei sistemi sanitari non basta solo cifrare? (integrità, autenticità.)
- Un ospedale usa AES per le cartelle cliniche, RSA per lo scambio chiavi, ma password di 6 caratteri. **Dove è il punto debole?** (Risposta: le password.)
- La crittografia moderna è matematicamente solida. Perché i sistemi vengono comunque violati? (Password deboli, errori di implementazione, gestione delle chiavi, fattore umano.)

---

# Consegna suggerita per gli studenti

- Creare un referto fittizio e proteggerlo con AES.
- Generare una coppia di chiavi RSA e firmare il referto.
- Spiegare quale tecnica usare per: **protezione del contenuto**, **autenticazione del mittente**, **integrità del documento**.
- Consegnare: file originale, file cifrato con AES, chiave pubblica, firma digitale, breve relazione (1 pagina) con differenza simmetrica/asimmetrica, vantaggi/limiti e uno scenario biomedico di applicazione.

---

# Valutazione (griglia esempio)

| Criterio | Peso |
|----------|------|
| Comprensione teorica | 30% |
| Corretta generazione delle chiavi | 20% |
| Corretta cifratura/decifratura | 20% |
| Uso corretto della firma digitale | 20% |
| Chiarezza della relazione finale | 10% |

---

*Materiale didattico – Fondamenti di Informatica per Ingegneria Biomedica – Università degli Studi di Messina – A.A. 2025/26 – Docente: Luca D'Agati*
