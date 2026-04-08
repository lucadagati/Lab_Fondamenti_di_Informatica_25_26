% Esercizio 8 - Export grafico per il Web
% Obiettivo: esportare una figura in PNG/SVG e creare opzionalmente
% una piccola pagina HTML locale che mostra il grafico esportato.

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

% TODO 3 (opzionale): crea un file HTML locale che includa bpm_plot.png
% Suggerimento:
%   htmlPath = fullfile(outDir, 'bpm_plot_web.html');
%   fid = fopen(htmlPath, 'w');
%   fprintf(fid, '<html><body><h1>BPM Plot</h1><img src=\"bpm_plot.png\"></body></html>');
%   fclose(fid);
