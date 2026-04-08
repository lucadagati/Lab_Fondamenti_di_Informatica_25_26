% Soluzione esercizio 6: istogramma categorie BMI

bmi = [17.2, 21.0, 24.8, 26.4, 31.1, 28.7, 19.3, 33.0];

c_sotto = 0;
c_normo = 0;
c_sovra = 0;
c_obes = 0;

for i = 1:length(bmi)
    valore = bmi(i);
    if valore < 18.5
        c_sotto = c_sotto + 1;
    elseif valore < 25
        c_normo = c_normo + 1;
    elseif valore < 30
        c_sovra = c_sovra + 1;
    else
        c_obes = c_obes + 1;
    end
end

fprintf('Sottopeso: %d\n', c_sotto);
fprintf('Normopeso: %d\n', c_normo);
fprintf('Sovrappeso: %d\n', c_sovra);
fprintf('Obesita: %d\n', c_obes);
