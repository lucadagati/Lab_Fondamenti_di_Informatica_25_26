% Esercizio 1 - CSV: lettura, filtro, scrittura
% Obiettivo: creare un CSV con soli pazienti a rischio.
% Rischio se almeno una condizione e vera:
% - bpm >= 100
% - spo2 < 95
% - sistolica >= 140

baseDir = fileparts(fileparts(mfilename('fullpath')));
csvPath = fullfile(baseDir, 'dati', 'pazienti_lab6.csv');
outPath = fullfile(baseDir, 'dati', 'pazienti_rischio.csv');

% TODO 1: leggi la tabella dal CSV
% T = readtable(csvPath);

% TODO 2: costruisci la condizione logica di rischio
% cond = ...

% TODO 3: filtra le righe e salva in una nuova tabella
% T_rischio = T(cond, :);

% TODO 4: scrivi il file CSV di output
% writetable(T_rischio, outPath);

% TODO 5: visualizza il risultato con disp
