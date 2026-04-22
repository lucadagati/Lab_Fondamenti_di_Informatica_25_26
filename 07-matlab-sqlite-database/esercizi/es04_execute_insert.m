% Esercizio 4 — INSERT con execute
% Obiettivo: inserire un nuovo esame per il paziente_id = 1 (es. ferritina 85 ng/mL, data 2025-05-01)
% usando execute(conn, sql) senza sqlwrite.

thisDir = fileparts(mfilename('fullpath'));
labDir = fileparts(thisDir);
dbPath = fullfile(labDir, 'dati', 'lab07_biomed.db');

% TODO 1: conn = sqlite(dbPath);

% TODO 2: sql = 'INSERT INTO esami_lab (paziente_id, nome_esame, valore, unita, data_esame) VALUES (...);';
% execute(conn, sql);

% TODO 3: verificare con fetch che la riga esista
% T = fetch(conn, 'SELECT * FROM esami_lab WHERE nome_esame = ''Ferritina'';');

% TODO 4: close(conn); disp(T);
