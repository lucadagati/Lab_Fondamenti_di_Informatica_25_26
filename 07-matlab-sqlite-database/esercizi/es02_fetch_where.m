% Esercizio 2 — fetch: glicemia con valore >= 100 mg/dL
%
% Ricrea il database, interroga esami_lab con filtri WHERE.

thisDir = fileparts(mfilename('fullpath'));
labDir = fileparts(thisDir);
addpath(fullfile(labDir, 'codice'));
dbPath = lab07_create_fresh_database(labDir);

conn = sqlite(dbPath);
q = [ ...
    'SELECT id, paziente_id, nome_esame, valore, unita, data_esame ' ...
    'FROM esami_lab ' ...
    'WHERE nome_esame = ''Glicemia'' AND valore >= 100;' ...
    ];
T = fetch(conn, q);
close(conn);

disp('--- Glicemia >= 100 mg/dL ---');
disp(T);
