% Esercizio 6: istogramma categorie BMI (for + if)
% TODO: completare il codice

bmi = [17.2, 21.0, 24.8, 26.4, 31.1, 28.7, 19.3, 33.0];

c_sotto = 0;
c_normo = 0;
c_sovra = 0;
c_obes = 0;

for i = 1:length(bmi)
    valore = bmi(i);
    % TODO: aggiornare i contatori in base alle soglie
end

fprintf('Sottopeso: %d\n', c_sotto);
fprintf('Normopeso: %d\n', c_normo);
fprintf('Sovrappeso: %d\n', c_sovra);
fprintf('Obesita: %d\n', c_obes);
