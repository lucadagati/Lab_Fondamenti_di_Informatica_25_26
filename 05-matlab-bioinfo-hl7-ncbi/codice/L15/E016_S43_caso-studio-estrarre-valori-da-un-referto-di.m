% Estrarre tutti i valori con unità
pattern_valori = '(\d+\.?\d*)\s*(mg/dL|g/dL|mmHg)';  % definisce regex per numero + unità clinica
valori = regexp(referto, pattern_valori, 'tokens');  % raccoglie tutti i match valore-unità presenti nel testo

disp(valori)  % mostra tutte le coppie valore-unità estratte dal referto
