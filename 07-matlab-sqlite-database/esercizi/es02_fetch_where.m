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

% Il nome del test è nel catalogo tipi_esame; uniamo (JOIN) esami_lab a tipi_esame.
% Regola SQL: apostrofo nel testo → doppio apice in MATLAB (''Glicemia'').
query = [ ...
    'SELECT e.id, v.paziente_id, t.nome AS nome_esame, e.valore, e.unita, e.data_risultato ' ...
    'FROM esami_lab e ' ...
    'JOIN visite v ON e.visita_id = v.id ' ...
    'JOIN tipi_esame t ON e.tipo_esame_id = t.id ' ...
    'WHERE t.nome = ''Glicemia'' AND e.valore >= 100' ...
    ];

% fetch esegue il SELECT e mette le righe trovate in una table MATLAB chiamata risultato
risultato = fetch(conn, query);

close(conn);

disp('Glicemie >= 100 mg/dL:');
disp(risultato);
