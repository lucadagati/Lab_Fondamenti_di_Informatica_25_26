% init_lab07_database — ricrea solo il file .db (nessun esercizio)
%
% Esegui dalla cartella del lab: run('codice/init_lab07_database.m')
% Glossario comandi: vedi esercizi/es01_apri_db_sqlread.m

cartellaScript = fileparts(mfilename('fullpath'));
labDir = fileparts(cartellaScript);
run(fullfile(labDir, 'codice', 'lab07_create_fresh_database.m'));
percorsoDb = dbPath;
conn = sqlite(percorsoDb);
execute(conn, 'PRAGMA foreign_keys=ON;');
fprintf('Database creato: %s\n', dbPath);
disp('Connessione aperta nella variabile conn. A fine lavoro usa: close(conn)');
