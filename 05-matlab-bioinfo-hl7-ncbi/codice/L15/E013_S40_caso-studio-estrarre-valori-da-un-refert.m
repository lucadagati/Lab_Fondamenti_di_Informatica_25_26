referto = ['Esami del 15/03/2024. Glicemia: 95 mg/dL (v.n. 70-100). ' ...  % definisce il testo referto di esempio (prima parte)
           'Colesterolo totale: 210 mg/dL. Emoglobina: 14.2 g/dL. ' ...  % concatena la seconda parte del testo
           'Pressione: 120/80 mmHg.'];  % concatena la terza parte e chiude la stringa completa

% Estrarre la glicemia
pattern_glicemia = 'Glicemia:\s*(\d+)\s*mg/dL';  % definisce regex per valore numerico della glicemia
glicemiaTok = regexp(referto, pattern_glicemia, 'tokens', 'once');  % estrae il primo match come token singolo
if ~isempty(glicemiaTok)  % verifica che il match della glicemia esista
    fprintf('Glicemia: %s mg/dL
', glicemiaTok{1});  % stampa il valore trovato (es. 95)
else  % gestisce il caso in cui non venga trovata la glicemia
    fprintf('Glicemia non trovata nel testo.
');  % stampa messaggio diagnostico
end  % chiude il controllo sul token glicemia

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
