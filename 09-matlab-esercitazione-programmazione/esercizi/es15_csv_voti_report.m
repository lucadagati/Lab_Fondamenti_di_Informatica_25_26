% ES 15 - Report voti (versione semplice)
% Testo del problema:
% Abbiamo gia importato da CSV due array:
% - nomi studenti
% - voti finali
%
% Dobbiamo costruire un piccolo report automatico che mostri:
% 1) media dei voti
% 2) quanti studenti sono insufficienti (voto < 18)
% 3) nome e voto dello studente migliore
%
% Implementazione consigliata:
% 1) usa un ciclo for per calcolare somma e conteggio insufficienze
% 2) aggiorna massimo e indice del migliore durante il ciclo
% 3) stampa il report finale con fprintf

nomi = ["Anna", "Luca", "Marta", "Paolo"];
voti = [28, 17, 30, 22];

somma_voti = 0;
insufficienti = 0;
best_voto = -inf;
idx_best = 1;

for i = 1:length(voti)
    somma_voti = somma_voti + voti(i);

    if voti(i) < 18
        insufficienti = insufficienti + 1;
    end

    if voti(i) > best_voto
        best_voto = voti(i);
        idx_best = i;
    end
end

media_voti = somma_voti / length(voti);
best_nome = nomi(idx_best);

fprintf("Media voti: %.2f\n", media_voti);
fprintf("Insufficienti: %d\n", insufficienti);
fprintf("Miglior studente: %s (%d)\n", best_nome, best_voto);
