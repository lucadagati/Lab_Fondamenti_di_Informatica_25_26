% 1. Rimuovere spazi multipli
testo = 'Troppi    spazi   nel    testo';  % assegna il risultato a testo
pulito = regexprep(testo, '\s+', ' ');  % sostituisce pattern nel testo
% 'Troppi spazi nel testo'

% 2. Anonimizzare codice fiscale
referto = 'Paziente: Mario Rossi, CF: RSSMRA80A01H501Z';  % assegna il risultato a referto
pattern_cf = '[A-Z]{6}\d{2}[A-Z]\d{2}[A-Z]\d{3}[A-Z]';  % assegna il risultato a pattern_cf
anonimo = regexprep(referto, pattern_cf, '[CF RIMOSSO]');  % sostituisce pattern nel testo

% 3. Formattare numeri di telefono
tel = '3331234567';  % assegna il risultato a tel
formattato = regexprep(tel, '(\d{3})(\d{3})(\d{4})', '$1-$2-$3');  % sostituisce pattern nel testo
% '333-123-4567' ($1, $2, $3 = gruppi catturati)
