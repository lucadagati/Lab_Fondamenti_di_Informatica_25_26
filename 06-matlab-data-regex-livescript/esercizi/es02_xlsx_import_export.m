% Esercizio 2 - XLSX: import/export
% TODO: leggere XLSX, aggiungere colonna classe_pressione, riscrivere XLSX

baseDir = fileparts(fileparts(mfilename('fullpath')));
xlsxPath = fullfile(baseDir, 'dati', 'pazienti_lab6.xlsx');
outPath = fullfile(baseDir, 'dati', 'pazienti_lab6_classificato.xlsx');

% TODO: T = readtable(xlsxPath)
% TODO: creare classe pressione (Normale, Pre-ipertensione, Ipertensione)
% TODO: scrivere tabella in outPath

