% ESERCIZIO 5 — Inserire più righe con sqlwrite
%
% Obiettivo: costruire una table MATLAB e copiarla nel DB senza scrivere INSERT a mano.
%
% sqlwrite(conn, nomeTabellaDb, tableMatlab) : aggiunge in coda alla tabella SQL le righe
%     della table MATLAB. I nomi delle colonne della table devono coincidere con il DB.

cartellaScript = fileparts(mfilename('fullpath'));
cartellaLab = fileparts(cartellaScript);
addpath(fullfile(cartellaLab, 'codice'));

percorsoDb = lab07_create_fresh_database(cartellaLab);
conn = sqlite(percorsoDb);
execute(conn, 'PRAGMA foreign_keys=ON;');  % glossario: es01

% table(...) costruisce una tabella MATLAB: ogni argomento è una colonna (vettore colonna).
nuoveRighe = table( ...
    [2; 2], ...                        % colonna paziente_id (due righe, stesso id)
    {'LDH'; 'PCR'}, ...                % colonna nome_esame (celle di testo)
    [230; 0.4], ...                    % colonna valore (numeri)
    {'U/L'; 'mg/dL'}, ...              % colonna unita
    {'2025-05-10'; '2025-05-10'}, ...  % colonna data_esame (testo, come nello schema SQL)
    'VariableNames', {'paziente_id', 'nome_esame', 'valore', 'unita', 'data_esame'} ...
    );

sqlwrite(conn, 'esami_lab', nuoveRighe);

queryVerifica = [ ...
    'SELECT * FROM esami_lab ' ...
    'WHERE paziente_id = 2 AND nome_esame IN (''LDH'', ''PCR'') ' ...
    'ORDER BY nome_esame' ...
    ];
dopoInsert = fetch(conn, queryVerifica);

close(conn);

disp('Esami LDH e PCR per il paziente 2:');
disp(dopoInsert);
