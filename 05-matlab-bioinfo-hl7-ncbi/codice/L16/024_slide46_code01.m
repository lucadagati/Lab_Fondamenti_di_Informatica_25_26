function results = simpleRT_experiment(nTrials)  % definisce la funzione e la firma
% SIMPLERT_EXPERIMENT — Go/No-Go semplificato: misura tempi di reazione a stimolo visivo.
% Parametri: nTrials = numero di ripetizioni. Output: RT in ms, flag validità per trial.

    try  % esegue il passo corrente della pipeline
        PsychDefaultSetup(2);  % esegue il setup base di Psychtoolbox
        screenId = max(Screen('Screens'));  % seleziona lo schermo con indice massimo
        [window, rect] = PsychImaging('OpenWindow', screenId, 0.5);  % apre una finestra grigia a schermo pieno
        [xC, yC] = RectCenter(rect);  % calcola il centro della finestra
        ifi = Screen('GetFlipInterval', window);  %#ok
 legge l'intervallo di refresh del monitor

        results = struct();  % costruisce una struct con i campi
        results.RT = nan(nTrials, 1);  % prealloca i tempi di reazione
        results.valid = true(nTrials, 1);  % prealloca il flag di validità

        for trial = 1:nTrials  % scorre tutti i trial previsti
            DrawFormattedText(window, '+', 'center', 'center', 1);  % disegna la croce di fissazione
            Screen('Flip', window);  % rende visibile la fissazione
            WaitSecs(0.5 + rand());  % attende un foreperiod casuale tra 0.5 e 1.5 s

            targetRect = CenterRectOnPoint([0 0 80 80], xC, yC);  % costruisce il rettangolo del target
            Screen('FillOval', window, [1 0 0], targetRect);  % disegna un cerchio rosso al centro
            stimOnset = Screen('Flip', window);  % mostra lo stimolo e salva il timestamp di onset
