% Soluzione esercizio 4: priorita con switch

% Chiediamo il codice priorita all'utente.
codice = input('Inserisci codice priorita (1,2,3): ');

% Usiamo switch per gestire i diversi codici.
switch codice
    % Caso codice 1.
    case 1
        % Stampiamo priorita alta.
        disp('Priorita Alta');
    % Caso codice 2.
    case 2
        % Stampiamo priorita media.
        disp('Priorita Media');
    % Caso codice 3.
    case 3
        % Stampiamo priorita bassa.
        disp('Priorita Bassa');
    % Tutti i casi non previsti.
    otherwise
        % Stampiamo messaggio di codice non valido.
        disp('Codice non valido');
end
