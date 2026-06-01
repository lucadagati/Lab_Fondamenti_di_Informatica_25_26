% Soluzione 6 - Live Script dashboard
% Nota: questo file .m puo essere convertito in .mlx dal menu MATLAB.

baseDir = fileparts(fileparts(mfilename('fullpath')));
csvPath = fullfile(baseDir, 'dati', 'pazienti_lab6.csv');
T = readtable(csvPath);

% Sezione 1: tabella
disp(T)

% Sezione 2: grafico bar BPM
figure;
bar(T.bpm);
title('BPM per paziente');
xlabel('Indice paziente');
ylabel('BPM');

% Sezione 3: scatter SpO2 vs sistolica
figure;
scatter(T.spo2, T.sistolica, 60, 'filled');
title('Relazione SpO2 vs Sistolica');
xlabel('SpO2');
ylabel('Sistolica');
