% ES 5 - While su prodotto con motivazione di arresto
% Testo (ben spiegato): calcolare il prodotto progressivo 1*2*3*...
% finche il valore resta sotto una soglia target (500).
% Aggiungere due vincoli extra: soglia di sicurezza massima (20000)
% e numero massimo di iterazioni (12) per evitare cicli troppo lunghi.
% Stampare prodotto finale, numero di fattori usati e motivo di stop.
% Implementazione consigliata:
% 1) Inizializzare contatore, prodotto e limiti (target/sicurezza/max iter).
% 2) Delegare la condizione while a una funzione locale dedicata.
% 3) Delegare il motivo di arresto a una seconda funzione locale.
% 4) Stampare tutte le informazioni di controllo.

contatore = 1;                                            % Inizializza il fattore corrente da moltiplicare.
prodotto = 1;                                             % Inizializza il prodotto cumulato all'elemento neutro.
target = 500;                                             % Definisce la soglia principale richiesta dall'esercizio.
sicurezza = 20000;                                        % Definisce la soglia di sicurezza contro crescita eccessiva.
max_iter = 12;                                            % Definisce il numero massimo di fattori da usare.

while deve_continuare(prodotto, contatore, target, sicurezza, max_iter) % Continua finche la funzione locale conferma condizioni valide.
    prodotto = prodotto * contatore;                      % Moltiplica il prodotto cumulato per il fattore corrente.
    contatore = contatore + 1;                            % Passa al fattore successivo incrementando il contatore.
end                                                       % Chiude il ciclo quando almeno una condizione non e piu soddisfatta.

motivo_stop = determina_motivo_stop(prodotto, contatore, target, sicurezza, max_iter); % Determina il motivo finale tramite funzione locale.

fprintf("Prodotto=%g, FattoriUsati=%d, Stop=%s\n", prodotto, contatore - 1, motivo_stop); % Stampa risultato e diagnostica del ciclo.

function ok = deve_continuare(prodotto, contatore, target, sicurezza, max_iter) % Definisce una funzione locale che valuta la condizione di prosecuzione.
    ok = prodotto < target && prodotto < sicurezza && contatore <= max_iter; % Restituisce vero solo se tutte le condizioni di validita sono rispettate.
end                                                       % Chiude la funzione locale deve_continuare.

function motivo = determina_motivo_stop(prodotto, contatore, target, sicurezza, max_iter) % Definisce una funzione locale che classifica il motivo di arresto.
    if prodotto >= target                                 % Controlla se il prodotto ha raggiunto o superato la soglia target.
        motivo = "raggiunta soglia target";              % Restituisce il motivo di arresto associato al target.
    elseif prodotto >= sicurezza                          % Controlla se il prodotto ha raggiunto o superato la soglia di sicurezza.
        motivo = "raggiunta soglia di sicurezza";        % Restituisce il motivo di arresto associato alla sicurezza.
    elseif contatore > max_iter                           % Controlla se il contatore ha superato il massimo numero di iterazioni.
        motivo = "raggiunto numero massimo iterazioni";  % Restituisce il motivo di arresto associato al limite iterativo.
    else                                                  % Gestisce eventuali casi residui non previsti esplicitamente.
        motivo = "arresto non classificato";             % Restituisce una motivazione generica di fallback.
    end                                                   % Chiude il blocco di classificazione del motivo di arresto.
end                                                       % Chiude la funzione locale determina_motivo_stop.
