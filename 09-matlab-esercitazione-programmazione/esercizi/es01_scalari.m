% ES 1 - Operazioni tra scalari con controllo validita
% Testo (ben spiegato): sono dati tre scalari a, b, c che rappresentano
% tre misure campione. Calcolare somma, media, prodotto e il valore
% dell'espressione (a^2 + b*c)/(b+c). In aggiunta, calcolare anche
% un indice normalizzato tra 0 e 1 definito come media/(max(a,b,c)).
% Se il denominatore di una formula e nullo, evitare l'errore e usare NaN.
% Stampare tutti i risultati in modo leggibile.
% Implementazione consigliata:
% 1) Definire gli scalari e le grandezze base (somma, media, prodotto).
% 2) Gestire con if i denominatori per evitare divisioni per zero.
% 3) Calcolare prima il valore composto, poi l'indice normalizzato.
% 4) Stampare con fprintf usando formati interi e decimali.

a = 3;                                                   % Assegna ad a il primo valore scalare di input.
b = 5;                                                   % Assegna a b il secondo valore scalare di input.
c = 2;                                                   % Assegna a c il terzo valore scalare di input.

somma = a + b + c;                                       % Calcola la somma dei tre valori per ottenere il totale.
media = somma / 3;                                       % Calcola la media aritmetica dividendo la somma per il numero di elementi.
prodotto = a * b * c;                                    % Calcola il prodotto dei tre scalari come misura combinata.

den_expr = b + c;                                        % Salva il denominatore dell'espressione principale in una variabile separata.
if den_expr ~= 0                                         % Controlla che il denominatore non sia zero prima di dividere.
    valore = (a^2 + b * c) / den_expr;                   % Calcola l'espressione richiesta quando la divisione e valida.
else                                                     % Gestisce il caso di denominatore nullo per evitare errore runtime.
    valore = NaN;                                        % Assegna NaN per indicare che il risultato non e numericamente definito.
end                                                      % Chiude il blocco di controllo sul denominatore dell'espressione.

massimo = massimo_di_tre(a, b, c);                       % Trova il massimo con una funzione locale didattica.
if massimo ~= 0                                          % Controlla che il massimo non sia zero prima di normalizzare.
    indice_norm = media / massimo;                       % Calcola l'indice normalizzato nel range atteso quando possibile.
else                                                     % Gestisce il caso limite in cui il massimo e zero.
    indice_norm = NaN;                                   % Assegna NaN per indicare normalizzazione non possibile.
end                                                      % Chiude il blocco di controllo per la normalizzazione.

fprintf("Somma=%d, Media=%.2f, Prod=%d, Valore=%.2f, IndiceNorm=%.3f\n", somma, media, prodotto, valore, indice_norm); % Stampa tutti i risultati finali in un'unica riga formattata.

function m = massimo_di_tre(x1, x2, x3)                  % Definisce una funzione locale che calcola il massimo tra tre numeri.
    m = x1;                                               % Inizializza il massimo provvisorio con il primo valore.
    if x2 > m                                             % Controlla se il secondo valore supera il massimo provvisorio.
        m = x2;                                           % Aggiorna il massimo provvisorio con il secondo valore.
    end                                                   % Chiude il controllo sul secondo valore.
    if x3 > m                                             % Controlla se il terzo valore supera il massimo provvisorio.
        m = x3;                                           % Aggiorna il massimo provvisorio con il terzo valore.
    end                                                   % Chiude il controllo sul terzo valore.
end                                                       % Chiude la funzione locale massimo_di_tre.
