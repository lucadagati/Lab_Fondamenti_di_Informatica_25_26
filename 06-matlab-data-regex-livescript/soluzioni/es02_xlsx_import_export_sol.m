% Soluzione 2 - XLSX: import/export
baseDir = fileparts(fileparts(mfilename('fullpath')));
xlsxPath = fullfile(baseDir, 'dati', 'pazienti_lab6.xlsx');
outPath = fullfile(baseDir, 'dati', 'pazienti_lab6_classificato.xlsx');

% 1) Lettura file Excel
T = readtable(xlsxPath);

% 2) Preallocazione colonna classe
classe = strings(height(T),1);

% 3) Classificazione riga per riga
for i = 1:height(T)
    s = T.sistolica(i);
    if s < 130
        classe(i) = "Normale";
    elseif s < 140
        classe(i) = "Pre-ipertensione";
    else
        classe(i) = "Ipertensione";
    end
end

% 4) Aggiunta colonna e salvataggio
T.classe_pressione = classe;
writetable(T, outPath);

% 5) Controllo output
disp(T)
