% Soluzione esercizio 8: alert pressione per paziente

pressioni = [
    130, 142, 138;
    145, 151, 149;
    120, 125, 118;
    139, 141, 137
];

for p = 1:size(pressioni, 1)
    anomalie = 0;
    for k = 1:size(pressioni, 2)
        if pressioni(p, k) >= 140
            anomalie = anomalie + 1;
        end
    end

    if anomalie == 0
        livello = 'Basso';
    elseif anomalie == 1
        livello = 'Medio';
    else
        livello = 'Alto';
    end

    fprintf('Paziente %d -> anomalie: %d, alert: %s\n', p, anomalie, livello);
end
