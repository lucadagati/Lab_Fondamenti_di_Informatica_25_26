% Esercizio 1 — Connessione SQLite, lettura tabella pazienti con sqlread
%
% Eseguibile con un solo Run: ricrea sempre lab07_biomed.db e mostra i pazienti.

thisDir = fileparts(mfilename('fullpath'));
labDir = fileparts(thisDir);
addpath(fullfile(labDir, 'codice'));
dbPath = lab07_create_fresh_database(labDir);

conn = sqlite(dbPath);
T = sqlread(conn, 'pazienti');
close(conn);

disp('--- Tabella pazienti ---');
disp(T);
