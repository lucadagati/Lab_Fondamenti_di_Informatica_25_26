% ESERCIZIO 9 — Transazione: SAVEPOINT … ROLLBACK annulla tutto insieme
%
% SAVEPOINT apre una “finestra” di lavoro anche se il driver MATLAB/SQLite ha già
% una transazione interna aperta. ROLLBACK TO annulla tutto fino al savepoint.
% Qui inseriamo paziente + visita + risultato lab e poi annulliamo tutto.
%
% last_insert_rowid() è una funzione SQLite: dopo un INSERT su pazienti, restituisce
% l id auto-generato dell ultima riga inserita su questa connessione.
%
% sprintf in MATLAB costruisce una stringa sostituendo %d con un numero (qui idPaz).

cartellaScript = fileparts(mfilename('fullpath'));
cartellaLab = fileparts(cartellaScript);
addpath(fullfile(cartellaLab, 'codice'));

run(fullfile(cartellaLab, 'codice', 'lab07_create_fresh_database.m'));
percorsoDb = dbPath;
conn = sqlite(percorsoDb);
execute(conn, 'PRAGMA foreign_keys=ON;');  % glossario: es01

cognomeTest = 'SoloTransazione';

n0 = fetch(conn, ['SELECT COUNT(*) AS n FROM pazienti WHERE cognome = ''' cognomeTest ''';']);
disp('--- Conteggio pazienti con cognome di test (prima, atteso 0) ---');
disp(n0.n(1));

execute(conn, 'SAVEPOINT lab07_transazione;');

execute(conn, [ ...
    'INSERT INTO pazienti (nome, cognome, anno_nascita, sesso, reparto_id) ' ...
    'VALUES (''NomeTemp'', ''' cognomeTest ''', 2000, ''X'', NULL)' ...
    ]);

idNuovo = fetch(conn, 'SELECT last_insert_rowid() AS ultimo_id;');
idPaz = idNuovo.ultimo_id(1);

sqlVisita = sprintf([ ...
    'INSERT INTO visite (paziente_id, medico_id, data_visita, motivo) ' ...
    'VALUES (%d, 1, ''2025-06-01'', ''temp transazione'')' ...
    ], idPaz);
execute(conn, sqlVisita);

idVis = fetch(conn, 'SELECT last_insert_rowid() AS ultimo_id;');
idVisita = idVis.ultimo_id(1);

sqlEsame = sprintf([ ...
    'INSERT INTO esami_lab (visita_id, tipo_esame_id, valore, unita, data_risultato) ' ...
    'VALUES (%d, 1, 1.0, ''mg/dL'', ''2025-06-01'')' ...
    ], idVisita);
execute(conn, sqlEsame);

execute(conn, 'ROLLBACK TO lab07_transazione;');
execute(conn, 'RELEASE lab07_transazione;');

n1 = fetch(conn, ['SELECT COUNT(*) AS n FROM pazienti WHERE cognome = ''' cognomeTest ''';']);
disp('--- Stesso conteggio dopo ROLLBACK (atteso ancora 0) ---');
disp(n1.n(1));

close(conn);
