% ESERCIZIO 3 — Contare gli esami per paziente (JOIN + GROUP BY)
%
% Obiettivo: attraversare pazienti → visite → esami_lab e contare i risultati per paziente.
%
% Glossario: vedi es01_apri_db_sqlread.m. Qui usiamo ancora fetch(conn, query).

cartellaScript = fileparts(mfilename('fullpath'));
cartellaLab = fileparts(cartellaScript);
addpath(fullfile(cartellaLab, 'codice'));

run(fullfile(cartellaLab, 'codice', 'lab07_create_fresh_database.m'));
percorsoDb = dbPath;
conn = sqlite(percorsoDb);
execute(conn, 'PRAGMA foreign_keys=ON;');  % glossario: es01

% Gli esami sono legati alle visite; le visite al paziente (v.paziente_id = p.id).
% LEFT JOIN su visite/esami: pazienti senza visite o senza risultati hanno COUNT = 0.
query = [ ...
    'SELECT p.id, p.cognome, COUNT(e.id) AS n_esami ' ...
    'FROM pazienti p ' ...
    'LEFT JOIN visite v ON v.paziente_id = p.id ' ...
    'LEFT JOIN esami_lab e ON e.visita_id = v.id ' ...
    'GROUP BY p.id, p.cognome ' ...
    'ORDER BY p.id' ...
    ];

risultato = fetch(conn, query);
close(conn);

disp('Numero di esami per paziente:');
disp(risultato);
