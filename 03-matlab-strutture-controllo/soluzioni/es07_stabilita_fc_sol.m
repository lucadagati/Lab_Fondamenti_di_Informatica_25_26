% Soluzione esercizio 7: primo tratto stabile della frequenza cardiaca

fc = [120, 110, 102, 98, 96, 94, 108, 99, 97, 95];

i = 1;
indice_stabile = -1;

while i <= length(fc) - 2
    c1 = fc(i) >= 60 && fc(i) <= 100;
    c2 = fc(i+1) >= 60 && fc(i+1) <= 100;
    c3 = fc(i+2) >= 60 && fc(i+2) <= 100;

    if c1 && c2 && c3
        indice_stabile = i;
        break;
    end
    i = i + 1;
end

fprintf('Primo indice stabile: %d\n', indice_stabile);
