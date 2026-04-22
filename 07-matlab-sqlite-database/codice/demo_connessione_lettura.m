% DEMO — Lettura: sqlread e fetch (con JOIN)
%
% Glossario completo (sqlite, execute, fetch, PRAGMA, close): es01_apri_db_sqlread.m

cartellaScript = fileparts(mfilename('fullpath'));
cartellaLab = fileparts(cartellaScript);
addpath(fullfile(cartellaLab, 'codice'));

percorsoDb = lab07_create_fresh_database(cartellaLab);
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
