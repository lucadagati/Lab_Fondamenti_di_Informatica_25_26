% KbCheck interroga lo stato tastiera; semplice ma consuma CPU se il loop è stretto
spaceKey = KbName('space');  % ricava il codice interno della barra spaziatrice
escKey = KbName('ESCAPE');  % ricava il codice del tasto escape per uscita di emergenza

stimRect = CenterRectOnPoint([0 0 120 120], xCenter, yCenter);  % centra il rettangolo dello stimolo sullo schermo
Screen('FillOval', window, [1 0 0], stimRect);  % disegna un cerchio rosso nella posizione scelta
stimOnset = Screen('Flip', window);  % mostra lo stimolo e salva il timestamp reale di comparsa

response = false;  % inizializza il flag di risposta come non ancora ricevuta
while ~response  % continua a controllare la tastiera finché non arriva una risposta
    [keyDown, secs, keyCode] = KbCheck;  % legge stato tastiera e tempo corrente
    if keyDown  % verifica se almeno un tasto è stato premuto
        if keyCode(spaceKey)  % controlla se il tasto premuto è la barra spaziatrice
            RT = secs - stimOnset;  % calcola il tempo di reazione rispetto all onset dello stimolo
            response = true;  % segnala che la risposta utile è arrivata
        elseif keyCode(escKey)  % controlla se è stato premuto escape
