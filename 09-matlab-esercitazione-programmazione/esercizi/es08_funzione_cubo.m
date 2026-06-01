% ES 8 - Funzioni locali: cubo e differenza assoluta
% Testo (ben spiegato): definire una funzione locale cubo(x)=x.^3.
% Applicarla a un vettore di input e confrontare, per ogni elemento,
% il valore cubico con un vettore target predefinito.
% Calcolare anche l'errore assoluto elemento per elemento.
% Implementazione consigliata:
% 1) Preparare vettore input e vettore target della stessa dimensione.
% 2) Richiamare la funzione cubo sul vettore input.
% 3) Richiamare una seconda funzione locale per errore assoluto.
% 4) Stampare input, output cubico ed errore con disp.

vettore=[]
target=[]
dimensione = input("Inserisci la dimensione degli array")
for i=1:dimensione
    vettore(i)=input("Inserisci elemento per vettore di riferimento")
end
for i=1:dimensione
    target(i)=input("Inserisci elemento per vettore di target")
end

risultato = cubo(vettore);                               % Richiama la funzione locale cubo per ottenere la trasformazione x^3.
errore = errore_assoluto(risultato, target);             % Richiama la funzione locale che calcola la distanza assoluta elemento per elemento.

disp(vettore);                                           % Mostra a schermo il vettore di input originale.
disp(risultato);                                         % Mostra a schermo il vettore dei cubi calcolati.
disp(target);                                            % Mostra a schermo il vettore target di confronto.
disp(errore);                                            % Mostra a schermo l'errore assoluto per ciascun elemento.

function y = cubo(x)                                     % Definisce la funzione locale che restituisce il cubo di ogni elemento di x.
    y = x .^ 3;                                          % Applica l'elevamento al cubo in modalita elemento-per-elemento.
end                                                      % Chiude la definizione della funzione cubo.

function e = errore_assoluto(a, b)                       % Definisce la funzione locale che calcola l'errore assoluto tra due vettori.
    e = abs(a - b);                                      % Calcola la differenza in valore assoluto elemento per elemento.
end                                                      % Chiude la definizione della funzione errore_assoluto.
