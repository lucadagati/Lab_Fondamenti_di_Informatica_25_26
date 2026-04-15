% Soluzione esercizio 10: mini score rischio

% Chiediamo quanti pazienti inserire.
n = input('Numero pazienti: ');

% Cicliamo su ogni paziente.
for p = 1:n
    % Stampiamo separatore con numero paziente.
    fprintf('--- Paziente %d ---
', p);

    % Leggiamo eta iniziale.
    eta = input('Eta: ');
    % Validiamo eta: non deve essere negativa.
    while eta < 0
        % Messaggio di errore all'utente.
        fprintf('Eta non valida. Riprova.
');
        % Richiediamo nuovamente eta.
        eta = input('Eta: ');
    end

    % Leggiamo frequenza cardiaca.
    bpm = input('Frequenza cardiaca (bpm): ');
    % Leggiamo pressione sistolica.
    sistolica = input('Pressione sistolica: ');

    % Inizializziamo score a zero.
    score = 0;

    % Se eta e almeno 65 aggiungiamo 2 punti.
    if eta >= 65
        score = score + 2;
    end
    % Se bpm e almeno 100 aggiungiamo 1 punto.
    if bpm >= 100
        score = score + 1;
    end
    % Se sistolica e almeno 140 aggiungiamo 2 punti.
    if sistolica >= 140
        score = score + 2;
    end

    % Classificazione rischio basso per score 0-1.
    if score <= 1
        classe = 'Basso';
    % Classificazione rischio medio per score 2-3.
    elseif score <= 3
        classe = 'Medio';
    % Classificazione rischio alto per score >= 4.
    else
        classe = 'Alto';
    end

    % Stampiamo risultato finale per paziente.
    fprintf('Score: %d -> Rischio: %s
', score, classe);
end
