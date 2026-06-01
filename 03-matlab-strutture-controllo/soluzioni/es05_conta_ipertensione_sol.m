% Soluzione esercizio 5: conteggio valori >= 140 con for annidati

% Definiamo una matrice di pressioni sistoliche di esempio.
pressioni = [
    130, 142, 138, 150;
    125, 128, 132, 135;
    145, 148, 151, 139
];

% Inizializziamo il contatore dei valori sopra soglia.
contatore = 0;

% Scorriamo ogni riga della matrice.
for r = 1:size(pressioni, 1)
    % Scorriamo ogni colonna della matrice.
    for c = 1:size(pressioni, 2)
        % Verifichiamo se il valore corrente e almeno 140.
        if pressioni(r, c) >= 140
            % Incrementiamo il contatore.
            contatore = contatore + 1;
        end
    end
end

% Stampiamo il numero totale di misure >= 140.
fprintf('Numero misure >= 140: %d
', contatore);
