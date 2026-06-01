% ESERCIZIO 8 — ON DELETE CASCADE: se togli il paziente, spariscono i suoi esami
%
% Schema a catena: visite REFERENCES pazienti ON DELETE CASCADE; esami_lab REFERENCES
% visite ON DELETE CASCADE. DELETE su pazienti elimina le sue visite e quindi i risultati.
%
% Glossario: es01. COUNT(*) in SQL conta le righe; AS n dà nome alla colonna del risultato.

cartellaScript = fileparts(mfilename('fullpath'));
cartellaLab = fileparts(cartellaScript);
addpath(fullfile(cartellaLab, 'codice'));

run(fullfile(cartellaLab, 'codice', 'lab07_create_fresh_database.m'));
percorsoDb = dbPath;
conn = sqlite(percorsoDb);
execute(conn, 'PRAGMA foreign_keys=ON;');  % necessario anche per ON DELETE CASCADE

prima = fetch(conn, [ ...
    'SELECT COUNT(*) AS n FROM esami_lab e ' ...
    'JOIN visite v ON v.id = e.visita_id WHERE v.paziente_id = 1;' ...
    ]);
disp('--- Esami legati al paziente id=1 (tramite visite) prima del DELETE ---');
disp(prima.n(1));

execute(conn, 'DELETE FROM pazienti WHERE id = 1;');

dopo = fetch(conn, [ ...
    'SELECT COUNT(*) AS n FROM esami_lab e ' ...
    'JOIN visite v ON v.id = e.visita_id WHERE v.paziente_id = 1;' ...
    ]);
disp('--- Stesso conteggio dopo il DELETE (CASCADE su visite ed esami → 0) ---');
disp(dopo.n(1));

close(conn);
