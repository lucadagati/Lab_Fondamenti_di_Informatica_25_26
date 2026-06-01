% Pattern per data DD/MM/YYYY
pat = digitsPattern(2) + "/" + digitsPattern(2) + "/" + digitsPattern(4);  % assegna il risultato a pat

testo = "Nato il 15/03/1990, visitato il 20/01/2024";  % assegna il risultato a testo
date = extract(testo, pat)  % assegna il risultato a date
% ["15/03/1990", "20/01/2024"]

% Pattern per codice paziente (3 lettere + 4 cifre)
codicePat = lettersPattern(3) + digitsPattern(4);  % assegna il risultato a codicePat
extract("Paziente PAZ0042", codicePat)  % "PAZ0042"
