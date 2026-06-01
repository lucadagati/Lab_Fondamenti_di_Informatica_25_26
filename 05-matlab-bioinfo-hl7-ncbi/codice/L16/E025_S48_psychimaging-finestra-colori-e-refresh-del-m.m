% PSYCHTOOLBOX — tutte le funzioni Screen richiedono finestra aperta e sca al termine

PsychDefaultSetup(2);                 % allinea colori, sync tests, disabilita avvisi non critici
% AssertOpenGL;                       % opzionale: verifica driver OpenGL prima di aprire finestre

screens = Screen('Screens');          % indici monitor: 0 = primario, >0 = secondari
screenNumber = max(screens);          % spesso si usa il proiettore come ultimo indice

% Colori in spazio normalizzato 0–1 (dipende da bit depth / floating point drawable)
white = WhiteIndex(screenNumber);  % assegna il risultato a white
black = BlackIndex(screenNumber);  % assegna il risultato a black
grey = (white + black) / 2;  % assegna il risultato a grey
