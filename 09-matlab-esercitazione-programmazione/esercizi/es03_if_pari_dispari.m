% ES 3 - Classificazione completa di un intero
% Testo (ben spiegato): dato un numero intero n, classificare:
% 1) segno (positivo, negativo, zero),
% 2) parita (pari/dispari, con caso speciale per zero),
% 3) fascia di grandezza in valore assoluto (piccolo, medio, grande).
% Fasce suggerite: |n| <= 10 piccolo, |n| <= 50 medio, altrimenti grande.
% Stampare il risultato in un'unica frase riassuntiva.
% Implementazione consigliata:
% 1) Delegare segno, parita e fascia a funzioni locali dedicate.
% 2) Usare if/elseif/else dentro ogni funzione locale.
% 3) Evitare abs usando una funzione locale valore_assoluto.
% 4) Comporre l'output finale con fprintf.

n = -37;                                                  % Imposta un numero di prova che puo essere cambiato liberamente.

segno = classifica_segno(n);                              % Richiama la funzione locale che classifica il segno del numero.
parita = classifica_parita(n);                            % Richiama la funzione locale che classifica la parita del numero.
fascia = classifica_fascia(n);                            % Richiama la funzione locale che classifica la grandezza assoluta.

fprintf("n=%d -> segno:%s, parita:%s, fascia:%s\n", n, segno, parita, fascia); % Stampa la classificazione completa in formato compatto.

function segno = classifica_segno(n)                      % Definisce una funzione locale che classifica il segno di n.
    if n > 0                                              % Controlla se il numero e strettamente positivo.
        segno = "positivo";                              % Restituisce etichetta positivo.
    elseif n < 0                                          % Controlla se il numero e strettamente negativo.
        segno = "negativo";                              % Restituisce etichetta negativo.
    else                                                  % Gestisce il caso residuo in cui n e uguale a zero.
        segno = "zero";                                  % Restituisce etichetta zero.
    end                                                   % Chiude il blocco di classificazione del segno.
end                                                       % Chiude la funzione locale classifica_segno.

function parita = classifica_parita(n)                    % Definisce una funzione locale che classifica la parita di n.
    if n == 0                                             % Controlla il caso speciale in cui il numero e zero.
        parita = "neutro";                               % Restituisce etichetta neutro per il valore nullo.
    elseif mod(n, 2) == 0                                 % Verifica divisibilita esatta per 2.
        parita = "pari";                                 % Restituisce etichetta pari quando il resto e zero.
    else                                                  % Gestisce il caso in cui il resto della divisione per 2 e non nullo.
        parita = "dispari";                              % Restituisce etichetta dispari.
    end                                                   % Chiude il blocco di classificazione della parita.
end                                                       % Chiude la funzione locale classifica_parita.

function fascia = classifica_fascia(n)                    % Definisce una funzione locale che classifica n in base al valore assoluto.
    valore_assoluto = valore_assoluto_manuale(n);         % Calcola il valore assoluto tramite funzione locale dedicata.
    if valore_assoluto <= 10                              % Controlla se il valore assoluto rientra nella fascia piccola.
        fascia = "piccolo";                              % Restituisce la fascia piccola.
    elseif valore_assoluto <= 50                          % Controlla se il valore assoluto rientra nella fascia media.
        fascia = "medio";                                % Restituisce la fascia media.
    else                                                  % Gestisce il caso residuo sopra 50.
        fascia = "grande";                               % Restituisce la fascia grande.
    end                                                   % Chiude il blocco di classificazione della fascia.
end                                                       % Chiude la funzione locale classifica_fascia.

function a = valore_assoluto_manuale(n)                   % Definisce una funzione locale che calcola il valore assoluto senza abs.
    if n < 0                                              % Controlla se il numero e negativo.
        a = -n;                                           % Inverte il segno per ottenere il valore assoluto.
    else                                                  % Gestisce il caso in cui il numero e gia non negativo.
        a = n;                                            % Mantiene il valore invariato.
    end                                                   % Chiude il controllo per il calcolo del valore assoluto.
end                                                       % Chiude la funzione locale valore_assoluto_manuale.
