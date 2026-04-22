% Soluzione esercizio 4

thisDir = fileparts(mfilename('fullpath'));
labDir = fileparts(thisDir);
dbPath = fullfile(labDir, 'dati', 'lab07_biomed.db');

conn = sqlite(dbPath);
sql = [ ...
    'INSERT INTO esami_lab (paziente_id, nome_esame, valore, unita, data_esame) ' ...
    'VALUES (1, ''Ferritina'', 85, ''ng/mL'', ''2025-05-01'');' ...
    ];
execute(conn, sql);
T = fetch(conn, 'SELECT * FROM esami_lab WHERE nome_esame = ''Ferritina'';');
close(conn);
disp(T);
