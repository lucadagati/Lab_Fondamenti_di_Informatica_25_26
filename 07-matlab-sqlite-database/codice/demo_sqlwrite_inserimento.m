% DEMO — sqlwrite: da table MATLAB a riga nel database
%
% Glossario: es01_apri_db_sqlread.m. sqlwrite = inserimento da table senza scrivere INSERT a mano.

cartellaLab = builtin('pwd');
if ~isfolder(fullfile(cartellaLab, 'codice'))
    parentDir = fileparts(cartellaLab);
    if isfolder(fullfile(parentDir, 'codice'))
        cartellaLab = parentDir;
    else
        error('lab07:path', 'Esegui dalla cartella del lab o da codice/esercizi.');
    end
end
addpath(fullfile(cartellaLab, 'codice'));

run(fullfile(cartellaLab, 'codice', 'lab07_create_fresh_database.m'));
percorsoDb = dbPath;
conn = sqlite(percorsoDb);
execute(conn, 'PRAGMA foreign_keys=ON;');

% Visita 4 = Laura Neri; tipo_esame_id 7 = Creatinina (catalogo).
riga = table( ...
    4, 7, 97.0, {'umol/L'}, {'2025-04-20'}, ...
    'VariableNames', {'visita_id', 'tipo_esame_id', 'valore', 'unita', 'data_risultato'} ...
    );

sqlwrite(conn, 'esami_lab', riga);

controllo = fetch(conn, [ ...
    'SELECT e.*, t.nome FROM esami_lab e ' ...
    'JOIN tipi_esame t ON t.id = e.tipo_esame_id ' ...
    'WHERE t.codice = ''CREA''' ...
    ]);
disp('Dopo sqlwrite:');
disp(controllo);

close(conn);
