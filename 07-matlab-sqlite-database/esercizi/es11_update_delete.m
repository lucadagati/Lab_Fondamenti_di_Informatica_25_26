% ESERCIZIO 11 — UPDATE e DELETE controllati
%
% Obiettivo: modificare e cancellare righe usando WHERE e verifiche prima/dopo.

cartellaScript = fileparts(mfilename('fullpath'));
cartellaLab = fileparts(cartellaScript);
addpath(fullfile(cartellaLab, 'codice'));

run(fullfile(cartellaLab, 'codice', 'lab07_create_fresh_database.m'));
percorsoDb = dbPath;
conn = sqlite(percorsoDb);
execute(conn, 'PRAGMA foreign_keys=ON;');

disp('--- Riga esame id=3 prima di UPDATE ---');
disp(fetch(conn, 'SELECT id, valore, note FROM esami_lab WHERE id = 3;'));

% UPDATE modifica solo le righe indicate dal WHERE. Qui aggiorniamo una nota.
execute(conn, [ ...
    'UPDATE esami_lab ' ...
    'SET note = ''valore ricontrollato in ambulatorio'' ' ...
    'WHERE id = 3' ...
    ]);

disp('--- Riga esame id=3 dopo UPDATE ---');
disp(fetch(conn, 'SELECT id, valore, note FROM esami_lab WHERE id = 3;'));

% Esempio di UPDATE su più righe: aggiunge una nota alle glicemie alte senza nota.
execute(conn, [ ...
    'UPDATE esami_lab ' ...
    'SET note = ''glicemia sopra range: follow-up consigliato'' ' ...
    'WHERE tipo_esame_id = (SELECT id FROM tipi_esame WHERE codice = ''GLU'') ' ...
    'AND valore > 100 AND note IS NULL' ...
    ]);

qGlicemie = [ ...
    'SELECT cognome, codice, valore, note ' ...
    'FROM v_esami_completi ' ...
    'WHERE codice = ''GLU'' AND valore > 100 ' ...
    'ORDER BY valore DESC' ...
    ];
disp('--- Glicemie > 100 dopo UPDATE su più righe ---');
disp(fetch(conn, qGlicemie));

% DELETE va sempre usato con WHERE. Qui cancelliamo un solo risultato di test.
prima = fetch(conn, 'SELECT COUNT(*) AS n FROM esami_lab;');
disp('--- Numero esami prima del DELETE puntuale ---');
disp(prima.n(1));

execute(conn, 'DELETE FROM esami_lab WHERE id = 12;');

dopo = fetch(conn, 'SELECT COUNT(*) AS n FROM esami_lab;');
disp('--- Numero esami dopo il DELETE puntuale (uno in meno) ---');
disp(dopo.n(1));

% La visita resta presente: abbiamo eliminato un risultato, non il paziente.
disp('--- La visita 1 esiste ancora ---');
disp(fetch(conn, 'SELECT * FROM visite WHERE id = 1;'));

close(conn);
