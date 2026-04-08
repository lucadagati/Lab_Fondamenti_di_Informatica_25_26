% Esercizio 2 - XLSX: import/export con colonna derivata
% Obiettivo: aggiungere una classe pressione a ogni riga.
% Regole:
% - sistolica < 130 -> Normale
% - 130 <= sistolica < 140 -> Pre-ipertensione
% - sistolica >= 140 -> Ipertensione

baseDir = fileparts(fileparts(mfilename('fullpath')));
xlsxPath = fullfile(baseDir, 'dati', 'pazienti_lab6.xlsx');
outPath = fullfile(baseDir, 'dati', 'pazienti_lab6_classificato.xlsx');

% TODO 1: leggi tabella da XLSX

% TODO 2: crea vettore stringhe classe_pressione lungo height(T)

% TODO 3: ciclo for sulle righe e assegna la classe in base a sistolica

% TODO 4: aggiungi colonna classe_pressione alla tabella

% TODO 5: salva tabella su outPath e mostra risultato
