% Soluzione 6 - Live Script (eseguibile anche come .m)
baseDir = fileparts(fileparts(mfilename('fullpath')));
csvPath = fullfile(baseDir, 'dati', 'pazienti_lab6.csv');
T = readtable(csvPath);

disp(T)

figure;
bar(T.bpm);
title('BPM per paziente');
xlabel('Indice paziente');
ylabel('BPM');

figure;
scatter(T.spo2, T.sistolica, 60, 'filled');
title('Relazione SpO2 vs Sistolica');
xlabel('SpO2');
ylabel('Sistolica');
