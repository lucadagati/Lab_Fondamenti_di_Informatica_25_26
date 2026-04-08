% Soluzione 2 - XLSX
baseDir = fileparts(fileparts(mfilename('fullpath')));
xlsxPath = fullfile(baseDir, 'dati', 'pazienti_lab6.xlsx');
outPath = fullfile(baseDir, 'dati', 'pazienti_lab6_classificato.xlsx');

T = readtable(xlsxPath);
classe = strings(height(T),1);

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

T.classe_pressione = classe;
writetable(T, outPath);
disp(T)
