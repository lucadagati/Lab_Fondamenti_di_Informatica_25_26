% Esercizio 2 — fetch e filtro WHERE
% Obiettivo: selezionare tutte le misurazioni di glicemia con valore >= 100 mg/dL.

thisDir = fileparts(mfilename('fullpath'));
labDir = fileparts(thisDir);
dbPath = fullfile(labDir, 'dati', 'lab07_biomed.db');

% TODO 1: aprire conn = sqlite(dbPath);

% TODO 2: costruire la stringa SQL (attenzione alle virgolette singole in SQL: '' per apostrofo)
% q = 'SELECT ... FROM esami_lab WHERE nome_esame = ''Glicemia'' AND valore >= 100;';

% TODO 3: T = fetch(conn, q);

% TODO 4: close(conn); disp(T);
