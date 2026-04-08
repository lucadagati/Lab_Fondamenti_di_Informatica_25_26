% Soluzione 7 - Grafici
baseDir = fileparts(fileparts(mfilename('fullpath')));
csvPath = fullfile(baseDir, 'dati', 'pazienti_lab6.csv');
T = readtable(csvPath);

figure;
plot(T.bpm, '-o', 'LineWidth', 1.2);
title('Trend BPM');
xlabel('Indice paziente');
ylabel('BPM');

figure;
bar(T.sistolica);
title('Sistolica per paziente');
xlabel('Indice paziente');
ylabel('mmHg');

figure;
scatter(T.spo2, T.eta, 70, 'filled');
title('SpO2 vs Eta');
xlabel('SpO2');
ylabel('Eta');
