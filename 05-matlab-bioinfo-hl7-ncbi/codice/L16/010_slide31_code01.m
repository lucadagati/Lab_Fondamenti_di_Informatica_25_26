% Ipotesi: "data" è una table (righe = pazienti/visite, colonne = variabili)

% Elimina righe che contengono almeno un NaN (perdita di campioni)
data_clean = rmmissing(data);  % assegna il risultato a data_clean

% Elimina colonne troppo "bucate" (es. variabili inutilizzabili per il modello)
threshold = 0.30;   % soglia massima frazione di NaN ammissibile per colonna
nanRatio = sum(ismissing(data), 1) ./ height(data);  % ismissing copre NaN e <undefined>
keep = nanRatio < threshold;  % assegna il risultato a keep
data = data(:, keep);  % assegna il risultato a data
