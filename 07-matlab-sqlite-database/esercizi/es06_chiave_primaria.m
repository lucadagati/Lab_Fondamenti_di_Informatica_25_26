% ESERCIZIO 6 — Chiave primaria: perché l id non può duplicarsi
%
% In pazienti la colonna id è PRIMARY KEY = identificatore univoco della riga.
% Se potessi duplicare lo stesso id, non sapresti quale record aggiornare o cancellare.
%
% Glossario comandi: vedi es01_apri_db_sqlread.m (sqlite, execute, fetch, PRAGMA, close).
% try / catch : esegue il blocco try; se MATLAB riceve un errore dall execute, salta al catch.

cartellaLab = pwd;
if ~isfolder(fullfile(cartellaLab, 'codice'))
    parentDir = fileparts(cartellaLab);
    if isfolder(fullfile(parentDir, 'codice'))
        cartellaLab = parentDir;
    else
        error('lab07:path', 'Esegui dalla cartella del lab o da codice/esercizi.');
    end
end
addpath(fullfile(cartellaLab, 'codice'));

run(fullfile(cartellaLab, 'codice', 'lab07_create_fresh_database.m'));
percorsoDb = dbPath;
conn = sqlite(percorsoDb);
execute(conn, 'PRAGMA foreign_keys=ON;');  % glossario: es01_apri_db_sqlread.m

disp('--- Riga con id = 1 (già presente dopo l init) ---');
disp(fetch(conn, 'SELECT id, nome, cognome FROM pazienti WHERE id = 1;'));

% execute(...) lancerà errore se violi la PRIMARY KEY → lo catturiamo con catch
try
    execute(conn, [ ...
        'INSERT INTO pazienti (id, nome, cognome, anno_nascita, sesso) ' ...
        'VALUES (1, ''Altro'', ''Paziente'', 1990, ''M'')' ...
        ]);
    disp('ERRORE: l''INSERT non avrebbe dovuto riuscire.');
catch ME
    disp('--- Messaggio di errore del database (violazione di chiave primaria) ---');
    disp(ME.message);
end

close(conn);
