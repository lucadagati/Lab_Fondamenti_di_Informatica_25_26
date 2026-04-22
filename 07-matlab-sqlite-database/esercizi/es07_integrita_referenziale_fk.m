% ESERCIZIO 7 — Foreign key: niente esami senza paziente reale
%
% esami_lab.visita_id è FOREIGN KEY verso visite.id: ogni risultato deve appartenere
% a una visita reale. Senza PRAGMA foreign_keys=ON SQLite
% potrebbe accettare anche id sbagliati: per questo la riga PRAGMA è obbligatoria.
%
% Glossario: es01_apri_db_sqlread.m

cartellaScript = fileparts(mfilename('fullpath'));
cartellaLab = fileparts(cartellaScript);
addpath(fullfile(cartellaLab, 'codice'));

percorsoDb = lab07_create_fresh_database(cartellaLab);
conn = sqlite(percorsoDb);
execute(conn, 'PRAGMA foreign_keys=ON;');  % senza questo, SQLite potrebbe ignorare le FK

disp('--- Quante visite hanno id = 9999? (deve essere 0) ---');
disp(fetch(conn, 'SELECT COUNT(*) AS n FROM visite WHERE id = 9999;'));

try
    execute(conn, [ ...
        'INSERT INTO esami_lab (visita_id, tipo_esame_id, valore, unita, data_risultato) ' ...
        'VALUES (9999, 1, 100, ''mg/dL'', ''2025-01-01'')' ...
        ]);
    disp('ERRORE: l''INSERT non avrebbe dovuto riuscire.');
catch ME
    disp('--- Errore atteso: violazione di FOREIGN KEY (visita inesistente) ---');
    disp(ME.message);
end

close(conn);
