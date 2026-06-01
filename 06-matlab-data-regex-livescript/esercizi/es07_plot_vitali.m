% Esercizio 7 - Grafici MATLAB
% Obiettivo: creare 3 grafici con formattazione minima completa.

baseDir = fileparts(fileparts(mfilename('fullpath')));
csvPath = fullfile(baseDir, 'dati', 'pazienti_lab6.csv');
T = readtable(csvPath);

% TODO 1: line plot BPM (con title/xlabel/ylabel)

% TODO 2: bar plot sistolica (con title/xlabel/ylabel)

% TODO 3: scatter spo2 vs eta (con title/xlabel/ylabel)
