% init_lab07_database — ricrea il database di esempio (punto di ingresso da riga di comando)
%
% Imposta la Current Folder sulla cartella 07-matlab-sqlite-database, poi:
%   run('codice/init_lab07_database.m')

thisDir = fileparts(mfilename('fullpath'));
labDir = fileparts(thisDir);
addpath(thisDir);
dbPath = lab07_create_fresh_database(labDir);
fprintf('Database creato: %s\n', dbPath);
