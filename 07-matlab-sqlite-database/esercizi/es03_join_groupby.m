% ESERCIZIO 3 — Contare quanti esami ha ogni paziente (JOIN + GROUP BY)
%
% Cosa impari: collegare due tabelle (pazienti ed esami_lab) e usare COUNT.

cartellaScript = fileparts(mfilename('fullpath'));
cartellaLab = fileparts(cartellaScript);
addpath(fullfile(cartellaLab, 'codice'));

percorsoDb = lab07_create_fresh_database(cartellaLab);
conn = sqlite(percorsoDb);
execute(conn, 'PRAGMA foreign_keys=ON;');

% --- Idea della query --------------------------------------------------------
% Partiamo dalla tabella pazienti (alias p).
% LEFT JOIN con esami_lab (alias e): così restano tutti i pazienti anche se
%   hanno zero esami (con INNER JOIN sparirebbero).
% COUNT(e.id): conta le righe di esami collegate a ciascun paziente.
% GROUP BY p.id, p.cognome: una riga per paziente nel risultato.

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
