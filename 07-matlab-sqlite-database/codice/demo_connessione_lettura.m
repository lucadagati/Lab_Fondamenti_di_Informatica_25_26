% demo_connessione_lettura — esempio: ricrea il DB, sqlread e fetch con JOIN

thisDir = fileparts(mfilename('fullpath'));
labDir = fileparts(thisDir);
addpath(fullfile(labDir, 'codice'));
dbPath = lab07_create_fresh_database(labDir);

conn = sqlite(dbPath);

T_paz = sqlread(conn, 'pazienti');
disp('--- pazienti (sqlread) ---');
disp(T_paz);

q = [ ...
    'SELECT p.cognome, e.nome_esame, e.valore, e.unita ' ...
    'FROM esami_lab e JOIN pazienti p ON e.paziente_id = p.id ' ...
    'WHERE e.nome_esame = ''Glicemia'' ' ...
    'ORDER BY e.valore DESC;' ...
    ];
T_gli = fetch(conn, q);
disp('--- glicemie con cognome (fetch + JOIN) ---');
disp(T_gli);

close(conn);
