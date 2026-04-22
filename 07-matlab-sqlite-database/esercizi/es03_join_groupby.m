% ESERCIZIO 3 — Contare gli esami per paziente (JOIN + GROUP BY)
%
% Obiettivo: unire pazienti ed esami_lab e contare quante righe esami ci sono per ogni paziente.
%
% Glossario: vedi es01_apri_db_sqlread.m. Qui usiamo ancora fetch(conn, query).

cartellaScript = fileparts(mfilename('fullpath'));
cartellaLab = fileparts(cartellaScript);
addpath(fullfile(cartellaLab, 'codice'));

percorsoDb = lab07_create_fresh_database(cartellaLab);
conn = sqlite(percorsoDb);
execute(conn, 'PRAGMA foreign_keys=ON;');  % glossario: es01

% JOIN: collega ogni riga di esami alla riga paziente con lo stesso id (e.paziente_id = p.id).
% LEFT JOIN: tiene tutti i pazienti anche se non hanno esami (COUNT = 0).
% GROUP BY: raggruppa per paziente così COUNT(e.id) ha senso "per gruppo".
query = [ ...
    'SELECT p.id, p.cognome, COUNT(e.id) AS n_esami ' ...
    'FROM pazienti p ' ...
    'LEFT JOIN esami_lab e ON e.paziente_id = p.id ' ...
    'GROUP BY p.id, p.cognome ' ...
    'ORDER BY p.id' ...
    ];

risultato = fetch(conn, query);
close(conn);

disp('Numero di esami per paziente:');
disp(risultato);
