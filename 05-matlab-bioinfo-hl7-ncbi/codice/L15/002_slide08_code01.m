%% Sezione 1: Caricamento dati
% Senza file: usa una tabella di esempio. Con CSV reale: readtable('pazienti.csv')
data = table([30; 45; 60; 72], 'VariableNames', {'Eta'});  % crea una tabella in memoria

%% Sezione 2: Analisi
media = mean(data.Eta);  % calcola la media dei valori
fprintf('Età media: %.1f anni\n', media);

%% Sezione 3: Visualizzazione
histogram(data.Eta);  % mostra la distribuzione con istogramma
xlabel('Età'); ylabel('Frequenza');  % imposta etichetta asse x
