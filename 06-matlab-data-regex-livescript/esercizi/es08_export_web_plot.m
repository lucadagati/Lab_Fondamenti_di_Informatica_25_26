% Esercizio 8 - Export grafico per il Web
% Obiettivo: esportare una figura in PNG/SVG e opzionale HTML.

baseDir = fileparts(fileparts(mfilename('fullpath')));
csvPath = fullfile(baseDir, 'dati', 'pazienti_lab6.csv');
outDir = fullfile(baseDir, 'dati');
T = readtable(csvPath);

figure;
bar(T.bpm);
title('BPM per paziente');
xlabel('Indice paziente');
ylabel('BPM');

% TODO 1: salva in PNG con saveas

% TODO 2: salva in SVG con saveas

% TODO 3 (opzionale): se fig2plotly esiste, esporta in HTML offline
