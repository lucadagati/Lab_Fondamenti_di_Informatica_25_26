% ESERCIZIO 4 — Inserire una riga con execute (comando SQL INSERT)
%
% Obiettivo: aggiungere un esame scrivendo l’INSERT a mano come stringa.
%
% execute(conn, sql) : per INSERT/UPDATE/DELETE non serve fetch: execute invia il comando
%                      e non restituisce righe. Per controllare dopo, usi fetch con un SELECT.

cartellaScript = fileparts(mfilename('fullpath'));
cartellaLab = fileparts(cartellaScript);
addpath(fullfile(cartellaLab, 'codice'));

percorsoDb = lab07_create_fresh_database(cartellaLab);
conn = sqlite(percorsoDb);
execute(conn, 'PRAGMA foreign_keys=ON;');  % glossario: es01

% Stringa SQL completa: INSERT INTO … VALUES (…). Numeri senza apici; testi con ''…''.
comandoInsert = [ ...
    'INSERT INTO esami_lab (paziente_id, nome_esame, valore, unita, data_esame) ' ...
    'VALUES (1, ''Ferritina'', 85, ''ng/mL'', ''2025-05-01'')' ...
    ];

execute(conn, comandoInsert);

% Dopo una scrittura, spesso si verifica con un SELECT (qui fetch)
verifica = fetch(conn, 'SELECT * FROM esami_lab WHERE nome_esame = ''Ferritina''');

close(conn);

disp('Righe Ferritina dopo l''inserimento:');
disp(verifica);
