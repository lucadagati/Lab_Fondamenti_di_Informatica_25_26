% Soluzione esercizio 4: priorita con switch

codice = input('Inserisci codice priorita (1,2,3): ');

switch codice
    case 1
        disp('Priorita Alta');
    case 2
        disp('Priorita Media');
    case 3
        disp('Priorita Bassa');
    otherwise
        disp('Codice non valido');
end
