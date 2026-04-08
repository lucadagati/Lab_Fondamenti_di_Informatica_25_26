% Esercizio 6 - Live Script dashboard
% Obiettivo: convertire in .mlx e costruire una mini dashboard.
% Richiesto nel Live Script:
% 1) titolo e testo introduttivo
% 2) tabella dati
% 3) grafico BPM per paziente
% 4) grafico SpO2 vs sistolica
% 5) breve commento finale

baseDir = fileparts(fileparts(mfilename('fullpath')));
csvPath = fullfile(baseDir, 'dati', 'pazienti_lab6.csv');
T = readtable(csvPath);

disp(T)

% TODO: aggiungi grafico 1 (bar BPM)
% TODO: aggiungi grafico 2 (scatter SpO2 vs sistolica)
