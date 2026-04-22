% Esercizio 3 — JOIN e GROUP BY: numero di esami per paziente
%
% Ricrea il database, conta le righe in esami_lab per ogni paziente.

thisDir = fileparts(mfilename('fullpath'));
labDir = fileparts(thisDir);
addpath(fullfile(labDir, 'codice'));
dbPath = lab07_create_fresh_database(labDir);

conn = sqlite(dbPath);
q = [ ...
    'SELECT p.id, p.cognome, COUNT(e.id) AS n_esami ' ...
    'FROM pazienti p ' ...
    'LEFT JOIN esami_lab e ON e.paziente_id = p.id ' ...
    'GROUP BY p.id, p.cognome ' ...
    'ORDER BY p.id;' ...
    ];
T = fetch(conn, q);
close(conn);

disp('--- Numero esami per paziente ---');
disp(T);
