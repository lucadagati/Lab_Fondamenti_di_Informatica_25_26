# Lab 1 – Crittografia: chiavi, AES, RSA, firma digitale e crittoanalisi

**Fondamenti di Informatica per Ingegneria Biomedica** – UniMe – A.A. 2025/26 – **Luca D'Agati**

Primo laboratorio su crittografia e sicurezza: generazione chiavi, crittografia simmetrica (AES) e asimmetrica (RSA), firma digitale, crittoanalisi (brute force, dictionary attack). In questa guida trovi **l’installazione dei tool** e **spiegazioni dettagliate** di ogni comando e di tutte le opzioni usate.

---

# Installazione dei tool

Esegui i comandi della sezione del **tuo sistema operativo**. Alla fine il comando `openssl` deve essere disponibile in un terminale.

---

## macOS

### 1. Terminale

È incluso in macOS: **Applicazioni → Utility → Terminale**, oppure Cmd+Spazio e digita `Terminal`.

### 2. OpenSSL

Verifica se è già presente:

```bash
openssl version
```

**Risultato atteso:** una riga tipo `OpenSSL 3.x.x ...`.

Se il comando **non viene trovato** o la versione è molto vecchia, installa OpenSSL tramite Homebrew.

#### 2a. Installare Homebrew (solo se non ce l’hai già)

Nel Terminale:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

- `curl -fsSL` scarica lo script di installazione: **-f** (fail in silenzio su errori HTTP), **-s** (silent), **-S** (mostra errori), **-L** (segue redirect).
- L’output viene passato a `bash`, che esegue lo script. Potrebbe chiedere la password di amministratore; alla fine potrebbero essere indicati comandi da eseguire (es. `echo 'eval ...' >> ~/.zprofile`): eseguili.

#### 2b. Installare OpenSSL

```bash
brew install openssl
```

- **brew** è il gestore di pacchetti di Homebrew; **install** installa il pacchetto **openssl**.

Verifica:

```bash
openssl version
```

Se su Mac con chip Apple (M1/M2/M3) `openssl` non viene trovato dopo l’installazione, aggiungi OpenSSL al PATH:

```bash
echo 'export PATH="/opt/homebrew/opt/openssl@3/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
openssl version
```

- **echo ... >> ~/.zshrc** aggiunge la riga al file di configurazione della shell (**.zshrc**).
- **source ~/.zshrc** rilegge il file così che il PATH sia aggiornato nella sessione corrente.

---

## Windows

Puoi usare **WSL** (consigliato), **Git Bash** oppure **PowerShell** con OpenSSL installato a parte.

---

### Opzione A – WSL (Windows Subsystem for Linux)

WSL fornisce un ambiente Linux (Ubuntu) dentro Windows; i comandi della guida sono gli stessi.

#### 1. Installare WSL

Apri **PowerShell** o **Prompt dei comandi** come **Amministratore** (tasto destro → Esegui come amministratore):

```powershell
wsl --install
```

- **wsl** è il comando per gestire WSL; **--install** installa WSL e, di default, una distribuzione Linux (Ubuntu). Potrebbe essere richiesto un riavvio.

Dopo il riavvio completa la configurazione di Ubuntu (nome utente e password).

#### 2. Installare OpenSSL in Ubuntu (WSL)

Nella finestra di **Ubuntu** (WSL):

```bash
sudo apt update
sudo apt install openssl -y
```

- **sudo** esegue il comando con privilegi di amministratore.
- **apt** è il gestore pacchetti di Debian/Ubuntu: **update** aggiorna l’elenco dei pacchetti; **install openssl -y** installa OpenSSL e **-y** risponde automaticamente “sì” alle conferme.

Verifica:

```bash
openssl version
```

#### 3. Raggiungere la cartella del lab da WSL

Se i file sono in Windows, ad es. `C:\Users\Mario\Desktop\Lab_Biomed`:

```bash
cd /mnt/c/Users/Mario/Desktop/Lab_Biomed/01-crittografia-chiavi
ls
```

- In WSL il disco **C:** è montato sotto **/mnt/c/**; **cd** cambia directory; **ls** elenca i file (equivalente di `dir` in Windows).

---

### Opzione B – Git Bash

#### 1. Installare Git for Windows (Git Bash)

- Vai su **https://git-scm.com/download/win**, scarica l’installer (64-bit) ed esegui. Opzioni predefinite vanno bene; assicurati che Git sia aggiunto al PATH.
- Apri **Git Bash** dal menu Start.

#### 2. Verificare OpenSSL in Git Bash

```bash
openssl version
```

Se non è presente, installa OpenSSL su Windows (vedi Opzione C) e aggiungi la cartella `bin` al PATH di sistema; poi riapri Git Bash.

#### 3. Cartella del lab in Git Bash

Es. materiale in `C:\Users\Mario\Desktop\Lab_Biomed`:

```bash
cd /c/Users/Mario/Desktop/Lab_Biomed/01-crittografia-chiavi
ls
```

- In Git Bash **/c/** rappresenta il disco **C:\**.

---

### Opzione C – PowerShell + OpenSSL (senza WSL/Git Bash)

#### 1. Installare OpenSSL su Windows

**Metodo 1 – Installer manuale**

- Vai su **https://slproweb.com/products/Win32OpenSSL.html**.
- Scarica **Win64 OpenSSL** (es. “Win64 OpenSSL v3.x.x Light”).
- Esegui l’installer e annota il percorso (es. `C:\Program Files\OpenSSL-Win64`).
- Aggiungi la cartella **bin** al PATH: Start → “Variabili d’ambiente” → Variabili di sistema → **Path** → Modifica → Nuovo → inserisci `C:\Program Files\OpenSSL-Win64\bin` (o il percorso dell’installer). OK, poi **riapri PowerShell** e verifica:

```powershell
openssl version
```

**Metodo 2 – Chocolatey**

PowerShell **come Amministratore** (solo la prima volta, per installare Chocolatey):

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

- **Set-ExecutionPolicy Bypass -Scope Process -Force** consente l’esecuzione di script nella sessione corrente.
- La seconda riga abilita TLS 1.2 per il download.
- **iex** (Invoke-Expression) esegue lo script scaricato che installa Chocolatey.

Chiudi e riapri PowerShell come Amministratore, poi:

```powershell
choco install openssl -y
```

- **choco** è il comando Chocolatey; **-y** conferma senza chiedere.

Verifica: `openssl version`.

#### 2. Cartella del lab in PowerShell

```powershell
cd C:\Users\Mario\Desktop\Lab_Biomed\01-crittografia-chiavi
dir
```

In PowerShell per **visualizzare un file** usa `Get-Content file.txt` (o `type file.txt`) invece di `cat`; per lo **script della Parte 5** è consigliato usare WSL o Git Bash.

---

## Linux (Debian/Ubuntu)

### Terminale e OpenSSL

```bash
sudo apt update
sudo apt install openssl -y
openssl version
```

Su Fedora/RHEL:

```bash
sudo dnf install openssl -y
openssl version
```

---

## Verifica finale (tutti i sistemi)

In un terminale:

```bash
openssl version
```

Se vedi un numero di versione (es. `OpenSSL 3.x.x`), puoi procedere con il laboratorio. Tutti i comandi sotto vanno eseguiti **dalla directory `01-crittografia-chiavi`** (dove si trovano `README.md`, `passwords.txt`, `brute_force_demo.sh`).

---

## Struttura di questa cartella

| File / cartella | Descrizione |
|-----------------|-------------|
| `README.md` | Questa guida (installazione + comandi spiegati) |
| `passwords.txt` | Dizionario per l’esercizio di attacco a dizionario |
| `brute_force_demo.sh` | Script bash per provare le password su un file cifrato |
| `soluzioni/` | Note per il docente |

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

**Cosa fa il comando**

- **echo** scrive sull’output standard il testo che gli passi tra virgolette. Le virgolette consentono di includere più righe (il ritorno a capo fa parte del testo).
- **> referto.txt** è un **redirect**: l’output di `echo` (invece di andare a video) viene scritto nel file **referto.txt**, sovrascrivendolo se esiste già. Un solo `>` significa “sovrascrivi”; **>>** significherebbe “aggiungi in coda”.

**Risultato atteso:** creato il file `referto.txt` con le 4 righe del referto.

### Verifica

```bash
cat referto.txt
```

**Cosa fa il comando**

- **cat** (concatenate) legge uno o più file e li scrive sull’output standard. Con un solo file mostra semplicemente il contenuto del file a video.

**Risultato atteso:** le quattro righe del referto (Paziente, Pressione, Glucosio, Diagnosi).

*PowerShell:* per creare il file multi-riga usa  
`@"` (a capo) `Paziente: Mario Rossi` (a capo) … `"@ | Out-File -Encoding utf8 referto.txt`  
oppure crea il file con Notepad e salvalo in `01-crittografia-chiavi`. Per visualizzare: `Get-Content referto.txt`.

---

# Parte 2 – Crittografia a chiave simmetrica (AES)

Una sola chiave (derivata dalla password) per cifrare e decifrare; veloce, adatta a grandi volumi; il problema è la distribuzione sicura della chiave.

## 2.1 Cifrare il referto con AES

### Comando

```bash
openssl enc -aes-256-cbc -salt -in referto.txt -out referto.enc
```

**Cosa fa il comando**

- **openssl** è la suite per operazioni crittografiche; **enc** è il sottocomando per **cifratura/decifratura** simmetrica (encoding/decoding).
- **-aes-256-cbc** indica l’**algoritmo** da usare:
  - **AES** (Advanced Encryption Standard), standard moderno a blocchi.
  - **256** = chiave da 256 bit.
  - **CBC** (Cipher Block Chaining): modalità di funzionamento che lega ogni blocco al precedente (aumenta la sicurezza rispetto alla sola ECB).
- **-salt** aggiunge un **salt** (valore casuale) derivato insieme alla password; lo stesso plaintext con password uguale produce ciphertext diverso e rende gli attacchi a dizionario più difficili. È consigliato usarlo sempre.
- **-in referto.txt** è il **file in input** (dati in chiaro).
- **-out referto.enc** è il **file in output** (dati cifrati). OpenSSL scriverà l’output qui invece che sull’output standard.

OpenSSL chiederà una password (e la ripetizione per conferma). La password viene usata (con il salt) per derivare la chiave effettiva per AES.

**Risultato atteso:** nessun messaggio di errore; creato `referto.enc` (contenuto non leggibile).

## 2.2 Visualizzare il file cifrato

### Comando

```bash
cat referto.enc
```

**Risultato atteso:** output non leggibile (caratteri binari o codifica base64 a seconda della versione). Serve a vedere che il contenuto è cifrato.

## 2.3 Decifrare il file

### Comando

```bash
openssl enc -d -aes-256-cbc -in referto.enc -out referto_decifrato.txt
```

**Cosa fa il comando**

- **-d** indica la **decifratura** (decode/decrypt). Senza **-d** OpenSSL cifra; con **-d** decifra.
- **-aes-256-cbc** deve coincidere con l’algoritmo usato in cifratura.
- **-in referto.enc** file cifrato in input.
- **-out referto_decifrato.txt** file in chiaro in output.

Inserisci la **stessa password** usata in 2.1.

**Risultato atteso:** creato `referto_decifrato.txt` con il testo originale.

## 2.4 Verificare il contenuto decifrato

```bash
cat referto_decifrato.txt
```

**Risultato atteso:** stesso testo del referto (Paziente: Mario Rossi, Pressione, Glucosio, Diagnosi).

## 2.5 Test con password errata (opzionale)

```bash
openssl enc -d -aes-256-cbc -in referto.enc -out test_sbagliato.txt
```

Inserisci una **password sbagliata**.

**Risultato atteso:** messaggio di errore tipo `bad decrypt`; il file generato non è utilizzabile. Puoi eliminarlo con `rm -f test_sbagliato.txt` (**rm** rimuove file; **-f** forza senza chiedere conferma).

---

# Parte 3 – Crittografia a chiave asimmetrica (RSA)

Due chiavi: pubblica (condivisibile) e privata (segreta). Utile per scambio chiavi, autenticazione, firma digitale. Più lenta della simmetrica.

## 3.1 Generare la chiave privata RSA

### Comando

```bash
openssl genpkey -algorithm RSA -out chiave_privata.pem -pkeyopt rsa_keygen_bits:2048
```

**Cosa fa il comando**

- **genpkey** è il sottocomando OpenSSL per **generare chiavi private** (per algoritmi a chiave pubblica).
- **-algorithm RSA** specifica l’**algoritmo**: RSA.
- **-out chiave_privata.pem** file in cui salvare la chiave privata. L’estensione **.pem** (Privacy-Enhanced Mail) indica un formato comune per chiavi e certificati (testo in base64 tra intestazioni).
- **-pkeyopt rsa_keygen_bits:2048** passa un’**opzione** al generatore RSA: **rsa_keygen_bits:2048** imposta la lunghezza della chiave a **2048 bit** (standard attuale; 1024 è considerato debole).

**Risultato atteso:** creato `chiave_privata.pem` (contenuto sensibile, da non condividere).

## 3.2 Estrarre la chiave pubblica

### Comando

```bash
openssl rsa -pubout -in chiave_privata.pem -out chiave_pubblica.pem
```

**Cosa fa il comando**

- **rsa** è il sottocomando per operazioni sulle chiavi RSA.
- **-pubout** indica di estrarre e scrivere la **chiave pubblica** (di default OpenSSL scrive la chiave privata).
- **-in chiave_privata.pem** file contenente la chiave privata (da cui si ricava la pubblica).
- **-out chiave_pubblica.pem** file in cui salvare la chiave pubblica.

**Risultato atteso:** messaggio tipo `writing RSA key`; creato `chiave_pubblica.pem`. Questa può essere condivisa.

## 3.3 Visualizzare la chiave pubblica (opzionale)

```bash
cat chiave_pubblica.pem
```

**Risultato atteso:** blocco che inizia con `-----BEGIN PUBLIC KEY-----` e termina con `-----END PUBLIC KEY-----` (contenuto in base64 in mezzo).

## 3.4 Creare un messaggio breve e cifrarlo con la chiave pubblica

RSA è adatto a messaggi piccoli (es. una chiave simmetrica o un identificativo). Per file grandi si usa l’approccio ibrido.

### Comandi

```bash
echo "ID paziente 12345" > messaggio.txt
openssl pkeyutl -encrypt -pubin -inkey chiave_pubblica.pem -in messaggio.txt -out messaggio.enc
```

**Cosa fa il secondo comando**

- **pkeyutl** è il sottocomando per operazioni con **chiavi pubbliche/private** (cifratura, decifratura, firma, verifica).
- **-encrypt** indica **cifratura** con la chiave pubblica (solo il titolare della chiave privata potrà decifrare).
- **-pubin** indica che la chiave fornita con **-inkey** è una **chiave pubblica** (di default OpenSSL si aspetta una chiave privata).
- **-inkey chiave_pubblica.pem** file della chiave da usare (qui: pubblica).
- **-in messaggio.txt** file da cifrare.
- **-out messaggio.enc** file cifrato in output.

**Risultato atteso:** creato `messaggio.enc` (contenuto non leggibile).

## 3.5 Decifrare con la chiave privata

### Comando

```bash
openssl pkeyutl -decrypt -inkey chiave_privata.pem -in messaggio.enc -out messaggio_decifrato.txt
```

**Cosa fa il comando**

- **-decrypt** indica **decifratura** (con la chiave privata).
- **-inkey chiave_privata.pem** chiave privata (non serve **-pubin**).
- **-in messaggio.enc** file cifrato.
- **-out messaggio_decifrato.txt** file in chiaro in output.

**Risultato atteso:** creato `messaggio_decifrato.txt`.

## 3.6 Verificare il messaggio decifrato

```bash
cat messaggio_decifrato.txt
```

**Risultato atteso:** una riga: `ID paziente 12345`.

---

# Parte 4 – Firma digitale

La firma garantisce **autenticità** (chi ha firmato), **integrità** (il file non è stato modificato) e **non ripudio**.

## 4.1 Firmare il referto

### Comando

```bash
openssl dgst -sha256 -sign chiave_privata.pem -out firma.bin referto.txt
```

**Cosa fa il comando**

- **dgst** è il sottocomando per **digest** (hash) e, in combinazione con **-sign**/**-verify**, per **firma digitale**.
- **-sha256** indica l’**algoritmo di hash**: SHA-256 (256 bit). Il file viene prima hashato; l’hash viene poi firmato con la chiave privata.
- **-sign chiave_privata.pem** indica di **firmare** l’hash usando la **chiave privata** (solo il titolare può generare questa firma).
- **-out firma.bin** file in cui salvare la **firma** (binaria).
- **referto.txt** è l’ultimo argomento: il **file da firmare** (input per il calcolo dell’hash).

**Risultato atteso:** creato il file binario `firma.bin`.

## 4.2 Verificare la firma (file originale)

### Comando

```bash
openssl dgst -sha256 -verify chiave_pubblica.pem -signature firma.bin referto.txt
```

**Cosa fa il comando**

- **-verify chiave_pubblica.pem** indica di **verificare** la firma usando la **chiave pubblica** (chiunque può verificare).
- **-signature firma.bin** è il file che contiene la **firma** da verificare.
- **referto.txt** è il file del quale si verifica che corrisponda alla firma (OpenSSL ricalcola l’hash e confronta con quello “decifrato” dalla firma).

**Risultato atteso:** una riga `Verified OK`.

## 4.3 Modificare il file e verificare di nuovo

```bash
echo "Modifica non autorizzata" >> referto.txt
openssl dgst -sha256 -verify chiave_pubblica.pem -signature firma.bin referto.txt
```

- **>> referto.txt** **aggiunge** una riga al file (append) invece di sovrascrivere.

**Risultato atteso:** la verifica **fallisce** (es. `Verification Failure`). Dimostra che la firma è legata al contenuto: se il file cambia, la verifica non va a buon fine.

### Ripristinare il referto per la Parte 5 (opzionale)

Se vuoi riportare `referto.txt` allo stato originale, ricrealo con il comando della Parte 1 prima della Parte 5.

---

# Parte 5 – Criptoanalisi e attacchi (brute force / dictionary)

Obiettivo: capire che la sicurezza dipende dalla **forza della chiave**; password deboli possono essere individuate con un attacco a dizionario.

## 5.1 Cifrare con una password debole

### Comando

```bash
openssl enc -aes-256-cbc -salt -in referto.txt -out referto_debole.enc -pass pass:1234
```

**Cosa fa l’opzione aggiuntiva**

- **-pass pass:1234** fornisce la **password da riga di comando**: **pass:** seguito dalla password (qui `1234`). In questo modo non viene richiesto l’inserimento interattivo; è comodo per script ma **da non usare in produzione** (la password resta in chiaro nella cronologia e nei processi). Usiamo una password volutamente debole per l’esercizio.

**Risultato atteso:** creato `referto_debole.enc` senza prompt.

## 5.2 Contenuto del dizionario

Il file `passwords.txt` contiene password comuni (es. `password`, `1234`, `admin`, …). È un dizionario **didattico**; in contesti reali si usano liste molto più grandi.

Verifica (opzionale): `cat passwords.txt`.

## 5.3 Eseguire lo script di attacco (didattico)

### Comandi

```bash
chmod +x brute_force_demo.sh
./brute_force_demo.sh
```

**Cosa fanno i comandi**

- **chmod +x brute_force_demo.sh** rende il file **eseguibile**: **chmod** (change mode) modifica i permessi; **+x** aggiunge il permesso di esecuzione (execute) per l’utente. Senza questo, la shell rifiuterebbe di eseguire lo script.
- **./brute_force_demo.sh** esegue lo script nella directory corrente: **.** indica la directory corrente, **/** è il separatore, **brute_force_demo.sh** è il nome del file. La **./** è necessaria perché la directory corrente di solito non è nel PATH per motivi di sicurezza.

Lo script legge `passwords.txt`, prova ogni password per decifrare `referto_debole.enc` con `openssl enc -d ... -pass pass:PAROLA`; quando la decifratura riesce, stampa “PASSWORD TROVATA” e mostra le prime righe del contenuto.

Per usare un altro file cifrato o altro dizionario:

```bash
./brute_force_demo.sh referto_debole.enc passwords.txt
```

Il primo argomento è il file cifrato, il secondo il file con la lista di password.

**Risultato atteso:** output con “PASSWORD TROVATA: 1234” e prime righe del referto decifrato.

## 5.4 Cosa osservare

La password debole è stata recuperata senza conoscere la chiave. Con una password lunga e casuale un attacco a dizionario non avrebbe successo; un brute force completo sarebbe impraticabile. Conclusione: l’algoritmo (AES) è sicuro; il punto debole è la **scelta della password**.

### Stima tempi di brute force (riferimento)

| Lunghezza / tipo password | Tempo indicativo (≈1 mld tentativi/s) |
|---------------------------|---------------------------------------|
| 4 cifre                   | Meno di 1 secondo                     |
| 6 caratteri               | Minuti                                |
| 8 caratteri               | Ore / giorni                          |
| 12 caratteri              | Anni                                  |
| 16 caratteri              | Milioni di anni                       |

---

# Parte 6 – Approccio ibrido (discussione)

Nei sistemi reali (TLS, PGP, ecc.) si combina simmetrica e asimmetrica: si genera una chiave simmetrica casuale; il file viene cifrato con AES; la chiave simmetrica viene cifrata con la chiave pubblica del destinatario; il destinatario usa la chiave privata per recuperare la chiave simmetrica e decifra il file. Così si ha velocità (simmetrica) e scambio sicuro della chiave (asimmetrica).

---

# Riepilogo comandi (checklist)

Eseguire in ordine dalla directory **`01-crittografia-chiavi`**:

| # | Comando / azione | Risultato atteso |
|---|-------------------|------------------|
| 1 | `openssl version` | Versione OpenSSL |
| 2 | Creare `referto.txt` (echo multi-riga) | File referto leggibile |
| 3 | `openssl enc -aes-256-cbc -salt -in referto.txt -out referto.enc` | File cifrato (password a richiesta) |
| 4 | `cat referto.enc` | Output non leggibile |
| 5 | `openssl enc -d -aes-256-cbc -in referto.enc -out referto_decifrato.txt` | Decifratura OK |
| 6 | `cat referto_decifrato.txt` | Testo uguale al referto |
| 7 | `openssl genpkey -algorithm RSA -out chiave_privata.pem -pkeyopt rsa_keygen_bits:2048` | Creato `chiave_privata.pem` |
| 8 | `openssl rsa -pubout -in chiave_privata.pem -out chiave_pubblica.pem` | Creato `chiave_pubblica.pem` |
| 9 | Creare `messaggio.txt` e cifrarlo con `pkeyutl -encrypt` | Creato `messaggio.enc` |
| 10 | `openssl pkeyutl -decrypt ... -out messaggio_decifrato.txt` | Decifratura OK |
| 11 | `cat messaggio_decifrato.txt` | `ID paziente 12345` |
| 12 | `openssl dgst -sha256 -sign chiave_privata.pem -out firma.bin referto.txt` | Creato `firma.bin` |
| 13 | `openssl dgst -sha256 -verify ... referto.txt` | `Verified OK` |
| 14 | Modificare `referto.txt` e verificare di nuovo | `Verification Failure` |
| 15 | `openssl enc ... -out referto_debole.enc -pass pass:1234` | Creato `referto_debole.enc` |
| 16 | `./brute_force_demo.sh` | Output “PASSWORD TROVATA: 1234” |

*PowerShell:* usa `Get-Content file.txt` al posto di `cat`; per lo script della Parte 5 usa WSL o Git Bash.

---

# Domande per la discussione

- Perché il file cifrato (AES) non è leggibile? Cosa succede con una password sbagliata?
- Qual è il vantaggio principale della crittografia simmetrica? E il limite?
- Perché l’asimmetrica è più adatta alla firma digitale?
- Perché nei sistemi sanitari non basta solo cifrare?
- Un ospedale usa AES e RSA ma password di 6 caratteri. Dove è il punto debole?
- La crittografia moderna è solida. Perché i sistemi vengono comunque violati?

---

# Consegna suggerita per gli studenti

Creare un referto fittizio e proteggerlo con AES; generare coppia RSA e firmare il referto; spiegare protezione del contenuto, autenticazione, integrità. Consegnare: file originale, file cifrato, chiave pubblica, firma, relazione di 1 pagina (differenza simmetrica/asimmetrica, vantaggi/limiti, scenario biomedico).

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
