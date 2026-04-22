% ESERCIZIO 4 — Inserire una riga con execute (testo SQL fisso)
%
% Cosa impari: usare INSERT ... VALUES ... per aggiungere un esame al database.

cartellaScript = fileparts(mfilename('fullpath'));
cartellaLab = fileparts(cartellaScript);
addpath(fullfile(cartellaLab, 'codice'));

percorsoDb = lab07_create_fresh_database(cartellaLab);
conn = sqlite(percorsoDb);
execute(conn, 'PRAGMA foreign_keys=ON;');

% --- INSERT: una nuova riga nella tabella esami_lab -------------------------
% paziente_id = 1 è il primo paziente inserito dalla funzione di init
% I valori testuali in SQL vanno tra apici singoli ''testo''
comandoInsert = [ ...
    'INSERT INTO esami_lab (paziente_id, nome_esame, valore, unita, data_esame) ' ...
    'VALUES (1, ''Ferritina'', 85, ''ng/mL'', ''2025-05-01'')' ...
    ];

execute(conn, comandoInsert);

% --- Verifica: leggiamo solo le righe "Ferritina" ----------------------------
verifica = fetch(conn, 'SELECT * FROM esami_lab WHERE nome_esame = ''Ferritina''');

close(conn);

disp('Righe Ferritina dopo l''inserimento:');
disp(verifica);
