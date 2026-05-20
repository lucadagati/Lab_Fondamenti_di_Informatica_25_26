% ES 2 - Vettori, indici e filtri semplici
% Testo (ben spiegato): creare il vettore v = -5:14.
% Estrarre: elementi in posizione pari, elementi in posizione dispari,
% primi 4 elementi, ultimi 4 elementi e soli elementi positivi.
% Calcolare con cicli for: (1) somma degli elementi in posizione pari,
% (2) media dei soli dispari positivi.
% Stampare i sottovettori e i due risultati finali.
% Implementazione consigliata:
% 1) Costruire il vettore base con una funzione locale dedicata.
% 2) Ricavare i sottovettori con slicing a indici.
% 3) Usare un primo ciclo per la somma delle posizioni pari.
% 4) Usare un secondo ciclo con if per filtrare dispari positivi.
% 5) Gestire la media protetta con una funzione locale.

v = genera_progressione_intera(-5, 14);                   % Crea il vettore base con una funzione locale senza usare l'operatore colon.
pari_pos = v(2:2:end);                                    % Estrae i valori che si trovano in posizione pari.
dispari_pos = v(1:2:end);                                 % Estrae i valori che si trovano in posizione dispari.
primi4 = v(1:4);                                          % Seleziona i primi quattro elementi del vettore.
ultimi4 = v(end-3:end);                                   % Seleziona gli ultimi quattro elementi del vettore.
positivi = filtra_positivi(v);                            % Filtra tutti i valori positivi usando una funzione locale con ciclo.

somma_pari_pos = 0;                                       % Inizializza l'accumulatore per la somma delle posizioni pari.
for k = 1:length(pari_pos)                                % Scorre tutti gli elementi presenti nel sottovettore pari_pos.
    somma_pari_pos = somma_pari_pos + pari_pos(k);        % Aggiorna la somma aggiungendo il valore corrente.
end                                                       % Chiude il ciclo di accumulo sui valori in posizione pari.

somma_dispari_positivi = 0;                               % Inizializza la somma dei valori dispari che risultano positivi.
conteggio_dispari_positivi = 0;                           % Inizializza il contatore dei dispari positivi trovati.
for k = 1:length(dispari_pos)                             % Scorre tutti gli elementi in posizione dispari.
    if dispari_pos(k) > 0                                 % Verifica se il valore dispari corrente e positivo.
        somma_dispari_positivi = somma_dispari_positivi + dispari_pos(k); % Aggiunge il valore positivo alla somma dedicata.
        conteggio_dispari_positivi = conteggio_dispari_positivi + 1; % Incrementa il numero di valori utili per la media.
    end                                                    % Chiude il controllo sul segno del valore dispari corrente.
end                                                       % Chiude il ciclo sui valori in posizione dispari.

media_dispari_positivi = media_protetta(somma_dispari_positivi, conteggio_dispari_positivi); % Calcola la media con funzione locale che protegge da divisione per zero.

disp(pari_pos);                                           % Mostra i valori in posizione pari.
disp(dispari_pos);                                        % Mostra i valori in posizione dispari.
disp(primi4);                                             % Mostra i primi quattro elementi.
disp(ultimi4);                                            % Mostra gli ultimi quattro elementi.
disp(positivi);                                           % Mostra il sottovettore dei soli valori positivi.
fprintf("Somma posizioni pari=%d, Media dispari positivi=%.2f\n", somma_pari_pos, media_dispari_positivi); % Stampa i due indicatori richiesti.

function v = genera_progressione_intera(inizio, fine)     % Definisce una funzione locale che crea una progressione intera crescente.
    n = fine - inizio + 1;                                % Calcola quanti elementi devono essere generati tra inizio e fine inclusi.
    v = zeros(1, n);                                      % Prealloca il vettore risultato per evitare riallocazioni nel ciclo.
    for i = 1:n                                           % Scorre tutti gli indici del vettore da riempire.
        v(i) = inizio + (i - 1);                          % Assegna il valore corretto alla posizione i-esima della progressione.
    end                                                   % Chiude il ciclo di generazione della progressione.
end                                                       % Chiude la funzione locale genera_progressione_intera.

function pos = filtra_positivi(v)                         % Definisce una funzione locale che estrae solo i valori positivi da un vettore.
    pos = [];                                             % Inizializza il vettore di output vuoto per i valori positivi trovati.
    for i = 1:length(v)                                   % Scorre tutte le posizioni del vettore di input.
        if v(i) > 0                                       % Controlla se il valore corrente e strettamente positivo.
            pos = [pos, v(i)];                            % Aggiunge il valore positivo corrente in coda al vettore di output.
        end                                               % Chiude il controllo sul segno del valore corrente.
    end                                                   % Chiude il ciclo di filtro dei valori positivi.
end                                                       % Chiude la funzione locale filtra_positivi.

function m = media_protetta(somma, conteggio)            % Definisce una funzione locale che calcola una media evitando divisione per zero.
    if conteggio > 0                                      % Verifica che il numero di elementi sia positivo.
        m = somma / conteggio;                            % Calcola la media nel caso in cui il denominatore sia valido.
    else                                                  % Gestisce il caso in cui non ci siano elementi utili.
        m = NaN;                                          % Restituisce NaN per indicare che la media non e definita.
    end                                                   % Chiude il controllo sul conteggio valido.
end                                                       % Chiude la funzione locale media_protetta.
