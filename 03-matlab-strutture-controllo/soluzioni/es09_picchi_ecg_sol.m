% Soluzione esercizio 9: conteggio picchi locali ECG semplificato

% Definiamo segnale ECG semplificato.
x = [0.1, 0.4, 0.2, 0.8, 0.3, 0.9, 0.4, 0.2, 0.7, 0.1];
% Definiamo soglia minima per considerare un picco valido.
soglia = 0.5;

% Inizializziamo contatore picchi.
n_picchi = 0;

% Scorriamo dal secondo al penultimo elemento per poter confrontare i vicini.
for i = 2:length(x)-1
    % Se il punto corrente e maggiore del vicino sinistro,
    % maggiore del vicino destro e sopra soglia, e un picco locale valido.
    if x(i) > x(i-1) && x(i) > x(i+1) && x(i) > soglia
        % Incrementiamo il conteggio dei picchi.
        n_picchi = n_picchi + 1;
    end
end

% Stampiamo il numero totale di picchi validi.
fprintf('Numero picchi locali sopra soglia: %d
', n_picchi);
