% demo_sqlwrite_inserimento — inserire righe da una table MATLAB in SQLite
%
% Prerequisito: database creato con init_lab07_database.m

thisDir = fileparts(mfilename('fullpath'));
labDir = fileparts(thisDir);
dbPath = fullfile(labDir, 'dati', 'lab07_biomed.db');

conn = sqlite(dbPath);

% Nuova riga come table MATLAB (nomi colonne = nomi colonne DB)
Nuovo = table( ...
    3, {'Creatinina'}, 97.0, {'umol/L'}, {'2025-04-20'}, ...
    'VariableNames', {'paziente_id', 'nome_esame', 'valore', 'unita', 'data_esame'} ...
    );

sqlwrite(conn, 'esami_lab', Nuovo);

T_check = fetch(conn, 'SELECT * FROM esami_lab WHERE nome_esame = ''Creatinina'';');
disp('--- dopo sqlwrite ---');
disp(T_check);

close(conn);
