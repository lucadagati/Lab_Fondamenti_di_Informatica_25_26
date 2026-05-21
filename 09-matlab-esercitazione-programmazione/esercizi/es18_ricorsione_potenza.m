% ES 18 - Ricorsione: potenza a^n
% Testo: calcolare ricorsivamente a^n con n intero >= 0.
% Esempio: 3^4 = 81

a = 3;
n = 6;
risultato = potenza_ric(a, n);

fprintf("%d^%d = %d\n", a, n, risultato);

function p = potenza_ric(base, n)
    if n == 0
        p = 1
        disp("esponente è zero")
    else
        disp("sto richiamando la funzione")
        disp("esponente è")
        disp(n-1)
        p = base * potenza_ric(base, n - 1);
        disp("ho ottenuto il prodetto dell'invocazione")
        disp(p)
        disp("fine esecuzione funzione")
    end
end
