% ESERCIZIO 7 — Chiave esterna e integrità referenziale
%
% esami_lab.paziente_id punta a pazienti.id (FOREIGN KEY). Significa: non puoi
% registrare un esame per un paziente che non esiste. Così non restano “esami orfani”.

cartellaScript = fileparts(mfilename('fullpath'));
cartellaLab = fileparts(cartellaScript);
addpath(fullfile(cartellaLab, 'codice'));

percorsoDb = lab07_create_fresh_database(cartellaLab);
conn = sqlite(percorsoDb);
execute(conn, 'PRAGMA foreign_keys=ON;');

disp('--- Nessun paziente con id = 9999 (id inventato) ---');
disp(fetch(conn, 'SELECT COUNT(*) AS n FROM pazienti WHERE id = 9999;'));

% --- Tentativo errato: esame collegato a un paziente inesistente ---------------
try
    execute(conn, [ ...
        'INSERT INTO esami_lab (paziente_id, nome_esame, valore, unita, data_esame) ' ...
        'VALUES (9999, ''Glicemia'', 100, ''mg/dL'', ''2025-01-01'')' ...
        ]);
    disp('ERRORE: l''INSERT non avrebbe dovuto riuscire.');
catch ME
    disp('--- Il database ha bloccato l''INSERT (integrità referenziale) ---');
    disp(ME.message);
end

close(conn);
