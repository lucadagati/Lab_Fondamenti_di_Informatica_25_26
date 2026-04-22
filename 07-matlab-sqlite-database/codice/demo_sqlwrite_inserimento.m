% DEMO — sqlwrite: da table MATLAB a riga nel database
%
% Glossario: es01_apri_db_sqlread.m. sqlwrite = inserimento da table senza scrivere INSERT a mano.

cartellaScript = fileparts(mfilename('fullpath'));
cartellaLab = fileparts(cartellaScript);
addpath(fullfile(cartellaLab, 'codice'));

percorsoDb = lab07_create_fresh_database(cartellaLab);
conn = sqlite(percorsoDb);
execute(conn, 'PRAGMA foreign_keys=ON;');

riga = table( ...
    3, {'Creatinina'}, 97.0, {'umol/L'}, {'2025-04-20'}, ...
    'VariableNames', {'paziente_id', 'nome_esame', 'valore', 'unita', 'data_esame'} ...
    );

sqlwrite(conn, 'esami_lab', riga);

controllo = fetch(conn, 'SELECT * FROM esami_lab WHERE nome_esame = ''Creatinina''');
disp('Dopo sqlwrite:');
disp(controllo);

close(conn);
