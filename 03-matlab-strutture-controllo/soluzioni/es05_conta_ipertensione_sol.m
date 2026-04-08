% Soluzione esercizio 5: conteggio valori >= 140 con for annidati

pressioni = [
    130, 142, 138, 150;
    125, 128, 132, 135;
    145, 148, 151, 139
];

contatore = 0;

for r = 1:size(pressioni, 1)
    for c = 1:size(pressioni, 2)
        if pressioni(r, c) >= 140
            contatore = contatore + 1;
        end
    end
end

fprintf('Numero misure >= 140: %d\n', contatore);
