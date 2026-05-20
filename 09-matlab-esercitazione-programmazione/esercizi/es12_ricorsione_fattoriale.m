% ES 12 - Ricorsione: fattoriale e Fibonacci
% Testo (ben spiegato): dato n=6, calcolare:
% 1) n! con funzione ricorsiva,
% 2) n! con ciclo iterativo,
% 3) il numero di Fibonacci F(n) con una seconda funzione ricorsiva.
% Verificare che i due fattoriali coincidano e stampare tutti i risultati.
% Implementazione consigliata:
% 1) Scrivere prima il flusso principale con chiamate funzione.
% 2) Implementare fattoriale ricorsivo con caso base k<=1.
% 3) Implementare Fibonacci ricorsivo con casi base k<=1.
% 4) Usare if finale per controllare coerenza tra metodi fattoriale.

n = 6;                                                     % Definisce il valore intero usato per entrambi i calcoli richiesti.
fattoriale_ricorsivo = fattoriale_ric(n);                 % Calcola n! con la funzione ricorsiva locale dedicata.

fattoriale_iterativo = 1;                                 % Inizializza il prodotto iterativo all'elemento neutro moltiplicativo.
for k = 1:n                                                % Scorre tutti gli interi da 1 a n per il prodotto iterativo.
    fattoriale_iterativo = fattoriale_iterativo * k;      % Aggiorna il prodotto moltiplicando per l'indice corrente.
end                                                        % Chiude il ciclo di calcolo iterativo del fattoriale.

fib_n = fibonacci_ric(n);                                  % Calcola F(n) con una funzione ricorsiva separata.

if fattoriale_ricorsivo == fattoriale_iterativo           % Confronta i due risultati del fattoriale per verificarne la coerenza.
    esito_confronto = "coerenti";                         % Imposta esito positivo se i due valori coincidono.
else                                                      % Gestisce il caso in cui i due metodi dessero risultati diversi.
    esito_confronto = "non coerenti";                     % Imposta esito negativo in caso di discrepanza.
end                                                       % Chiude il controllo di coerenza tra metodi.

fprintf("n=%d\n", n);                                     % Stampa il valore n usato negli esercizi ricorsivi/iterativi.
fprintf("Fattoriale ricorsivo = %d\n", fattoriale_ricorsivo); % Stampa il risultato del fattoriale ricorsivo.
fprintf("Fattoriale iterativo = %d\n", fattoriale_iterativo); % Stampa il risultato del fattoriale iterativo.
fprintf("Confronto fattoriali: %s\n", esito_confronto);   % Stampa l'esito del confronto tra i due metodi.
fprintf("Fibonacci F(%d) = %d\n", n, fib_n);              % Stampa il valore di Fibonacci calcolato ricorsivamente.

function f = fattoriale_ric(k)                             % Definisce la funzione ricorsiva per il fattoriale k!.
    if k <= 1                                              % Verifica il caso base della ricorsione per 0 e 1.
        f = 1;                                             % Restituisce 1 nel caso base del fattoriale.
    else                                                   % Gestisce il caso ricorsivo per k maggiore di 1.
        f = k * fattoriale_ric(k - 1);                     % Richiama la funzione su k-1 e moltiplica per k.
    end                                                    % Chiude il blocco condizionale della funzione fattoriale.
end                                                        % Chiude la definizione della funzione fattoriale_ric.

function f = fibonacci_ric(k)                              % Definisce la funzione ricorsiva per il calcolo di Fibonacci.
    if k <= 1                                              % Verifica il caso base per F(0)=0 e F(1)=1.
        f = k;                                             % Restituisce direttamente k nei casi base della successione.
    else                                                   % Gestisce il caso ricorsivo per indici maggiori di 1.
        f = fibonacci_ric(k - 1) + fibonacci_ric(k - 2);   % Somma i due termini precedenti secondo la definizione classica.
    end                                                    % Chiude il blocco condizionale della funzione Fibonacci.
end                                                        % Chiude la definizione della funzione fibonacci_ric.
