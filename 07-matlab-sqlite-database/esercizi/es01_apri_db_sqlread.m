% Esercizio 1 — Connessione e sqlread
% Obiettivo: aprire lab07_biomed.db e caricare la tabella pazienti in una table T.

thisDir = fileparts(mfilename('fullpath'));
labDir = fileparts(thisDir);
dbPath = fullfile(labDir, 'dati', 'lab07_biomed.db');

% TODO 1: verificare che il file DB esista; se manca, suggerire di lanciare init_lab07_database.m
% if ~isfile(dbPath) ...

% TODO 2: creare la connessione SQLite
% conn = sqlite(dbPath);

% TODO 3: leggere la tabella pazienti
% T = sqlread(conn, 'pazienti');

% TODO 4: chiudere la connessione
% close(conn);

% TODO 5: visualizzare T con disp
% disp(T);
