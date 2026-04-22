% DEMO — Inserire una riga con sqlwrite e controllare con fetch
%
% Mostra come passare da una piccola table MATLAB a una nuova riga SQL.

cartellaScript = fileparts(mfilename('fullpath'));
cartellaLab = fileparts(cartellaScript);
addpath(fullfile(cartellaLab, 'codice'));

percorsoDb = lab07_create_fresh_database(cartellaLab);
conn = sqlite(percorsoDb);

% Una sola riga da inserire: nomi colonne = colonne del database
riga = table( ...
    3, {'Creatinina'}, 97.0, {'umol/L'}, {'2025-04-20'}, ...
    'VariableNames', {'paziente_id', 'nome_esame', 'valore', 'unita', 'data_esame'} ...
    );

sqlwrite(conn, 'esami_lab', riga);

controllo = fetch(conn, 'SELECT * FROM esami_lab WHERE nome_esame = ''Creatinina''');
disp('Dopo sqlwrite:');
disp(controllo);

close(conn);
