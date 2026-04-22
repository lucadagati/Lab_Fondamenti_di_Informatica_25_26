% ESERCIZIO 2 — Filtrare righe con SELECT e fetch
%
% Obiettivo: usare WHERE in SQL e leggere il risultato con fetch (solo glicemie ≥ 100).
%
% Glossario: vedi commenti in es01_apri_db_sqlread.m (sqlite, execute, fetch, PRAGMA, close).

cartellaScript = fileparts(mfilename('fullpath'));  % cartella di questo script
cartellaLab = fileparts(cartellaScript);              % radice del lab 07
addpath(fullfile(cartellaLab, 'codice'));             % così MATLAB trova lab07_create_…

percorsoDb = lab07_create_fresh_database(cartellaLab);  % ricrea il file .db
conn = sqlite(percorsoDb);                              % apre il database
execute(conn, 'PRAGMA foreign_keys=ON;');               % vedi glossario in es01

% Costruiamo il testo della query SQL (è una stringa MATLAB, una sola istruzione SELECT).
% Regola SQL: l’apostrofo dentro il testo si scrive doppio → ''Glicemia'' nel codice MATLAB.
query = [ ...
    'SELECT id, paziente_id, nome_esame, valore, unita, data_esame ' ...
    'FROM esami_lab ' ...
    'WHERE nome_esame = ''Glicemia'' AND valore >= 100' ...
    ];

% fetch esegue il SELECT e mette le righe trovate in una table MATLAB chiamata risultato
risultato = fetch(conn, query);

close(conn);

disp('Glicemie >= 100 mg/dL:');
disp(risultato);
