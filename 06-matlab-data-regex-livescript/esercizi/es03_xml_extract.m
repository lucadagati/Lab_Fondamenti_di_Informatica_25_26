% Esercizio 3 - XML: estrazione campi in tabella
% Obiettivo: trasformare XML in table MATLAB.

baseDir = fileparts(fileparts(mfilename('fullpath')));
xmlPath = fullfile(baseDir, 'dati', 'pazienti_lab6.xml');

% TODO 1: leggi XML con readstruct

% TODO 2: individua il vettore di nodi paziente

% TODO 3: inizializza vettori id/nome/eta/bpm/spo2/sistolica

% TODO 4: ciclo sui pazienti ed estrazione campi (con conversioni numeriche)

% TODO 5: crea table e visualizza
