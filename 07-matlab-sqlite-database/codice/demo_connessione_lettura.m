% demo_connessione_lettura — esempio minimo: aprire SQLite e leggere dati
%
% Prerequisito: eseguire prima init_lab07_database.m (una volta per sessione).

thisDir = fileparts(mfilename('fullpath'));
labDir = fileparts(thisDir);
dbPath = fullfile(labDir, 'dati', 'lab07_biomed.db');

if ~isfile(dbPath)
    error('Manca il database. Esegui: run(''codice/init_lab07_database.m'')');
end

conn = sqlite(dbPath);

% Lettura intera tabella come table MATLAB
T_paz = sqlread(conn, 'pazienti');
disp('--- pazienti (sqlread) ---');
disp(T_paz);

% Query arbitraria con fetch
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
