% Finestra fullscreen; PsychImaging consente pipeline imaging avanzata (blend, LUT, …)
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, grey);  % assegna il risultato a [window, windowRect]

[xCenter, yCenter] = RectCenter(windowRect);   % centro [px, px] per posizionare stimoli
[screenXpx, screenYpx] = Screen('WindowSize', window);  % assegna il risultato a [screenXpx, screenYpx]
ifi = Screen('GetFlipInterval', window);     % intervallo tra frame (tip. 1/60 s su LCD 60 Hz)
fps = 1 / ifi;                               % stima refresh rate del display
