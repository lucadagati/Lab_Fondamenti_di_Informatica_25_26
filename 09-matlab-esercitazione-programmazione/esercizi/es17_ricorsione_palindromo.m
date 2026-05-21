% ES 17 - Ricorsione: verifica palindromo
% Testo: verificare ricorsivamente se una parola e palindroma.
% Esempio: "radar" e palindroma, "matlab" non lo e.

s = "radar";
esito = palindromo_ric(char(s));

fprintf("Stringa: %s\n", s);
fprintf("Palindroma (1/0): %d\n", esito);

function ok = palindromo_ric(parola)
    if length(parola) <= 1
        ok = true;
    elseif parola(1) ~= parola(end)
        ok = false;
    else
        % Richiama la funzione sulla parte "interna" della parola,
        % togliendo primo e ultimo carattere gia confrontati.
        ok = palindromo_ric(parola(2:end-1));
    end
end
