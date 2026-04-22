% Soluzione esercizio 2

thisDir = fileparts(mfilename('fullpath'));
labDir = fileparts(thisDir);
dbPath = fullfile(labDir, 'dati', 'lab07_biomed.db');

conn = sqlite(dbPath);
q = [ ...
    'SELECT id, paziente_id, nome_esame, valore, unita, data_esame ' ...
    'FROM esami_lab ' ...
    'WHERE nome_esame = ''Glicemia'' AND valore >= 100;' ...
    ];
T = fetch(conn, q);
close(conn);
disp(T);
