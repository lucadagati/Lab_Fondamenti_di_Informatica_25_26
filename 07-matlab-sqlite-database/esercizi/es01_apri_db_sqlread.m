% ESERCIZIO 1 — Leggere una tabella intera con sqlread
%
% Cosa impari: aprire un file SQLite e portare in MATLAB tutte le righe
%             della tabella "pazienti" come una table.

% --- Passo 1: capire in che cartella si trova questo script ----------------
% mfilename('fullpath') restituisce il percorso completo di questo file .m
% fileparts(...) toglie il nome del file e lascia la cartella "esercizi"
cartellaScript = fileparts(mfilename('fullpath'));

% La cartella del laboratorio è un livello sopra (contiene esercizi/, codice/, …)
cartellaLab = fileparts(cartellaScript);

% --- Passo 2: rendere visibile la funzione che crea il database ------------
% La funzione lab07_create_fresh_database sta in codice/
addpath(fullfile(cartellaLab, 'codice'));

% --- Passo 3: creare (da zero) il file dati/lab07_biomed.db -----------------
% Cancella il vecchio file se c’è, ricrea tabelle e dati di esempio.
% Il valore di ritorno è il percorso completo del file .db
percorsoDb = lab07_create_fresh_database(cartellaLab);

% --- Passo 4: aprire il database --------------------------------------------
% conn è l’oggetto "connessione": serve per tutte le operazioni successive
conn = sqlite(percorsoDb);

% --- Passo 5: leggere tutta la tabella pazienti ------------------------------
% sqlread legge un’intera tabella e la mette in una table MATLAB (righe = pazienti)
tabellaPazienti = sqlread(conn, 'pazienti');

% --- Passo 6: chiudere la connessione (buona abitudine) ----------------------
close(conn);

% --- Passo 7: vedere il risultato a Command Window ---------------------------
disp('Tabella pazienti:');
disp(tabellaPazienti);
