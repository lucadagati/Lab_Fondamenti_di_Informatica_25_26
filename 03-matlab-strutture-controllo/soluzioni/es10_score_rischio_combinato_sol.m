% Soluzione esercizio 10: mini score rischio

n = input('Numero pazienti: ');

for p = 1:n
    fprintf('--- Paziente %d ---\n', p);

    eta = input('Eta: ');
    while eta < 0
        fprintf('Eta non valida. Riprova.\n');
        eta = input('Eta: ');
    end

    bpm = input('Frequenza cardiaca (bpm): ');
    sistolica = input('Pressione sistolica: ');

    score = 0;
    if eta >= 65
        score = score + 2;
    end
    if bpm >= 100
        score = score + 1;
    end
    if sistolica >= 140
        score = score + 2;
    end

    if score <= 1
        classe = 'Basso';
    elseif score <= 3
        classe = 'Medio';
    else
        classe = 'Alto';
    end

    fprintf('Score: %d -> Rischio: %s\n', score, classe);
end
