        for trial = 1:nTrials  % scorre tutti i trial previsti
            DrawFormattedText(window, '+', 'center', 'center', 1);  % disegna la croce di fissazione
            Screen('Flip', window);  % rende visibile la fissazione
            WaitSecs(0.5 + rand());  % attende un foreperiod casuale tra 0.5 e 1.5 s

            targetRect = CenterRectOnPoint([0 0 80 80], xC, yC);  % costruisce il rettangolo del target
            Screen('FillOval', window, [1 0 0], targetRect);  % disegna un cerchio rosso al centro
            stimOnset = Screen('Flip', window);  % mostra lo stimolo e salva il timestamp di onset
