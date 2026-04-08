% Esercizio 8 - Export grafico per il Web (approccio semplice + opzionale)
% TODO: salvare figura in PNG e SVG.
% Opzionale: se disponibile fig2plotly, esportare in HTML.

baseDir = fileparts(fileparts(mfilename('fullpath')));
csvPath = fullfile(baseDir, 'dati', 'pazienti_lab6.csv');
outDir = fullfile(baseDir, 'dati');
T = readtable(csvPath);

figure;
bar(T.bpm);
title('BPM per paziente');
xlabel('Indice paziente');
ylabel('BPM');

% TODO: saveas(gcf, fullfile(outDir,'bpm_plot.png'))
% TODO: saveas(gcf, fullfile(outDir,'bpm_plot.svg'))
% TODO opzionale: fig2plotly(gcf,'offline',true,'filename',fullfile(outDir,'bpm_plot_web'))

