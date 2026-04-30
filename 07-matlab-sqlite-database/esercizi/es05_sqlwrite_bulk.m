% ESERCIZIO 5 — Inserire più righe con sqlwrite
%
% Obiettivo: costruire una table MATLAB e copiarla nel DB senza scrivere INSERT a mano.
%
% sqlwrite(conn, nomeTabellaDb, tableMatlab) : aggiunge in coda alla tabella SQL le righe
%     della table MATLAB. I nomi delle colonne della table devono coincidere con il DB.

cartellaScript = fileparts(mfilename('fullpath'));
cartellaLab = fileparts(cartellaScript);
addpath(fullfile(cartellaLab, 'codice'));

run(fullfile(cartellaLab, 'codice', 'lab07_create_fresh_database.m'));
percorsoDb = dbPath;
conn = sqlite(percorsoDb);
execute(conn, 'PRAGMA foreign_keys=ON;');  % glossario: es01

% Visita id 14 = Marco Bianchi (paziente 2), data 2025-06-12. tipo_esame_id: 5=LDH, 4=PCR.
nuoveRighe = table( ...
    [14; 14], ...                      % visita_id (stessa visita, due test)
    [5; 4], ...                        % tipo_esame_id (LDH, PCR)
    [230; 0.4], ...                    % valore
    {'U/L'; 'mg/dL'}, ...              % unita
    {'2025-06-12'; '2025-06-12'}, ...  % data_risultato
    'VariableNames', {'visita_id', 'tipo_esame_id', 'valore', 'unita', 'data_risultato'} ...
    );

sqlwrite(conn, 'esami_lab', nuoveRighe);

queryVerifica = [ ...
    'SELECT e.*, t.codice, t.nome FROM esami_lab e ' ...
    'JOIN tipi_esame t ON t.id = e.tipo_esame_id ' ...
    'WHERE e.visita_id = 14 AND t.codice IN (''LDH'', ''PCR'') ' ...
    'ORDER BY t.codice' ...
    ];
dopoInsert = fetch(conn, queryVerifica);

close(conn);

disp('Esami LDH e PCR per il paziente 2:');
disp(dopoInsert);
