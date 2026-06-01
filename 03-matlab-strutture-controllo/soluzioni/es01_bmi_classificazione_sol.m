% Soluzione esercizio 1: BMI con if/elseif/else

% Chiediamo all'utente il peso in chilogrammi.
peso = input('Inserisci peso (kg): ');
% Chiediamo all'utente l'altezza in metri.
altezza = input('Inserisci altezza (m): ');

% Calcoliamo il BMI con la formula standard: peso / altezza^2.
bmi = peso / (altezza^2);

% Se il BMI e minore di 18.5, la categoria e Sottopeso.
if bmi < 18.5
    % Assegniamo l'etichetta della categoria.
    categoria = 'Sottopeso';
% Altrimenti, se il BMI e minore di 25, la categoria e Normopeso.
elseif bmi < 25
    % Assegniamo l'etichetta della categoria.
    categoria = 'Normopeso';
% Altrimenti, se il BMI e minore di 30, la categoria e Sovrappeso.
elseif bmi < 30
    % Assegniamo l'etichetta della categoria.
    categoria = 'Sovrappeso';
% In tutti gli altri casi, la categoria e Obesita.
else
    % Assegniamo l'etichetta della categoria.
    categoria = 'Obesita';
end

% Stampiamo BMI (con due decimali) e categoria finale.
fprintf('BMI = %.2f -> %s
', bmi, categoria);
