% Soluzione 1 - CSV
baseDir = fileparts(fileparts(mfilename('fullpath')));
csvPath = fullfile(baseDir, 'dati', 'pazienti_lab6.csv');
outPath = fullfile(baseDir, 'dati', 'pazienti_rischio.csv');

T = readtable(csvPath);
cond = (T.bpm >= 100) | (T.spo2 < 95) | (T.sistolica >= 140);
T_rischio = T(cond, :);

writetable(T_rischio, outPath);
disp(T_rischio)
