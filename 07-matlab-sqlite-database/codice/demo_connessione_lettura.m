% DEMO — Lettura: sqlread e fetch (con JOIN)
%
% Glossario completo (sqlite, execute, fetch, PRAGMA, close): es01_apri_db_sqlread.m

cartellaLab = pwd;
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
percorsoDb = dbPath;
conn = sqlite(percorsoDb);
execute(conn, 'PRAGMA foreign_keys=ON;');

pazienti = sqlread(conn, 'pazienti');
disp('Pazienti:');
disp(pazienti);

sqlGlicemia = [ ...
    'SELECT p.cognome, e.valore, e.unita, t.nome AS tipo_esame ' ...
    'FROM esami_lab e ' ...
    'JOIN visite v ON e.visita_id = v.id ' ...
    'JOIN pazienti p ON v.paziente_id = p.id ' ...
    'JOIN tipi_esame t ON e.tipo_esame_id = t.id ' ...
    'WHERE t.nome = ''Glicemia'' ' ...
    'ORDER BY e.valore DESC' ...
    ];
glicemie = fetch(conn, sqlGlicemia);
disp('Glicemie con cognome:');
disp(glicemie);

close(conn);
