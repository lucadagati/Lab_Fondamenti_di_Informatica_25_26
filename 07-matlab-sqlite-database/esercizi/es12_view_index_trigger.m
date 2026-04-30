% ESERCIZIO 12 — VIEW, INDEX e TRIGGER
%
% Obiettivo: usare tre strumenti SQL evoluti spesso citati nella progettazione DB.

cartellaScript = fileparts(mfilename('fullpath'));
cartellaLab = fileparts(cartellaScript);
addpath(fullfile(cartellaLab, 'codice'));

run(fullfile(cartellaLab, 'codice', 'lab07_create_fresh_database.m'));
percorsoDb = dbPath;
conn = sqlite(percorsoDb);
execute(conn, 'PRAGMA foreign_keys=ON;');

% VIEW: una query salvata con un nome. Non duplica i dati, li presenta in modo comodo.
execute(conn, 'DROP VIEW IF EXISTS v_esami_fuori_range;');
execute(conn, [ ...
    'CREATE VIEW v_esami_fuori_range AS ' ...
    'SELECT * FROM v_esami_completi ' ...
    'WHERE (valore_min IS NOT NULL AND valore < valore_min) ' ...
    'OR (valore_max IS NOT NULL AND valore > valore_max)' ...
    ]);

disp('--- Risultati fuori range letti da una VIEW ---');
disp(fetch(conn, 'SELECT cognome, codice, valore, unita, valore_min, valore_max FROM v_esami_fuori_range ORDER BY cognome, codice;'));

% INDEX: struttura fisica che velocizza ricerche/join frequenti.
% IF NOT EXISTS evita errore se l indice era già stato creato nello script init.
execute(conn, 'CREATE INDEX IF NOT EXISTS idx_esami_tipo_data ON esami_lab(tipo_esame_id, data_risultato);');

disp('--- Piano di esecuzione SQLite per una ricerca su tipo_esame_id ---');
disp(fetch(conn, 'EXPLAIN QUERY PLAN SELECT * FROM esami_lab WHERE tipo_esame_id = 1;'));

% TRIGGER: azione automatica dopo un evento. Qui registriamo aggiornamenti in audit_log.
execute(conn, 'DROP TRIGGER IF EXISTS trg_log_update_esami;');
execute(conn, [ ...
    'CREATE TRIGGER trg_log_update_esami ' ...
    'AFTER UPDATE ON esami_lab ' ...
    'BEGIN ' ...
    'INSERT INTO audit_log (tabella, operazione, riga_id, descrizione) ' ...
    'VALUES (''esami_lab'', ''UPDATE'', NEW.id, ''Aggiornato risultato di laboratorio''); ' ...
    'END;' ...
    ]);

disp('--- Audit log prima dell UPDATE ---');
disp(fetch(conn, 'SELECT * FROM audit_log;'));

execute(conn, 'UPDATE esami_lab SET valore = 109.0 WHERE id = 3;');

disp('--- Audit log dopo UPDATE: il trigger ha inserito una riga ---');
disp(fetch(conn, 'SELECT * FROM audit_log;'));

close(conn);
