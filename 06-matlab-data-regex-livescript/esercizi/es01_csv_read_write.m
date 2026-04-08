% Esercizio 1 - CSV: lettura, filtro e scrittura
% TODO: leggere CSV, filtrare pazienti a rischio, scrivere nuovo CSV

baseDir = fileparts(fileparts(mfilename('fullpath')));
csvPath = fullfile(baseDir, 'dati', 'pazienti_lab6.csv');
outPath = fullfile(baseDir, 'dati', 'pazienti_rischio.csv');

% TODO: T = readtable(csvPath)
% TODO: condizione rischio: bpm >= 100 OR spo2 < 95 OR sistolica >= 140
% TODO: T_rischio = T(condizione, :)
% TODO: writetable(T_rischio, outPath)

