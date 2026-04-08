% Crea un file XLSX a partire dal CSV di esempio.
% Esegui questo file una volta sola se manca .xlsx.

csvPath = fullfile(fileparts(mfilename('fullpath')), 'pazienti_lab6.csv');
xlsxPath = fullfile(fileparts(mfilename('fullpath')), 'pazienti_lab6.xlsx');

T = readtable(csvPath);
writetable(T, xlsxPath);

disp(['Creato file: ' xlsxPath]);
