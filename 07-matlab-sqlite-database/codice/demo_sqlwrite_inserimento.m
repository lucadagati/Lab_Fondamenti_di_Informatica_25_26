% DEMO — sqlwrite: da table MATLAB a riga nel database
%
% Glossario: es01_apri_db_sqlread.m. sqlwrite = inserimento da table senza scrivere INSERT a mano.

cartellaScript = fileparts(mfilename('fullpath'));
cartellaLab = fileparts(cartellaScript);
addpath(fullfile(cartellaLab, 'codice'));

percorsoDb = lab07_create_fresh_database(cartellaLab);
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
