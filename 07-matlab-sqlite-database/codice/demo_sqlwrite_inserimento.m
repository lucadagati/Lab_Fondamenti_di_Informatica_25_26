% demo_sqlwrite_inserimento — ricrea il DB, inserisce una riga con sqlwrite, verifica con fetch

thisDir = fileparts(mfilename('fullpath'));
labDir = fileparts(thisDir);
addpath(fullfile(labDir, 'codice'));
dbPath = lab07_create_fresh_database(labDir);

conn = sqlite(dbPath);

Nuovo = table( ...
    3, {'Creatinina'}, 97.0, {'umol/L'}, {'2025-04-20'}, ...
    'VariableNames', {'paziente_id', 'nome_esame', 'valore', 'unita', 'data_esame'} ...
    );

sqlwrite(conn, 'esami_lab', Nuovo);

T_check = fetch(conn, 'SELECT * FROM esami_lab WHERE nome_esame = ''Creatinina'';');
disp('--- dopo sqlwrite ---');
disp(T_check);

close(conn);
