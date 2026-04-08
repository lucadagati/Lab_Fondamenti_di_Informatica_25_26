% Esercizio 10: mini score rischio (if + for + while)
% TODO: completare il codice

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

    % Regole score:
    % +2 se eta >= 65
    % +1 se bpm >= 100
    % +2 se sistolica >= 140

    % TODO: applicare regole

    % Classificazione:
    % 0-1 Basso, 2-3 Medio, 4-5 Alto
    % TODO: stampare classe rischio
end
