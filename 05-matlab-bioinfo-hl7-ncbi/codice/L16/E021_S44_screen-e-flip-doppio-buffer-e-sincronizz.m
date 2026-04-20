% Tutte le primitive disegnano nel back-buffer fino al prossimo Screen('Flip')

% FillRect: rettangolo pieno RGB in [0–1], rect = [left top right bottom] in pixel schermo
Screen('FillRect', window, [1 0 0], [100 100 300 200]);  % esegue il passo corrente della pipeline

% FillOval: ellisse inscritta nel rettangolo di delimitazione (cerchio se lato fisso)
Screen('FillOval', window, [0 1 0], [400 100 500 200]);  % esegue il passo corrente della pipeline

% DrawLine: segmento da (x1,y1) a (x2,y2), penWidth in pixel
Screen('DrawLine', window, [0 0 1], 100, 250, 500, 250, 3);  % esegue il passo corrente della pipeline

% Testo: DrawFormattedText gestisce word-wrap e allineamenti 'center', 'right', …
Screen('TextSize', window, 48);  % esegue il passo corrente della pipeline
Screen('TextFont', window, 'Arial');  % esegue il passo corrente della pipeline
DrawFormattedText(window, 'Premi SPAZIO per continuare', 'center', 'center', white);  % esegue il passo corrente della pipeline
