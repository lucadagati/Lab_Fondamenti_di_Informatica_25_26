% Soluzione esercizio 6: istogramma categorie BMI

% Definiamo un vettore di BMI.
bmi = [17.2, 21.0, 24.8, 26.4, 31.1, 28.7, 19.3, 33.0];

% Inizializziamo contatore Sottopeso.
c_sotto = 0;
% Inizializziamo contatore Normopeso.
c_normo = 0;
% Inizializziamo contatore Sovrappeso.
c_sovra = 0;
% Inizializziamo contatore Obesita.
c_obes = 0;

% Scorriamo tutti i valori BMI.
for i = 1:length(bmi)
    % Leggiamo il valore corrente.
    valore = bmi(i);
    % Se e sotto 18.5 incrementiamo Sottopeso.
    if valore < 18.5
        c_sotto = c_sotto + 1;
    % Altrimenti se e sotto 25 incrementiamo Normopeso.
    elseif valore < 25
        c_normo = c_normo + 1;
    % Altrimenti se e sotto 30 incrementiamo Sovrappeso.
    elseif valore < 30
        c_sovra = c_sovra + 1;
    % Negli altri casi incrementiamo Obesita.
    else
        c_obes = c_obes + 1;
    end
end

% Stampiamo il conteggio Sottopeso.
fprintf('Sottopeso: %d
', c_sotto);
% Stampiamo il conteggio Normopeso.
fprintf('Normopeso: %d
', c_normo);
% Stampiamo il conteggio Sovrappeso.
fprintf('Sovrappeso: %d
', c_sovra);
% Stampiamo il conteggio Obesita.
fprintf('Obesita: %d
', c_obes);
