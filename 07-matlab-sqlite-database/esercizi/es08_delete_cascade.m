% ESERCIZIO 8 — ON DELETE CASCADE: se togli il paziente, spariscono i suoi esami
%
% Nello schema CREATE, esami_lab ha REFERENCES pazienti(id) ON DELETE CASCADE.
% CASCADE = effetto a catena: DELETE su pazienti rimuove automaticamente le righe
% di esami_lab che puntavano a quel paziente_id.
%
% Glossario: es01. COUNT(*) in SQL conta le righe; AS n dà nome alla colonna del risultato.

cartellaScript = fileparts(mfilename('fullpath'));
cartellaLab = fileparts(cartellaScript);
addpath(fullfile(cartellaLab, 'codice'));

percorsoDb = lab07_create_fresh_database(cartellaLab);
conn = sqlite(percorsoDb);
execute(conn, 'PRAGMA foreign_keys=ON;');  % necessario anche per ON DELETE CASCADE

prima = fetch(conn, 'SELECT COUNT(*) AS n FROM esami_lab WHERE paziente_id = 1;');
disp('--- Numero esami con paziente_id = 1 prima del DELETE sul paziente ---');
disp(prima.n(1));

% DELETE rimuove righe dalla tabella pazienti che soddisfano la condizione WHERE
execute(conn, 'DELETE FROM pazienti WHERE id = 1;');

dopo = fetch(conn, 'SELECT COUNT(*) AS n FROM esami_lab WHERE paziente_id = 1;');
disp('--- Stesso conteggio dopo il DELETE (grazie alla CASCADE deve essere 0) ---');
disp(dopo.n(1));

close(conn);
