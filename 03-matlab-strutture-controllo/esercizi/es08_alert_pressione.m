% Esercizio 8: alert pressione per paziente (for annidato + switch/if)
% TODO: completare il codice

pressioni = [
    130, 142, 138;
    145, 151, 149;
    120, 125, 118;
    139, 141, 137
];

% Regola alert in base al numero di misure >= 140 per paziente:
% 0 -> Basso, 1 -> Medio, >=2 -> Alto

for p = 1:size(pressioni, 1)
    anomalie = 0;
    for k = 1:size(pressioni, 2)
        % TODO: contare anomalie
    end

    % TODO: mappare anomalie in livello alert e stampare
end
