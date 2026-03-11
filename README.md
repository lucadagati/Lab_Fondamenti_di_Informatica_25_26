# Laboratori – Crittografia e sicurezza informatica

**Fondamenti di Informatica per Ingegneria Biomedica**  
Università degli Studi di Messina – Anno accademico 2025/26  

**Docente:** Luca D'Agati  

---

Questo repository contiene i laboratori su **crittografia e sicurezza informatica**. Ogni laboratorio è in una cartella numerata (es. `01-crittografia-chiavi`). Segui prima l’**installazione** sotto, poi apri la cartella del laboratorio che ti è stata assegnata.

---

## Struttura del repository

```
Lab_Biomed/
├── README.md                    ← Sei qui: overview e installazione
├── 01-crittografia-chiavi/       ← Lab 1: chiavi, AES, RSA, firma, crittoanalisi
│   ├── README.md
│   ├── passwords.txt
│   ├── brute_force_demo.sh
│   └── soluzioni/
├── 02-README.md                 ← Placeholder per i prossimi lab
└── ...
```

- **Lab 1** – Generazione chiavi, crittografia simmetrica (AES) e asimmetrica (RSA), firma digitale, introduzione a crittoanalisi e brute force.
- **Lab 2, 3, …** – Saranno aggiunti in seguito nella stessa struttura.

---

# Installazione (tutto ciò che serve)

Esegui i comandi della sezione del **tuo sistema operativo**. Alla fine deve essere disponibile il comando `openssl` in un terminale.

---

## macOS

### 1. Terminale

È incluso in macOS. Per aprirlo: **Applicazioni → Utility → Terminale**, oppure Cmd+Spazio e digita `Terminal`.

### 2. OpenSSL

OpenSSL è di solito già presente. Verifica:

```bash
openssl version
```

**Risultato atteso:** una riga tipo `OpenSSL 3.x.x ...`.

Se il comando **non viene trovato** o la versione è molto vecchia, installa OpenSSL tramite Homebrew.

#### 2a. Installare Homebrew (se non ce l’hai già)

Nel Terminale incolla e invia:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Segui le istruzioni a video (potrebbe chiedere la password di amministratore). Alla fine potrebbe dirti di eseguire due comandi tipo `echo 'eval ...' >> ~/.zprofile`; eseguili.

#### 2b. Installare OpenSSL con Homebrew

```bash
brew install openssl
```

Verifica di nuovo:

```bash
openssl version
```

Se su Mac con chip Apple (M1/M2/M3) il comando `openssl` non viene trovato dopo l’installazione, aggiungi OpenSSL al PATH:

```bash
echo 'export PATH="/opt/homebrew/opt/openssl@3/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
openssl version
```

---

## Windows

Puoi usare **WSL** (consigliato, ambiente Linux integrato) oppure **Git Bash** + **OpenSSL**. Se preferisci restare solo su Windows senza WSL, c’è anche l’opzione **PowerShell** con OpenSSL installato a parte.

---

### Opzione A – WSL (Windows Subsystem for Linux) – consigliata

WSL ti dà un terminale Linux (Ubuntu) su Windows. I comandi dei laboratori sono gli stessi della guida.

#### 1. Installare WSL

Apri **PowerShell** o **Prompt dei comandi** come **Amministratore** (tasto destro → Esegui come amministratore) ed esegui:

```powershell
wsl --install
```

Riavvia il PC se richiesto. Dopo il riavvio si aprirà la finestra di Ubuntu; completa la configurazione (nome utente e password).

#### 2. Installare OpenSSL in WSL (Ubuntu)

Nella finestra di **Ubuntu** (WSL) esegui:

```bash
sudo apt update
sudo apt install openssl -y
```

Verifica:

```bash
openssl version
```

**Risultato atteso:** versione OpenSSL (es. `OpenSSL 3.x.x`).

#### 3. Raggiungere la cartella dei laboratori da WSL

Se i file del laboratorio sono in Windows, ad esempio in `C:\Users\Mario\Desktop\Lab_Biomed`, da WSL fai:

```bash
cd /mnt/c/Users/Mario/Desktop/Lab_Biomed
```

(sostituisci `Mario` con il tuo nome utente Windows). Poi entra nella cartella del lab, es. Lab 1:

```bash
cd 01-crittografia-chiavi
ls
```

Da lì puoi eseguire tutti i comandi del [Lab 1](01-crittografia-chiavi/README.md).

---

### Opzione B – Git Bash + OpenSSL

Git Bash offre un terminale stile Linux e spesso include strumenti utili; OpenSSL può essere incluso o installato a parte.

#### 1. Installare Git for Windows (Git Bash)

- Vai su: **https://git-scm.com/download/win**
- Scarica l’installer (es. “64-bit Git for Windows Setup”) ed esegui.
- Durante l’installazione puoi lasciare le opzioni predefinite. Assicurati che sia selezionata l’opzione per aggiungere Git al PATH.
- Al termine, apri **Git Bash** dal menu Start.

#### 2. Verificare OpenSSL in Git Bash

In Git Bash esegui:

```bash
openssl version
```

Se vedi la versione, OpenSSL è già disponibile. Se **non** è presente, installa OpenSSL su Windows (vedi Opzione C, punti 1–2) e aggiungi la cartella `bin` di OpenSSL al PATH di sistema; poi riapri Git Bash.

#### 3. Raggiungere la cartella dei laboratori

In Git Bash, se i file sono in `C:\Users\Mario\Desktop\Lab_Biomed`:

```bash
cd /c/Users/Mario/Desktop/Lab_Biomed
cd 01-crittografia-chiavi
ls
```

(Usa `/c/` per il disco `C:\`; adatta `Mario` al tuo utente.)

---

### Opzione C – PowerShell + OpenSSL (solo Windows, senza WSL/Git Bash)

#### 1. Installare OpenSSL su Windows

**Metodo 1 – Installer manuale (consigliato se non usi Chocolatey)**

- Vai su: **https://slproweb.com/products/Win32OpenSSL.html**
- Scarica la versione **Win64 OpenSSL** (es. “Win64 OpenSSL v3.x.x Light”, non la “Full”).
- Esegui l’installer. Nota il percorso di installazione (es. `C:\Program Files\OpenSSL-Win64`).
- Aggiungi la cartella **bin** al PATH di sistema:
  - Cerca “Variabili d’ambiente” nel menu Start e apri “Modifica le variabili d’ambiente di sistema”.
  - Clicca “Variabili d’ambiente”.
  - In “Variabili di sistema” seleziona `Path` → “Modifica” → “Nuovo” e aggiungi:  
    `C:\Program Files\OpenSSL-Win64\bin`  
    (o il percorso indicato dall’installer).
  - Conferma con OK. **Riapri PowerShell** (e eventualmente il PC) e verifica:

```powershell
openssl version
```

**Metodo 2 – Chocolatey**

Apri **PowerShell come Amministratore** ed esegui prima l’installazione di Chocolatey (solo la prima volta):

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

Chiudi e riapri PowerShell come Amministratore, poi:

```powershell
choco install openssl -y
```

Verifica:

```powershell
openssl version
```

#### 2. Cartella dei laboratori in PowerShell

```powershell
cd C:\Users\Mario\Desktop\Lab_Biomed
cd 01-crittografia-chiavi
dir
```

(sostituisci `Mario` e il percorso con i tuoi.)

In PowerShell alcuni comandi dei laboratori sono diversi (es. visualizzare un file: `Get-Content file.txt` invece di `cat`). Le istruzioni specifiche per PowerShell sono nel [README del Lab 1](01-crittografia-chiavi/README.md).

---

## Linux (Debian/Ubuntu e derivate)

### 1. Terminale

Apri il terminale (Ctrl+Alt+T su Ubuntu o dalla ricerca applicazioni).

### 2. OpenSSL

```bash
sudo apt update
sudo apt install openssl -y
openssl version
```

**Risultato atteso:** versione OpenSSL (es. `OpenSSL 3.x.x`).

Su Fedora / RHEL:

```bash
sudo dnf install openssl -y
openssl version
```

---

## Verifica finale (tutti i sistemi)

In un terminale (macOS: Terminal; Windows: WSL, Git Bash o PowerShell; Linux: terminale) esegui:

```bash
openssl version
```

Se vedi un numero di versione (es. `OpenSSL 3.x.x`), l’installazione è ok. Puoi procedere con il [Laboratorio 1 – Crittografia e chiavi](01-crittografia-chiavi/README.md).

---

## Elenco laboratori

| Lab | Cartella | Argomento |
|-----|----------|-----------|
| 1 | [01-crittografia-chiavi](01-crittografia-chiavi/README.md) | Chiavi, crittografia simmetrica (AES) e asimmetrica (RSA), firma digitale, crittoanalisi e brute force |
| 2, 3, … | *(in arrivo)* | Saranno aggiunti nella stessa struttura (es. `02-nome-lab/`) |

---

*Materiale didattico – Fondamenti di Informatica per Ingegneria Biomedica – Università degli Studi di Messina – A.A. 2025/26 – Docente: Luca D'Agati*
