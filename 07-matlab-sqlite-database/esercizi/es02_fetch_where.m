% ESERCIZIO 2 — Filtrare righe con SELECT e fetch
%
% Obiettivo: usare WHERE in SQL e leggere il risultato con fetch (solo glicemie ≥ 100).
%
% Glossario: vedi commenti in es01_apri_db_sqlread.m (sqlite, execute, fetch, PRAGMA, close).

cartellaLab = builtin('pwd');
if ~isfolder(fullfile(cartellaLab, 'codice'))
    parentDir = fileparts(cartellaLab);
    if isfolder(fullfile(parentDir, 'codice'))
        cartellaLab = parentDir;
    else
        error('lab07:path', 'Esegui dalla cartella del lab o da codice/esercizi.');
    end
end
addpath(fullfile(cartellaLab, 'codice'));

run(fullfile(cartellaLab, 'codice', 'lab07_create_fresh_database.m'));
percorsoDb = dbPath;  % ricrea il file .db
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
