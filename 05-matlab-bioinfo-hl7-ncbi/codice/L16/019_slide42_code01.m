% PSYCHTOOLBOX — tutte le funzioni Screen richiedono finestra aperta e sca al termine

PsychDefaultSetup(2);                 % allinea colori, sync tests, disabilita avvisi non critici
% AssertOpenGL;                       % opzionale: verifica driver OpenGL prima di aprire finestre

screens = Screen('Screens');          % indici monitor: 0 = primario, >0 = secondari
screenNumber = max(screens);          % spesso si usa il proiettore come ultimo indice

% Colori in spazio normalizzato 0–1 (dipende da bit depth / floating point drawable)
white = WhiteIndex(screenNumber);  % assegna il risultato a white
black = BlackIndex(screenNumber);  % assegna il risultato a black
grey = (white + black) / 2;  % assegna il risultato a grey

% Finestra fullscreen; PsychImaging consente pipeline imaging avanzata (blend, LUT, …)
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, grey);  % assegna il risultato a [window, windowRect]

[xCenter, yCenter] = RectCenter(windowRect);   % centro [px, px] per posizionare stimoli
[screenXpx, screenYpx] = Screen('WindowSize', window);  % assegna il risultato a [screenXpx, screenYpx]
ifi = Screen('GetFlipInterval', window);     % intervallo tra frame (tip. 1/60 s su LCD 60 Hz)
fps = 1 / ifi;                               % stima refresh rate del display
