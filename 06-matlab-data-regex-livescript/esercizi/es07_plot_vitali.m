% Esercizio 7 - Rappresentazione grafica
% TODO: produrre 3 grafici (line, bar, scatter) con etichette e titolo

baseDir = fileparts(fileparts(mfilename('fullpath')));
csvPath = fullfile(baseDir, 'dati', 'pazienti_lab6.csv');
T = readtable(csvPath);

% TODO: line plot bpm
% TODO: bar plot sistolica
% TODO: scatter spo2 vs eta

