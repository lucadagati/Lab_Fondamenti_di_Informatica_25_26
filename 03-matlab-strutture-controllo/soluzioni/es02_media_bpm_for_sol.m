% Soluzione esercizio 2: media e massimo BPM con for

% Definiamo un vettore di BPM di esempio.
bpm = [72, 85, 90, 78, 110, 95, 88];

% Inizializziamo la somma dei valori a zero.
somma = 0;
% Inizializziamo il massimo a -inf per garantire il primo aggiornamento.
massimo = -inf;

% Scorriamo il vettore dall'indice 1 all'ultimo indice.
for i = 1:length(bpm)
    % Leggiamo il valore corrente del vettore.
    valore = bpm(i);
    % Aggiorniamo la somma aggiungendo il valore corrente.
    somma = somma + valore;
    % Verifichiamo se il valore corrente e maggiore del massimo attuale.
    if valore > massimo
        % Aggiorniamo il massimo con il nuovo valore.
        massimo = valore;
    end
end

% Calcoliamo la media dividendo somma per numero elementi.
media = somma / length(bpm);

% Stampiamo la media con due decimali.
fprintf('Media BPM: %.2f
', media);
% Stampiamo il massimo con due decimali.
fprintf('Massimo BPM: %.2f
', massimo);
