% 4. Normalizzare date
data = '15-03-2024';  % assegna il risultato a data
normalizzata = regexprep(data, '(\d+)-(\d+)-(\d+)', '$3/$2/$1');  % sostituisce pattern nel testo
% '2024/03/15'
