% ESERCIZIO 4 — Inserire una riga con execute (comando SQL INSERT)
%
% Obiettivo: aggiungere un esame scrivendo l’INSERT a mano come stringa.
%
% execute(conn, sql) : per INSERT/UPDATE/DELETE non serve fetch: execute invia il comando
%                      e non restituisce righe. Per controllare dopo, usi fetch con un SELECT.

cartellaLab = builtin('pwd');
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
execute(conn, 'PRAGMA foreign_keys=ON;');  % glossario: es01

% esami_lab richiede visita_id e tipo_esame_id (FK). Dopo l’init: visita 1 = Giulia;
% tipo_esame_id 6 = Ferritina (ordine di inserimento nel catalogo).
comandoInsert = [ ...
    'INSERT INTO esami_lab (visita_id, tipo_esame_id, valore, unita, data_risultato) ' ...
    'VALUES (1, 6, 85, ''ng/mL'', ''2025-05-01'')' ...
    ];

execute(conn, comandoInsert);

verifica = fetch(conn, [ ...
    'SELECT e.*, t.nome AS nome_esame FROM esami_lab e ' ...
    'JOIN tipi_esame t ON t.id = e.tipo_esame_id ' ...
    'WHERE t.codice = ''FERR''' ...
    ]);

close(conn);

disp('Righe Ferritina dopo l''inserimento:');
disp(verifica);
