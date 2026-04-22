% ESERCIZIO 2 — Filtrare righe con SELECT e fetch
%
% Cosa impari: scrivere una query SQL con WHERE e leggere il risultato in MATLAB.
%             Qui: solo le glicemie maggiori o uguali a 100 mg/dL.

cartellaScript = fileparts(mfilename('fullpath'));
cartellaLab = fileparts(cartellaScript);
addpath(fullfile(cartellaLab, 'codice'));

percorsoDb = lab07_create_fresh_database(cartellaLab);
conn = sqlite(percorsoDb);

% --- Query SQL (testo) -------------------------------------------------------
% In SQL l’apostrofo dentro una stringa si scrive raddoppiato: ''Glicemia''
% La query chiede: tutte le colonne utili, dalla tabella esami_lab,
% solo righe dove il nome dell’esame è "Glicemia" e il valore è >= 100.
query = [ ...
    'SELECT id, paziente_id, nome_esame, valore, unita, data_esame ' ...
    'FROM esami_lab ' ...
    'WHERE nome_esame = ''Glicemia'' AND valore >= 100' ...
    ];

% fetch esegue il SELECT e restituisce una table MATLAB
risultato = fetch(conn, query);

close(conn);

disp('Glicemie >= 100 mg/dL:');
disp(risultato);
