% ES 11 - File numerico con statistiche aggiuntive
% Testo (ben spiegato): creare un asse x uniforme tra 0 e 2*pi con 21 punti
% senza usare linspace, e calcolare y = sin(x).
% Scrivere x e y in un file di testo a due colonne con tabulazione.
% Rileggere il file e calcolare con un ciclo:
% media di y, minimo y, massimo y e numero di valori y negativi.
% Implementazione consigliata:
% 1) Generare x con una funzione locale e y con una seconda funzione locale.
% 2) Aprire file in scrittura e salvare riga per riga con fprintf.
% 3) Rileggere con una funzione locale che usa fopen/fscanf.
% 4) Usare un ciclo for con aggiornamento di media/min/max/conteggio.

x = genera_asse_uniforme(0, 2 * pi, 21);                   % Genera 21 punti equispaziati con una funzione locale al posto di linspace.
y = calcola_seno_vettore(x);                               % Calcola i valori seno con una funzione locale che processa il vettore.

fid = fopen("dati_num.txt", "w");                         % Apre o crea il file dati_num.txt in modalita scrittura testuale.
if fid == -1                                               % Verifica se il file e stato aperto correttamente.
    error("Impossibile aprire il file dati_num.txt in scrittura"); % Interrompe l'esecuzione con messaggio chiaro se apertura fallisce.
end                                                        % Chiude il blocco di controllo apertura file.

for i = 1:length(x)                                        % Scorre tutti gli indici dei vettori x e y.
    fprintf(fid, "%.6f\t%.6f\n", x(i), y(i));            % Scrive una riga con x e y formattati a 6 cifre decimali separati da tab.
end                                                        % Chiude il ciclo di scrittura dati su file.
fclose(fid);                                               % Chiude il file per garantire flush e salvataggio definitivo.

dati = leggi_due_colonne("dati_num.txt");                 % Legge il file con una funzione locale basata su fopen e fscanf.
somma_y = 0;                                               % Inizializza l'accumulatore per la somma dei valori y.
min_y = inf;                                               % Inizializza il minimo y a infinito per consentire primo aggiornamento.
max_y = -inf;                                              % Inizializza il massimo y a meno infinito per consentire primo aggiornamento.
conteggio_negativi = 0;                                    % Inizializza il contatore dei valori y strettamente negativi.

for i = 1:size(dati, 1)                                    % Scorre tutte le righe della matrice letta dal file.
    y_corrente = dati(i, 2);                               % Estrae il valore della seconda colonna nella riga corrente.
    somma_y = somma_y + y_corrente;                        % Aggiorna la somma cumulata dei valori y.
    if y_corrente < min_y                                  % Controlla se il valore corrente e un nuovo minimo.
        min_y = y_corrente;                                % Aggiorna il minimo osservato.
    end                                                    % Chiude il controllo di aggiornamento minimo.
    if y_corrente > max_y                                  % Controlla se il valore corrente e un nuovo massimo.
        max_y = y_corrente;                                % Aggiorna il massimo osservato.
    end                                                    % Chiude il controllo di aggiornamento massimo.
    if y_corrente < 0                                      % Verifica se il valore corrente e negativo.
        conteggio_negativi = conteggio_negativi + 1;       % Incrementa il contatore dei valori negativi.
    end                                                    % Chiude il controllo sul segno del valore y.
end                                                        % Chiude il ciclo su tutte le righe lette da file.

media_y = somma_y / size(dati, 1);                         % Calcola la media di y dividendo somma per numero di campioni.
fprintf("Media y = %.4f\n", media_y);                     % Stampa la media calcolata per la colonna y.
fprintf("Min y = %.4f, Max y = %.4f\n", min_y, max_y);    % Stampa minimo e massimo osservati.
fprintf("Numero valori y negativi = %d\n", conteggio_negativi); % Stampa quanti valori y sono risultati negativi.

function asse = genera_asse_uniforme(inizio, fine, n_punti) % Definisce una funzione locale che costruisce un asse uniforme senza linspace.
    passo = (fine - inizio) / (n_punti - 1);                % Calcola il passo costante tra due punti consecutivi.
    asse = zeros(1, n_punti);                               % Prealloca il vettore asse per evitare riallocazioni nel ciclo.
    for k = 1:n_punti                                       % Scorre gli indici da 1 al numero totale di punti.
        asse(k) = inizio + (k - 1) * passo;                 % Calcola il valore del punto k-esimo con formula affine.
    end                                                     % Chiude il ciclo di costruzione dell'asse uniforme.
end                                                         % Chiude la funzione locale genera_asse_uniforme.

function y = calcola_seno_vettore(x)                        % Definisce una funzione locale che calcola sin per ogni elemento di x.
    y = zeros(size(x));                                     % Prealloca il vettore y con la stessa dimensione di x.
    for k = 1:length(x)                                     % Scorre tutte le posizioni del vettore di input.
        y(k) = sin(x(k));                                   % Calcola il seno dell'elemento corrente e lo salva in y.
    end                                                     % Chiude il ciclo di calcolo del seno vettoriale.
end                                                         % Chiude la funzione locale calcola_seno_vettore.

function matrice = leggi_due_colonne(nome_file)             % Definisce una funzione locale che legge un file numerico a due colonne.
    fid_let = fopen(nome_file, "r");                        % Apre il file in modalita lettura testuale.
    if fid_let == -1                                        % Controlla se l'apertura in lettura e fallita.
        error("Impossibile aprire il file in lettura");    % Interrompe il programma con errore se il file non e accessibile.
    end                                                     % Chiude il controllo di apertura del file in lettura.
    valori = fscanf(fid_let, "%f", [2, inf]);              % Legge tutti i numeri del file organizzandoli in 2 righe e colonne variabili.
    fclose(fid_let);                                        % Chiude il file dopo la lettura completa.
    matrice = valori.';                                     % Trasporta la matrice per ottenere il formato standard Nx2.
end                                                         % Chiude la funzione locale leggi_due_colonne.
