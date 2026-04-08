% Soluzione 8 - Export grafico web
baseDir = fileparts(fileparts(mfilename('fullpath')));
csvPath = fullfile(baseDir, 'dati', 'pazienti_lab6.csv');
outDir = fullfile(baseDir, 'dati');
T = readtable(csvPath);

% 1) Crea grafico
figure;
bar(T.bpm);
title('BPM per paziente');
xlabel('Indice paziente');
ylabel('BPM');

% 2) Export in PNG e SVG
saveas(gcf, fullfile(outDir,'bpm_plot.png'));
saveas(gcf, fullfile(outDir,'bpm_plot.svg'));

% 3) Export opzionale con Plotly (se installato)
if exist('fig2plotly','file') == 2
    fig2plotly(gcf,'offline',true,'filename',fullfile(outDir,'bpm_plot_web'));
end
