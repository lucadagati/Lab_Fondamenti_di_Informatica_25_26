% Esercizio 5 - Patterns: parsing stringhe formattate
% Obiettivo: estrarre coppie chiave-valore da stringhe tipo 'bpm:101'.

righe = ["bpm:101", "spo2:94", "eta:67", "bad_format"];

% TODO 1: definisci pattern valido con lettersPattern/digitsPattern

% TODO 2: inizializza contenitori vuoti per chiavi e valori

% TODO 3: ciclo sulle righe
%   - se la riga non rispetta il pattern: salta (continue)
%   - altrimenti separa con split(':')
%   - salva chiave e valore

% TODO 4: crea table(chiavi,valori) e visualizza
