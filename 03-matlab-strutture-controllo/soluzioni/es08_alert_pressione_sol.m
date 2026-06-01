% Soluzione esercizio 8: alert pressione per paziente

% Definiamo matrice pressioni (righe = pazienti, colonne = misure).
pressioni = [
    130, 142, 138;
    145, 151, 149;
    120, 125, 118;
    139, 141, 137
];

% Scorriamo i pazienti (una riga alla volta).
for p = 1:size(pressioni, 1)
    % Azzeriamo conteggio anomalie per il paziente corrente.
    anomalie = 0;

    % Scorriamo le misure del paziente corrente.
    for k = 1:size(pressioni, 2)
        % Se la misura supera o uguaglia la soglia, incrementiamo anomalie.
        if pressioni(p, k) >= 140
            anomalie = anomalie + 1;
        end
    end

    % Se anomalie e 0, alert basso.
    if anomalie == 0
        livello = 'Basso';
    % Se anomalie e 1, alert medio.
    elseif anomalie == 1
        livello = 'Medio';
    % Se anomalie e 2 o piu, alert alto.
    else
        livello = 'Alto';
    end

    % Stampiamo riepilogo per paziente.
    fprintf('Paziente %d -> anomalie: %d, alert: %s
', p, anomalie, livello);
end
