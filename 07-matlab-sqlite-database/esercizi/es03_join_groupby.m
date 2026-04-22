% Esercizio 3 — JOIN e aggregazione
% Obiettivo: per ogni paziente, contare quante misurazioni ha in esami_lab (alias: n_esami).

thisDir = fileparts(mfilename('fullpath'));
labDir = fileparts(thisDir);
dbPath = fullfile(labDir, 'dati', 'lab07_biomed.db');

% TODO 1: conn = sqlite(dbPath);

% TODO 2: scrivere una query con JOIN pazienti/esami_lab e GROUP BY paziente (o p.id)
% Suggerimento: SELECT p.id, p.cognome, COUNT(e.id) AS n_esami FROM ...

% TODO 3: T = fetch(conn, q); close(conn); disp(T);
