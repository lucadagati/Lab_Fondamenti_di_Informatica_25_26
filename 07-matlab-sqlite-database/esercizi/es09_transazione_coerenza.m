% ESERCIZIO 9 — Transazione e coerenza “tutto o niente”
%
% BEGIN … COMMIT applica tutte le modifiche insieme; ROLLBACK le annulla tutte.
% Esempio: inseriamo un paziente temporaneo e un suo esame, poi facciamo ROLLBACK:
% al termine non deve restare traccia (come se non fosse mai successo).

cartellaScript = fileparts(mfilename('fullpath'));
cartellaLab = fileparts(cartellaScript);
addpath(fullfile(cartellaLab, 'codice'));

percorsoDb = lab07_create_fresh_database(cartellaLab);
conn = sqlite(percorsoDb);
execute(conn, 'PRAGMA foreign_keys=ON;');

cognomeTest = 'SoloTransazione';

% --- Stato iniziale: nessuna riga con questo cognome --------------------------
n0 = fetch(conn, ['SELECT COUNT(*) AS n FROM pazienti WHERE cognome = ''' cognomeTest ''';']);
disp('--- Pazienti con cognome di test (prima): deve essere 0 ---');
disp(n0.n(1));

% --- Apriamo una transazione e inseriamo dati coerenti tra loro ---------------
execute(conn, 'BEGIN TRANSACTION;');
execute(conn, [ ...
    'INSERT INTO pazienti (nome, cognome, anno_nascita, sesso) ' ...
    'VALUES (''NomeTemp'', ''' cognomeTest ''', 2000, ''X'')' ...
    ]);

% last_insert_rowid() restituisce l id appena assegnato al nuovo paziente
idNuovo = fetch(conn, 'SELECT last_insert_rowid() AS ultimo_id;');
idPaz = idNuovo.ultimo_id(1);

sqlEsame = sprintf([ ...
    'INSERT INTO esami_lab (paziente_id, nome_esame, valore, unita, data_esame) ' ...
    'VALUES (%d, ''EsameTemp'', 1.0, ''u'', ''2025-06-01'')' ...
    ], idPaz);
execute(conn, sqlEsame);

% --- Annullo tutto: paziente ed esame spariscono insieme ----------------------
execute(conn, 'ROLLBACK;');

% --- Verifica: ancora nessuna riga con quel cognome ---------------------------
n1 = fetch(conn, ['SELECT COUNT(*) AS n FROM pazienti WHERE cognome = ''' cognomeTest ''';']);
disp('--- Pazienti con cognome di test (dopo ROLLBACK): deve restare 0 ---');
disp(n1.n(1));

disp('Se entrambi i conteggi sono 0, la transazione ha preservato la coerenza globale del DB.');

close(conn);
