% ESERCIZIO 6 — Perché serve la chiave primaria (id univoco)
%
% La colonna id in pazienti è PRIMARY KEY: identifica una sola riga e non può
% essere duplicata. Qui proviamo a inserire un secondo paziente con lo stesso
% id = 1 (già usato da Giulia Verdi): il database deve rifiutare l’operazione.

cartellaScript = fileparts(mfilename('fullpath'));
cartellaLab = fileparts(cartellaScript);
addpath(fullfile(cartellaLab, 'codice'));

percorsoDb = lab07_create_fresh_database(cartellaLab);
conn = sqlite(percorsoDb);
execute(conn, 'PRAGMA foreign_keys=ON;');

disp('--- Prima riga in pazienti (id = 1 è occupato) ---');
disp(fetch(conn, 'SELECT id, nome, cognome FROM pazienti WHERE id = 1;'));

% --- Tentativo errato: stesso id di una riga già esistente -------------------
% Senza chiave primaria potresti avere due “Giulia” con lo stesso id e non sapere
% quale aggiornare: il modello relazionale impedisce questa ambiguità.
try
    execute(conn, [ ...
        'INSERT INTO pazienti (id, nome, cognome, anno_nascita, sesso) ' ...
        'VALUES (1, ''Altro'', ''Paziente'', 1990, ''M'')' ...
        ]);
    disp('ERRORE: l''INSERT non avrebbe dovuto riuscire.');
catch ME
    disp('--- Il database ha bloccato l''INSERT (come atteso) ---');
    disp(ME.message);
end

close(conn);
