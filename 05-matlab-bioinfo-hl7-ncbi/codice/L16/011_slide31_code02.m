% fillmissing: adatto a dati ordinati (serie) o per colonna in table

% Media per colonna (semplice; ragionevole solo se MCAR e distribuzione simmetrica)
data = fillmissing(data, 'mean');  % assegna il risultato a data

% Interpolazione lineare lungo le righe (serie temporali campionate regolarmente)
data = fillmissing(data, 'linear');  % assegna il risultato a data

% k-NN imputation (Bioinformatics Toolbox). Alternativa: knn imputation manuale / MICE
% data = knnimpute(data', k)';   % traspone se la funzione richiede variabili per riga
