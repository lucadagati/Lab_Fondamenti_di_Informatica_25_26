% Esercizio 5: conteggio valori >= 140 con for annidati
% TODO: completare il codice

pressioni = [
    130, 142, 138, 150;
    125, 128, 132, 135;
    145, 148, 151, 139
];

contatore = 0;

% TODO: due cicli for annidati su righe e colonne
for r = 1:size(pressioni, 1)
    for c = 1:size(pressioni, 2)
        % TODO
    end
end

fprintf('Numero misure >= 140: %d\n', contatore);
