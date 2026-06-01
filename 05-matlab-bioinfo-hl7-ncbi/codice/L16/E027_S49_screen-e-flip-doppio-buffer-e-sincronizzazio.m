% vbl = "vertical blanking" timestamp (GetSecs) dell'istante in cui lo stimolo diventa visibile
vbl = Screen('Flip', window);  % assegna il risultato a vbl

WaitSecs(1);   % attesa busy-wait ad alta precisione (non usare pause() negli esperimenti)

% Secondo argomento opzionale: quando richiedere il prossimo flip (deadline assoluto GetSecs)
vbl = Screen('Flip', window, vbl + 1);  % assegna il risultato a vbl
