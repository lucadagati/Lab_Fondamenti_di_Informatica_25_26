% Soluzione 8 - Export web plot
baseDir = fileparts(fileparts(mfilename('fullpath')));
csvPath = fullfile(baseDir, 'dati', 'pazienti_lab6.csv');
outDir = fullfile(baseDir, 'dati');
T = readtable(csvPath);

figure;
bar(T.bpm);
title('BPM per paziente');
xlabel('Indice paziente');
ylabel('BPM');

saveas(gcf, fullfile(outDir,'bpm_plot.png'));
saveas(gcf, fullfile(outDir,'bpm_plot.svg'));

% Export opzionale con Plotly (se installato)
if exist('fig2plotly','file') == 2
    fig2plotly(gcf,'offline',true,'filename',fullfile(outDir,'bpm_plot_web'));
end
