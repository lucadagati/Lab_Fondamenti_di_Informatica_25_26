% ESERCIZIO 1 — Leggere una tabella intera con sqlread
%
% Obiettivo: aprire il file SQLite e copiare in MATLAB tutta la tabella "pazienti".
%
% --- Glossario (comandi che trovi in tutti gli esercizi del lab) ---------------
% sqlite(percorsoFile) : apre il database (è un file .db sul disco). Restituisce
%                        l’oggetto "connessione" che chiamiamo spesso conn.
% execute(conn, testoSql) : manda al motore SQLite una stringa SQL. Si usa per
%                        comandi che NON restituiscono una tabella di risultato
%                        (es. PRAGMA, INSERT, DELETE) oppure per impostazioni.
% fetch(conn, testoSql)  : esegue un SELECT e restituisce il risultato come table.
% sqlread(conn, nomeTab): equivale a "SELECT * FROM nomeTab": legge tutta la tabella.
% close(conn)           : chiude la connessione; va sempre fatto a fine script.
% PRAGMA foreign_keys=ON: PRAGMA = istruzione speciale di SQLite per configurare
%                        il motore. foreign_keys=ON attiva il controllo delle
%                        FOREIGN KEY su questa connessione (se no, SQLite le ignora).

% --- Percorsi: dove siamo sul disco -----------------------------------------
cartellaScript = fileparts(mfilename('fullpath'));   % cartella che contiene questo .m (esercizi/)
cartellaLab = fileparts(cartellaScript);             % cartella radice del lab 07

% MATLAB deve "vedere" la funzione in codice/ → la aggiungiamo al path
addpath(fullfile(cartellaLab, 'codice'));

% Ricrea da zero il file dati/lab07_biomed.db (tabelle + righe di esempio)
percorsoDb = lab07_create_fresh_database(cartellaLab);

% Apre il file .db: da qui in poi parliamo col database tramite conn
conn = sqlite(percorsoDb);

% PRAGMA non è una tabella: è un comando al motore. Qui chiediamo: controlla le FK.
execute(conn, 'PRAGMA foreign_keys=ON;');

% Leggiamo l’intera tabella pazienti → una table MATLAB (una riga per paziente)
tabellaPazienti = sqlread(conn, 'pazienti');

% Liberiamo il file .db per altri programmi / prossime esecuzioni
close(conn);

disp('Tabella pazienti:');
disp(tabellaPazienti);
