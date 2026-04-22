% Estrarre la data (formato GG/MM/AAAA)
pattern_data = '(\d{2})/(\d{2})/(\d{4})';  % definisce regex per data nel formato giorno/mese/anno
dataTok = regexp(referto, pattern_data, 'tokens', 'once');  % estrae la prima data come cella di tre token
if ~isempty(dataTok)  % verifica che la data sia stata trovata
    fprintf('Data: %s/%s/%s
', dataTok{:});  % stampa la data ricostruita dai tre gruppi
else  % gestisce il caso in cui non sia presente una data valida
    fprintf('Data non trovata nel testo.
');  % stampa messaggio diagnostico
end  % chiude il controllo sul token data
