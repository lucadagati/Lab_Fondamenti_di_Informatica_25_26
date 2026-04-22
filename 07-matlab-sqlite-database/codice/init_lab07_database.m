% init_lab07_database — ricrea solo il file .db (nessun esercizio)
%
% Esegui dalla cartella del lab: run('codice/init_lab07_database.m')
% Glossario comandi: vedi esercizi/es01_apri_db_sqlread.m

thisDir = fileparts(mfilename('fullpath'));
labDir = fileparts(thisDir);
addpath(thisDir);
dbPath = lab07_create_fresh_database(labDir);
fprintf('Database creato: %s\n', dbPath);
