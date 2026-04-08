% Soluzione 1 - CSV: lettura, filtro, scrittura
baseDir = fileparts(fileparts(mfilename('fullpath')));
csvPath = fullfile(baseDir, 'dati', 'pazienti_lab6.csv');
outPath = fullfile(baseDir, 'dati', 'pazienti_rischio.csv');

% 1) Lettura tabella dal CSV
T = readtable(csvPath);

% 2) Regola di rischio (OR logico)
cond = (T.bpm >= 100) | (T.spo2 < 95) | (T.sistolica >= 140);

% 3) Filtro righe
T_rischio = T(cond, :);

% 4) Scrittura CSV di output
writetable(T_rischio, outPath);

% 5) Visualizzazione finale
disp(T_rischio)
