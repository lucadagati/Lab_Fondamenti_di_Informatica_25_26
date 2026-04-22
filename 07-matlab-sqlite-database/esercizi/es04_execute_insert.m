% Esercizio 4 — INSERT con execute (ferritina per paziente 1)
%
% Ricrea il database, inserisce un nuovo esame, legge la riga inserita.

thisDir = fileparts(mfilename('fullpath'));
labDir = fileparts(thisDir);
addpath(fullfile(labDir, 'codice'));
dbPath = lab07_create_fresh_database(labDir);

conn = sqlite(dbPath);
sql = [ ...
    'INSERT INTO esami_lab (paziente_id, nome_esame, valore, unita, data_esame) ' ...
    'VALUES (1, ''Ferritina'', 85, ''ng/mL'', ''2025-05-01'');' ...
    ];
execute(conn, sql);
T = fetch(conn, 'SELECT * FROM esami_lab WHERE nome_esame = ''Ferritina'';');
close(conn);

disp('--- Riga Ferritina inserita ---');
disp(T);
