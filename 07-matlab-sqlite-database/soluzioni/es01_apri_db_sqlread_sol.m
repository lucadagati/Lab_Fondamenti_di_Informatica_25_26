% Soluzione esercizio 1

thisDir = fileparts(mfilename('fullpath'));
labDir = fileparts(thisDir);
dbPath = fullfile(labDir, 'dati', 'lab07_biomed.db');

if ~isfile(dbPath)
    error('Esegui prima: run(''codice/init_lab07_database.m'') con Current Folder sulla cartella 07-matlab-sqlite-database.');
end

conn = sqlite(dbPath);
T = sqlread(conn, 'pazienti');
close(conn);
disp(T);
