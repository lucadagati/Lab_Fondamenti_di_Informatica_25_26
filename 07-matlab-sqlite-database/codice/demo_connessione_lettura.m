% DEMO — Lettura da SQLite: sqlread e fetch (con JOIN)
%
% Esempio breve dopo aver ricreato il database di laboratorio.

cartellaScript = fileparts(mfilename('fullpath'));
cartellaLab = fileparts(cartellaScript);
addpath(fullfile(cartellaLab, 'codice'));

percorsoDb = lab07_create_fresh_database(cartellaLab);
conn = sqlite(percorsoDb);
execute(conn, 'PRAGMA foreign_keys=ON;');

% Lettura rapida di un’intera tabella
pazienti = sqlread(conn, 'pazienti');
disp('Pazienti:');
disp(pazienti);

% Query con join: cognome del paziente accanto a ogni glicemia
sqlGlicemia = [ ...
    'SELECT p.cognome, e.valore, e.unita ' ...
    'FROM esami_lab e ' ...
    'JOIN pazienti p ON e.paziente_id = p.id ' ...
    'WHERE e.nome_esame = ''Glicemia'' ' ...
    'ORDER BY e.valore DESC' ...
    ];
glicemie = fetch(conn, sqlGlicemia);
disp('Glicemie (con cognome):');
disp(glicemie);

close(conn);
