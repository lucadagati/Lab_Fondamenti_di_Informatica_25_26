% Soluzione 7 - Grafici MATLAB
baseDir = fileparts(fileparts(mfilename('fullpath')));
csvPath = fullfile(baseDir, 'dati', 'pazienti_lab6.csv');
T = readtable(csvPath);

% 1) Line plot BPM
figure;
plot(T.bpm, '-o', 'LineWidth', 1.2);
title('Trend BPM');
xlabel('Indice paziente');
ylabel('BPM');

% 2) Bar plot sistolica
figure;
bar(T.sistolica);
title('Sistolica per paziente');
xlabel('Indice paziente');
ylabel('mmHg');

% 3) Scatter SpO2 vs eta
figure;
scatter(T.spo2, T.eta, 70, 'filled');
title('SpO2 vs Eta');
xlabel('SpO2');
ylabel('Eta');
