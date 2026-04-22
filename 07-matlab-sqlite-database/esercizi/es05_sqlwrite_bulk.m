% ESERCIZIO 5 — Inserire più righe insieme con sqlwrite
%
% Cosa impari: costruire una table MATLAB e copiarla nel database come nuove righe.
%             Più comodo del INSERT a mano quando hai molte righe simili.

cartellaScript = fileparts(mfilename('fullpath'));
cartellaLab = fileparts(cartellaScript);
addpath(fullfile(cartellaLab, 'codice'));

percorsoDb = lab07_create_fresh_database(cartellaLab);
conn = sqlite(percorsoDb);

% --- Costruiamo una table con 2 righe e 5 colonne ---------------------------
% I nomi delle colonne della table devono coincidere con i nomi nel database:
%   paziente_id, nome_esame, valore, unita, data_esame
% Ogni colonna è un vettore colonna: due righe = due valori per colonna.

nuoveRighe = table( ...
    [2; 2], ...              % stesso paziente (id 2) per entrambe le righe
    {'LDH'; 'PCR'}, ...      % nome dell’esame, una stringa per riga
    [230; 0.4], ...          % valore numerico
    {'U/L'; 'mg/dL'}, ...    % unità di misura
    {'2025-05-10'; '2025-05-10'}, ...  % data (testo, come nello schema)
    'VariableNames', {'paziente_id', 'nome_esame', 'valore', 'unita', 'data_esame'} ...
    );

% sqlwrite aggiunge in fondo alla tabella esami_lab le righe della table MATLAB
sqlwrite(conn, 'esami_lab', nuoveRighe);

% --- Verifica con una lettura semplice ---------------------------------------
queryVerifica = [ ...
    'SELECT * FROM esami_lab ' ...
    'WHERE paziente_id = 2 AND nome_esame IN (''LDH'', ''PCR'') ' ...
    'ORDER BY nome_esame' ...
    ];
dopoInsert = fetch(conn, queryVerifica);

close(conn);

disp('Esami LDH e PCR per il paziente 2:');
disp(dopoInsert);
