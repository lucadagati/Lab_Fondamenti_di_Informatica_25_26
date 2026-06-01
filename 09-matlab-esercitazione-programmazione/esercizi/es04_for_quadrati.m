% ES 4 - Ciclo for con due accumuli e soglia cumulata
% Testo (ben spiegato): considerare i primi N interi positivi (N=20)
% e calcolare con un solo ciclo for:
% 1) somma dei quadrati,
% 2) somma dei cubi,
% 3) primo indice k in cui la somma cumulata dei quadrati supera 1000.
% Stampare totale quadrati, media quadrati, totale cubi e k di soglia.
% Implementazione consigliata:
% 1) Inizializzare accumuli e variabile indice_soglia.
% 2) Nel ciclo usare una funzione locale per calcolare potenze intere.
% 3) Usare una funzione locale per fissare la prima soglia superata.
% 4) Calcolare la media fuori dal ciclo e stampare tutto.

limite = 20;                                              % Definisce quanti interi positivi includere nel calcolo.
somma_quadrati = 0;                                      % Inizializza l'accumulatore della somma dei quadrati.
somma_cubi = 0;                                          % Inizializza l'accumulatore della somma dei cubi.
soglia = 1000;                                           % Definisce la soglia da superare con la somma cumulata dei quadrati.
indice_soglia = -1;                                      % Imposta un valore sentinella che indica soglia non ancora superata.

for k = 1:limite                                          % Esegue un ciclo dai primi interi 1 fino a limite.
    quadrato_k = potenza_intera(k, 2);                   % Calcola il quadrato di k con una funzione locale basata su moltiplicazioni.
    cubo_k = potenza_intera(k, 3);                       % Calcola il cubo di k con la stessa funzione locale generalizzata.
    somma_quadrati = somma_quadrati + quadrato_k;        % Aggiorna la somma dei quadrati con il valore appena calcolato.
    somma_cubi = somma_cubi + cubo_k;                    % Aggiorna la somma dei cubi con il valore appena calcolato.
    indice_soglia = aggiorna_prima_soglia(somma_quadrati, soglia, indice_soglia, k); % Aggiorna l'indice soglia solo alla prima occorrenza valida.
end                                                      % Chiude il ciclo for su tutti i valori.

media_quadrati = somma_quadrati / limite;                % Calcola la media aritmetica dei quadrati.
fprintf("SommaQ=%d, MediaQ=%.2f, SommaCubi=%d, PrimoKoltreSoglia=%d\n", somma_quadrati, media_quadrati, somma_cubi, indice_soglia); % Stampa i risultati principali in formato sintetico.

function p = potenza_intera(base, esponente)             % Definisce una funzione locale che calcola base^esponente senza operatore potenza.
    p = 1;                                               % Inizializza il prodotto al valore neutro della moltiplicazione.
    for i = 1:esponente                                  % Ripete la moltiplicazione tante volte quanto vale l'esponente.
        p = p * base;                                    % Aggiorna il prodotto moltiplicando per la base a ogni iterazione.
    end                                                  % Chiude il ciclo di calcolo della potenza intera.
end                                                      % Chiude la funzione locale potenza_intera.

function indice_out = aggiorna_prima_soglia(somma, soglia, indice_in, k) % Definisce una funzione locale per fissare la prima soglia superata.
    indice_out = indice_in;                              % Copia l'indice in ingresso come valore di default in uscita.
    if somma > soglia && indice_in == -1                % Verifica se la soglia e superata per la prima volta.
        indice_out = k;                                  % Aggiorna l'indice di uscita con la posizione corrente del ciclo.
    end                                                  % Chiude il controllo di prima occorrenza soglia.
end                                                      % Chiude la funzione locale aggiorna_prima_soglia.
