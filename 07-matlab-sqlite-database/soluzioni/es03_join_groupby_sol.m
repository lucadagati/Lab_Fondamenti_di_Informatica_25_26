% Soluzione esercizio 3 (stesso comportamento di esercizi/es03_join_groupby.m)

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
