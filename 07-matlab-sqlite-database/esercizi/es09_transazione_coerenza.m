% ESERCIZIO 9 — Transazione: BEGIN … ROLLBACK annulla tutto insieme
%
% BEGIN TRANSACTION (o BEGIN) apre una “finestra”: le modifiche sono provvisorie.
% ROLLBACK le annulla tutte; COMMIT le renderebbe permanenti. Qui usiamo ROLLBACK
% per mostrare che paziente + esame inseriti nella stessa transazione spariscono entrambi.
%
% last_insert_rowid() è una funzione SQLite: dopo un INSERT su pazienti, restituisce
% l id auto-generato dell ultima riga inserita su questa connessione.
%
% sprintf in MATLAB costruisce una stringa sostituendo %d con un numero (qui idPaz).

cartellaScript = fileparts(mfilename('fullpath'));
cartellaLab = fileparts(cartellaScript);
addpath(fullfile(cartellaLab, 'codice'));

percorsoDb = lab07_create_fresh_database(cartellaLab);
conn = sqlite(percorsoDb);
execute(conn, 'PRAGMA foreign_keys=ON;');  % glossario: es01

cognomeTest = 'SoloTransazione';

n0 = fetch(conn, ['SELECT COUNT(*) AS n FROM pazienti WHERE cognome = ''' cognomeTest ''';']);
disp('--- Conteggio pazienti con cognome di test (prima, atteso 0) ---');
disp(n0.n(1));

execute(conn, 'BEGIN TRANSACTION;');

execute(conn, [ ...
    'INSERT INTO pazienti (nome, cognome, anno_nascita, sesso) ' ...
    'VALUES (''NomeTemp'', ''' cognomeTest ''', 2000, ''X'')' ...
    ]);

idNuovo = fetch(conn, 'SELECT last_insert_rowid() AS ultimo_id;');
idPaz = idNuovo.ultimo_id(1);

sqlEsame = sprintf([ ...
    'INSERT INTO esami_lab (paziente_id, nome_esame, valore, unita, data_esame) ' ...
    'VALUES (%d, ''EsameTemp'', 1.0, ''u'', ''2025-06-01'')' ...
    ], idPaz);
execute(conn, sqlEsame);

execute(conn, 'ROLLBACK;');

n1 = fetch(conn, ['SELECT COUNT(*) AS n FROM pazienti WHERE cognome = ''' cognomeTest ''';']);
disp('--- Stesso conteggio dopo ROLLBACK (atteso ancora 0) ---');
disp(n1.n(1));

close(conn);
