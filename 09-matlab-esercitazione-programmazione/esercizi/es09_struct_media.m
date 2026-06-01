% ES 9 - Array di struct, media e selezione multi-criterio
% Testo (ben spiegato): creare un array di 5 studenti con campi
% nome, voto e presenze (percentuale). Calcolare media voti e media
% presenze con cicli for. Selezionare gli studenti "idonei" con criterio:
% voto >= media_voti e presenze >= 75.
% Stampare medie, elenco idonei e nome dello studente con voto massimo.
% Implementazione consigliata:
% 1) Costruire l'array di struct con i tre campi richiesti.
% 2) Delegare il calcolo delle medie a una funzione locale.
% 3) Delegare filtro idonei e ricerca massimo a funzioni locali.
% 4) Stampare risultati sintetici e struct finale degli idonei.

studenti(1) = struct("nome", "Luca", "voto", 24, "presenze", 80);   % Crea il primo studente con voto e presenze.
studenti(2) = struct("nome", "Marta", "voto", 29, "presenze", 92);  % Crea il secondo studente con voto e presenze.
studenti(3) = struct("nome", "Piero", "voto", 18, "presenze", 70);  % Crea il terzo studente con voto e presenze.
studenti(4) = struct("nome", "Anna", "voto", 30, "presenze", 98);   % Crea il quarto studente con voto e presenze.
studenti(5) = struct("nome", "Sara", "voto", 26, "presenze", 76);   % Crea il quinto studente con voto e presenze.

media_voti = media_campo(studenti, "voto");                % Calcola la media del campo voto tramite funzione locale.
media_presenze = media_campo(studenti, "presenze");        % Calcola la media del campo presenze tramite funzione locale.

idonei = [];                                                % Inizializza un array vuoto che conterra solo studenti idonei.
voto_massimo = -inf;                                        % Inizializza il massimo voto a meno infinito come sentinella.
nome_voto_massimo = "";                                    % Inizializza una stringa vuota per il nome del massimo.

for i = 1:length(studenti)                                  % Scorre di nuovo gli studenti per filtro e ricerca massimo.
    if studente_idoneo(studenti(i), media_voti, 75)         % Verifica idoneita richiamando una funzione locale dedicata.
        idonei = [idonei, studenti(i)];                     % Aggiunge lo studente corrente all'array idonei quando passa il filtro.
    end                                                     % Chiude il blocco di controllo sull'idoneita.
    [voto_massimo, nome_voto_massimo] = aggiorna_massimo_voto(studenti(i), voto_massimo, nome_voto_massimo); % Aggiorna massimo e nome tramite funzione locale.
end                                                         % Chiude il ciclo di filtro e ricerca.

fprintf("Media voti=%.2f, Media presenze=%.2f\n", media_voti, media_presenze); % Stampa le due medie aggregate.
fprintf("Studente con voto massimo: %s (%d)\n", nome_voto_massimo, voto_massimo); % Stampa il nome e il valore del voto massimo.
disp(idonei);                                               % Mostra l'array di struct con i soli studenti idonei.

function media = media_campo(studenti, nome_campo)          % Definisce una funzione locale che calcola la media di un campo numerico della struct array.
    somma = 0;                                              % Inizializza l'accumulatore della somma per il campo richiesto.
    for i = 1:length(studenti)                              % Scorre tutti gli elementi dell'array studenti.
        somma = somma + studenti(i).(nome_campo);           % Aggiunge alla somma il valore del campo richiesto nello studente corrente.
    end                                                     % Chiude il ciclo di accumulo sui valori del campo.
    media = somma / length(studenti);                       % Calcola la media dividendo per il numero totale di studenti.
end                                                         % Chiude la funzione locale media_campo.

function ok = studente_idoneo(studente, media_voti, soglia_presenze) % Definisce una funzione locale che verifica il criterio di idoneita.
    ok = studente.voto >= media_voti && studente.presenze >= soglia_presenze; % Restituisce vero solo se entrambi i vincoli sono rispettati.
end                                                         % Chiude la funzione locale studente_idoneo.

function [voto_max_agg, nome_max_agg] = aggiorna_massimo_voto(studente, voto_max, nome_max) % Definisce una funzione locale che aggiorna massimo voto e nome associato.
    voto_max_agg = voto_max;                                % Inizializza l'uscita voto massimo con il valore in ingresso.
    nome_max_agg = nome_max;                                % Inizializza l'uscita nome massimo con il valore in ingresso.
    if studente.voto > voto_max                             % Controlla se il voto dello studente corrente supera il massimo attuale.
        voto_max_agg = studente.voto;                       % Aggiorna il voto massimo con il voto corrente.
        nome_max_agg = studente.nome;                       % Aggiorna il nome massimo con il nome corrente.
    end                                                     % Chiude il controllo di aggiornamento del massimo voto.
end                                                         % Chiude la funzione locale aggiorna_massimo_voto.
