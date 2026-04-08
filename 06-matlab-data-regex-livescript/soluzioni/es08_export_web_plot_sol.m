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

% 3) Creazione opzionale di una pagina HTML locale
%    (senza dipendenze esterne) che incorpora l'immagine PNG.
htmlPath = fullfile(outDir, 'bpm_plot_web.html');
fid = fopen(htmlPath, 'w');
if fid ~= -1
    fprintf(fid, '<html><head><meta charset=\"UTF-8\"></head><body>');
    fprintf(fid, '<h1>BPM per paziente</h1>');
    fprintf(fid, '<p>Grafico esportato da MATLAB.</p>');
    fprintf(fid, '<img src=\"bpm_plot.png\" alt=\"BPM plot\" style=\"max-width:800px;\">');
    fprintf(fid, '</body></html>');
    fclose(fid);
end
