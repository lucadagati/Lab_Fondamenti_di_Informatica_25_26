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
    'SELECT p.cognome, e.valore, e.unita ' ...
    'FROM esami_lab e ' ...
    'JOIN pazienti p ON e.paziente_id = p.id ' ...
    'WHERE e.nome_esame = ''Glicemia'' ' ...
    'ORDER BY e.valore DESC' ...
    ];
glicemie = fetch(conn, sqlGlicemia);
disp('Glicemie con cognome:');
disp(glicemie);

close(conn);
