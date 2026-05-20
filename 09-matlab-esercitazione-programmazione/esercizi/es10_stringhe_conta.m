% ES 10 - Stringhe: conteggi multipli e parola piu lunga
% Testo (ben spiegato): data una frase, calcolare:
% 1) numero di parole che contengono la lettera 'a',
% 2) numero di parole con lunghezza almeno 5,
% 3) numero di parole che iniziano con consonante,
% 4) parola piu lunga presente nella frase.
% Usare split e un singolo ciclo for con if semplici.
% Implementazione consigliata:
% 1) Dividere la frase in parole con split.
% 2) Inizializzare contatori e variabile per parola piu lunga.
% 3) Nel ciclo aggiornare i vari conteggi.
% 4) Gestire il controllo consonante con una funzione locale dedicata.

frase = "oggi andiamo al mercato a fare la spesa settimanale"; % Definisce la frase di esempio da analizzare parola per parola.
parole = split(frase);                                           % Separa la frase in un array di stringhe usando gli spazi come separatori.
conta_a = 0;                                                     % Inizializza il contatore delle parole che contengono la lettera a.
conta_lunghe = 0;                                                % Inizializza il contatore delle parole lunghe almeno 5 caratteri.
conta_consonante = 0;                                            % Inizializza il contatore delle parole che iniziano con consonante.
parola_max = "";                                                 % Inizializza una stringa vuota che conterra la parola piu lunga trovata.
lunghezza_max = 0;                                               % Inizializza a zero la lunghezza massima trovata finora.
for i = 1:numel(parole)                                          % Scorre tutte le parole ottenute dalla frase.
    parola_corrente = lower(parole(i));                          % Porta la parola corrente in minuscolo per confronti robusti.
    if contains(parola_corrente, "a")                          % Verifica la presenza della lettera a nella parola corrente.
        conta_a = conta_a + 1;                                   % Incrementa il contatore parole-con-a quando la condizione e vera.
    end                                                          % Chiude il blocco di conteggio della lettera a.
    if strlength(parola_corrente) >= 5                           % Verifica se la parola corrente ha almeno 5 caratteri.
        conta_lunghe = conta_lunghe + 1;                         % Incrementa il contatore delle parole lunghe.
    end                                                          % Chiude il blocco di conteggio delle parole lunghe.
    if inizia_con_consonante(parola_corrente)                    % Verifica con funzione locale se la parola inizia con consonante.
        conta_consonante = conta_consonante + 1;                 % Incrementa il contatore delle parole che iniziano con consonante.
    end                                                          % Chiude il blocco di conteggio iniziale consonante.
    if strlength(parola_corrente) > lunghezza_max                % Controlla se la parola corrente supera la lunghezza massima attuale.
        lunghezza_max = strlength(parola_corrente);              % Aggiorna la nuova lunghezza massima osservata.
        parola_max = parola_corrente;                            % Salva la parola corrente come nuova parola piu lunga.
    end                                                          % Chiude il blocco di aggiornamento della parola piu lunga.
end                                                              % Chiude il ciclo for su tutte le parole.

fprintf("Parole con 'a': %d\n", conta_a);                      % Stampa il totale delle parole contenenti la lettera a.
fprintf("Parole lunghe>=5: %d\n", conta_lunghe);               % Stampa il totale delle parole con almeno 5 caratteri.
fprintf("Parole che iniziano con consonante: %d\n", conta_consonante); % Stampa il totale delle parole con iniziale consonante.
fprintf("Parola piu lunga: %s (len=%d)\n", parola_max, lunghezza_max); % Stampa la parola piu lunga individuata e la sua lunghezza.

function esito = inizia_con_consonante(parola)                   % Definisce una funzione locale che controlla se la parola inizia con consonante.
    if strlength(parola) == 0                                    % Gestisce il caso limite di stringa vuota.
        esito = false;                                            % Restituisce falso quando la parola non contiene caratteri.
        return;                                                   % Termina subito la funzione nel caso vuoto.
    end                                                           % Chiude il controllo sul caso stringa vuota.
    lettera = char(parola);                                       % Converte la stringa MATLAB in char array per indicizzazione semplice.
    prima = lettera(1);                                           % Estrae il primo carattere della parola.
    if prima == 'a' || prima == 'e' || prima == 'i' || prima == 'o' || prima == 'u' % Verifica se il primo carattere e una vocale.
        esito = false;                                            % Restituisce falso quando la parola inizia con vocale.
    else                                                          % Gestisce tutti i casi in cui il primo carattere non e vocale.
        esito = true;                                             % Restituisce vero quando la parola inizia con consonante.
    end                                                           % Chiude il controllo vocale/consonante.
end                                                               % Chiude la funzione locale inizia_con_consonante.
