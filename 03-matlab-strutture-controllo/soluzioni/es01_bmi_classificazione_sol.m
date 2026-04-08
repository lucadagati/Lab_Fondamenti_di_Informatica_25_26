% Soluzione esercizio 1: BMI con if/elseif/else

peso = input('Inserisci peso (kg): ');
altezza = input('Inserisci altezza (m): ');

bmi = peso / (altezza^2);

if bmi < 18.5
    categoria = 'Sottopeso';
elseif bmi < 25
    categoria = 'Normopeso';
elseif bmi < 30
    categoria = 'Sovrappeso';
else
    categoria = 'Obesita';
end

fprintf('BMI = %.2f -> %s\n', bmi, categoria);
