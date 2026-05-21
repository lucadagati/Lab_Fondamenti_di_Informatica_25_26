% ES 16 - Ricorsione: somma cifre
% Testo: calcolare la somma delle cifre di un intero non negativo n.
% Esempio: n = 5721 -> 5+7+2+1 = 15

n = 5721;
s = somma_cifre(n);

fprintf("n=%d, somma cifre=%d\n", n, s);

function out = somma_cifre(x)
    if x < 10
        out = x;
    else
        out = mod(x, 10) + somma_cifre(floor(x / 10));
    end
end
