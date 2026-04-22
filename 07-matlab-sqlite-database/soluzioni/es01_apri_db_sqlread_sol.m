% Soluzione esercizio 1 (stesso comportamento di esercizi/es01_apri_db_sqlread.m)

thisDir = fileparts(mfilename('fullpath'));
labDir = fileparts(thisDir);
addpath(fullfile(labDir, 'codice'));
dbPath = lab07_create_fresh_database(labDir);

conn = sqlite(dbPath);
T = sqlread(conn, 'pazienti');
close(conn);

disp('--- Tabella pazienti ---');
disp(T);
