% init_lab07_database — ricrea solo il file .db (nessun esercizio)
%
% Esegui dalla cartella del lab: run('codice/init_lab07_database.m')
% Glossario comandi: vedi esercizi/es01_apri_db_sqlread.m

labDir = pwd;
if ~isfolder(fullfile(labDir, 'codice'))
    parentDir = fileparts(labDir);
    if isfolder(fullfile(parentDir, 'codice'))
        labDir = parentDir;
    else
        error('lab07:path', 'Esegui dalla cartella del lab o da codice/esercizi.');
    end
end
run(fullfile(labDir, 'codice', 'lab07_create_fresh_database.m'));
fprintf('Database creato: %s\n', dbPath);
