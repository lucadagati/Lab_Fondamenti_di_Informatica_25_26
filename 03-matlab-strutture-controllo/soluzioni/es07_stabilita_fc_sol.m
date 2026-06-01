% Soluzione esercizio 7: primo tratto stabile della frequenza cardiaca

% Definiamo un vettore di frequenze cardiache.
fc = [120, 110, 102, 98, 96, 94, 108, 99, 97, 95];

% Inizializziamo l'indice di scansione.
i = 1;
% Impostiamo indice_stabile a -1 come valore di "non trovato".
indice_stabile = -1;

% Scorriamo finche esiste una tripla consecutiva completa.
while i <= length(fc) - 2
    % Controllo range per il primo valore della tripla.
    c1 = fc(i) >= 60 && fc(i) <= 100;
    % Controllo range per il secondo valore della tripla.
    c2 = fc(i+1) >= 60 && fc(i+1) <= 100;
    % Controllo range per il terzo valore della tripla.
    c3 = fc(i+2) >= 60 && fc(i+2) <= 100;

    % Se tutti e tre i controlli sono veri, abbiamo trovato il primo tratto stabile.
    if c1 && c2 && c3
        % Salviamo l'indice di inizio tratto stabile.
        indice_stabile = i;
        % Usiamo break per fermarci al primo match.
        break;
    end
    % Passiamo all'indice successivo.
    i = i + 1;
end

% Stampiamo l'indice trovato (oppure -1 se assente).
fprintf('Primo indice stabile: %d
', indice_stabile);
