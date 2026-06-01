% Esercizio 9: conteggio picchi locali ECG semplificato (for)
% TODO: completare il codice

x = [0.1, 0.4, 0.2, 0.8, 0.3, 0.9, 0.4, 0.2, 0.7, 0.1];
soglia = 0.5;

n_picchi = 0;

for i = 2:length(x)-1
    % TODO: picco locale se x(i) > x(i-1), x(i) > x(i+1), x(i) > soglia
end

fprintf('Numero picchi locali sopra soglia: %d\n', n_picchi);
