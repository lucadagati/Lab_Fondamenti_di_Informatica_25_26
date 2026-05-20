% ES 6 - Cell array mista con analisi base del contenuto
% Testo (ben spiegato): creare una cell array con almeno 5 elementi di
% tipo diverso (stringa, vettore numerico, logico, matrice, scalare).
% Scorrere la cella e stampare per ogni elemento:
% indice, tipo, dimensione e un riassunto semplice del contenuto.
% Per i dati numerici stampare anche la somma degli elementi.
% Implementazione consigliata:
% 1) Creare la cell array mista con dati eterogenei.
% 2) Nel ciclo ricavare tipo e dimensioni con class/size.
% 3) Delegare il riassunto del contenuto a una funzione locale.
% 4) Mostrare sempre il contenuto completo con disp.

cella_mista = {"ciao", 1:3, true, [1 2; 3 4], 42};       % Crea una cell array con cinque elementi di tipo diverso.

for i = 1:length(cella_mista)                             % Scorre sequenzialmente tutti gli elementi della cell array.
    elemento = cella_mista{i};                            % Estrae il contenuto corrente dalla cella per lavorare in modo piu leggibile.
    tipo = class(elemento);                               % Recupera il tipo MATLAB dell'elemento corrente.
    dim = size(elemento);                                 % Recupera le dimensioni dell'elemento corrente come vettore [righe colonne].
    fprintf("Elemento %d - tipo:%s - dim:%dx%d\n", i, tipo, dim(1), dim(2)); % Stampa intestazione con indice, tipo e dimensione.
    riepilogo = riassunto_elemento(elemento);             % Costruisce il testo riassuntivo tramite funzione locale dedicata.
    fprintf("  %s\n", riepilogo);                       % Stampa il riassunto generato per il tipo corrente.
    disp(elemento);                                       % Mostra il contenuto effettivo dell'elemento corrente.
end                                                       % Chiude il ciclo dopo aver processato tutti gli elementi.

function testo = riassunto_elemento(elemento)             % Definisce una funzione locale che genera un riassunto testuale per l'elemento.
    if isnumeric(elemento)                                % Verifica se l'elemento e numerico.
        somma = somma_numerica(elemento);                 % Calcola la somma con una seconda funzione locale dedicata.
        testo = sprintf("Somma valori numerici: %.2f", somma); % Costruisce la frase riassuntiva per il caso numerico.
    elseif islogical(elemento)                            % Verifica se l'elemento e logico.
        testo = sprintf("Valore logico: %d", elemento);  % Costruisce la frase riassuntiva per il caso logico.
    elseif isstring(elemento)                             % Verifica se l'elemento e una stringa MATLAB.
        testo = sprintf("Lunghezza stringa: %d", strlength(elemento)); % Costruisce la frase riassuntiva per il caso stringa.
    else                                                  % Gestisce i tipi non coperti dai rami precedenti.
        testo = "Riassunto non specifico disponibile";   % Restituisce una frase generica per tipi diversi.
    end                                                   % Chiude il blocco di classificazione del tipo.
end                                                       % Chiude la funzione locale riassunto_elemento.

function s = somma_numerica(matrice)                      % Definisce una funzione locale che somma tutti gli elementi numerici della matrice.
    s = 0;                                                % Inizializza l'accumulatore della somma totale.
    for r = 1:size(matrice, 1)                            % Scorre tutte le righe della matrice.
        for c = 1:size(matrice, 2)                        % Scorre tutte le colonne della matrice.
            s = s + matrice(r, c);                        % Aggiunge il valore corrente all'accumulatore.
        end                                               % Chiude il ciclo sulle colonne.
    end                                                   % Chiude il ciclo sulle righe.
end                                                       % Chiude la funzione locale somma_numerica.
