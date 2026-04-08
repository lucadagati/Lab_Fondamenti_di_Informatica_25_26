% Esercizio 7: primo tratto stabile della frequenza cardiaca (while)
% TODO: completare il codice

fc = [120, 110, 102, 98, 96, 94, 108, 99, 97, 95];

% Obiettivo: trovare il primo indice i tale che fc(i), fc(i+1), fc(i+2)
% siano tutti nel range [60, 100]. Se non esiste, indice_stabile = -1.

i = 1;
indice_stabile = -1;

while i <= length(fc) - 2
    % TODO: controllare tripla consecutiva
    i = i + 1;
end

fprintf('Primo indice stabile: %d\n', indice_stabile);
