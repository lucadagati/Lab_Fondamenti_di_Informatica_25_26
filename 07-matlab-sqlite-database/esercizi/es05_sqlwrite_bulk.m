% Esercizio 5 — sqlwrite da table MATLAB
% Obiettivo: costruire in MATLAB una table con 2 righe di esami per paziente_id = 2
% e inserirle in blocco con sqlwrite nella tabella esami_lab.

thisDir = fileparts(mfilename('fullpath'));
labDir = fileparts(thisDir);
dbPath = fullfile(labDir, 'dati', 'lab07_biomed.db');

% TODO 1: conn = sqlite(dbPath);

% TODO 2: costruire T con colonne paziente_id, nome_esame, valore, unita, data_esame
% (esempio: LDH 230 U/L e PCR 0.4 mg/dL, data coerente)

% TODO 3: sqlwrite(conn, 'esami_lab', T);

% TODO 4: leggere con fetch le righe appena inserite (filtro su paziente_id = 2 e nome_esame IN (...))

% TODO 5: close(conn); disp(...);
