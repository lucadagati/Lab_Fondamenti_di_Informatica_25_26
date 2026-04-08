% Esercizio 6 - Live Script: mini dashboard
% Obiettivo: convertire questo script in Live Script (.mlx) e aggiungere:
% 1) titolo e testo descrittivo
% 2) tabella dei dati
% 3) due grafici
% 4) breve commento finale

baseDir = fileparts(fileparts(mfilename('fullpath')));
csvPath = fullfile(baseDir, 'dati', 'pazienti_lab6.csv');
T = readtable(csvPath);

disp(T)

% TODO: grafico 1 (bar dei bpm per paziente)
% TODO: grafico 2 (scatter spo2 vs sistolica)

