% Coda eventi: timestamps più affidabili e minore carico CPU rispetto al polling
KbQueueCreate;  % crea una coda eventi sulla tastiera di default
KbQueueStart();  % attiva la raccolta degli eventi tastiera

% ... qui: disegno stimolo + Screen('Flip') per ottenere stimOnset ...

[pressed, firstPress] = KbQueueCheck();  % legge se ci sono eventi e i relativi timestamp
if pressed  % verifica che almeno un evento tastiera sia stato registrato
    idx = find(firstPress ~= 0, 1, 'first');  % trova il primo tasto con timestamp valido
    RT = firstPress(idx) - stimOnset;  % calcola il tempo di reazione dal timestamp del primo evento
end  % chiude il controllo sulla presenza di tasti premuti

KbQueueRelease();  % libera la coda eventi e le risorse associate
