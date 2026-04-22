% ESERCIZIO 8 — Cancellazione a cascata (ON DELETE CASCADE)
%
% Nello schema, esami_lab ha: REFERENCES pazienti(id) ON DELETE CASCADE.
% Se elimini un paziente, tutte le sue righe in esami_lab vengono eliminate
% automaticamente: il database resta coerente (niente esami senza paziente).

cartellaScript = fileparts(mfilename('fullpath'));
cartellaLab = fileparts(cartellaScript);
addpath(fullfile(cartellaLab, 'codice'));

percorsoDb = lab07_create_fresh_database(cartellaLab);
conn = sqlite(percorsoDb);
execute(conn, 'PRAGMA foreign_keys=ON;');

% --- Prima: quanti esami sono legati al paziente con id = 1? ----------------
prima = fetch(conn, 'SELECT COUNT(*) AS n FROM esami_lab WHERE paziente_id = 1;');
disp('--- Esami per paziente_id = 1 (prima della cancellazione) ---');
disp(prima.n(1));

% --- Cancelliamo il paziente 1 (Giulia) ---------------------------------------
execute(conn, 'DELETE FROM pazienti WHERE id = 1;');

% --- Dopo: gli esami di quel paziente non devono più esistere ----------------
dopo = fetch(conn, 'SELECT COUNT(*) AS n FROM esami_lab WHERE paziente_id = 1;');
disp('--- Esami per paziente_id = 1 (dopo DELETE sul paziente) ---');
disp(dopo.n(1));

disp('Se il secondo numero è 0, la CASCADE ha mantenuto la coerenza tra le tabelle.');

close(conn);
