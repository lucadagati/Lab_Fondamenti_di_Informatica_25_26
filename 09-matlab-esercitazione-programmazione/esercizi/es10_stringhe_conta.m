% ES 10 - Matrice differenze assolute (for annidati)
% Testo del problema:
% Dato un vettore di numeri interi, costruire una matrice M in cui:
%   M(i,j) = valore assoluto di (v(i) - v(j))
%
% Obiettivi:
% 1) usare due cicli for annidati per riempire tutta la matrice;
% 2) stampare la matrice risultante;
% 3) contare quante celle della matrice sono uguali a 0.
%
% Implementazione consigliata:
% - ciclo esterno su i (righe)
% - ciclo interno su j (colonne)
% - in ogni cella calcolare la differenza assoluta

v = [3, 7, 2, 7, 5];
n = length(v);
M = [];
contatore_zeri=0;

for i = 1:n
    for j = 1:n
        diff = v(i) - v(j);
        if diff < 0
            diff = -diff;
        end
        if diff==0
            contatore_zeri=contatore_zeri+1
        end
        M(i, j) = diff;
    end
end
%% 


zeri = 0;
for i = 1:n
    for j = 1:n
        if M(i, j) == 0
            zeri = zeri + 1;
        end
    end
end

disp("Matrice differenze assolute:");
disp(M);
fprintf("Numero celle uguali a 0: %d\n", zeri);
