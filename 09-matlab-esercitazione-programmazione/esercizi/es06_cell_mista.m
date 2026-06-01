% ES 6 - Simulazione coda ticket helpdesk (informatica pratica)
% Testo: gestire una coda FIFO di ticket usando cell array di struct.
% Ogni ticket ha: id, utente, priorita, stato.
% Obiettivi:
% 1) Inserire 4 ticket in coda.
% 2) Estrarre e "risolvere" i primi 2 ticket (FIFO).
% 3) Stampare ticket risolti e ticket rimasti in coda.

coda = {};                                                 % Coda FIFO inizialmente vuota.
prossimo_id = 1;                                           % Contatore ID progressivo.

coda = enqueue_ticket(coda, crea_ticket(prossimo_id, "alice", "media", "aperto"));
prossimo_id = prossimo_id + 1;
coda = enqueue_ticket(coda, crea_ticket(prossimo_id, "bob", "alta", "aperto"));
prossimo_id = prossimo_id + 1;
coda = enqueue_ticket(coda, crea_ticket(prossimo_id, "carla", "bassa", "aperto"));
prossimo_id = prossimo_id + 1;
coda = enqueue_ticket(coda, crea_ticket(prossimo_id, "david", "alta", "aperto"));

risolti = {};                                              % Collezione ticket completati.

for k = 1:2
    [ticket, coda] = dequeue_ticket(coda);
    ticket.stato = "chiuso";
    risolti{end + 1} = ticket; %#ok<AGROW>
end

disp("Ticket risolti:");
for i = 1:numel(risolti)
    t = risolti{i};
    fprintf("  #%d utente=%s priorita=%s stato=%s\n", t.id, t.utente, t.priorita, t.stato);
end

disp("Ticket rimasti in coda:");
for i = 1:numel(coda)
    t = coda{i};
    fprintf("  #%d utente=%s priorita=%s stato=%s\n", t.id, t.utente, t.priorita, t.stato);
end

function ticket = crea_ticket(id, utente, priorita, stato)
    ticket.id = id;
    ticket.utente = utente;
    ticket.priorita = priorita;
    ticket.stato = stato;
end

function coda = enqueue_ticket(coda, ticket)
    coda{end + 1} = ticket;
end

function [ticket, coda] = dequeue_ticket(coda)
    if isempty(coda)
        error("Coda vuota");
    end
    ticket = coda{1};
    coda(1) = [];
end
