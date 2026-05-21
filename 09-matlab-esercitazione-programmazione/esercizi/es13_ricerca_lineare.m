% ES 13 - Ricerca lineare estesa (informatica pratica)
% Testo del problema:
% In un log di codici evento, vogliamo analizzare quante volte compare
% un codice specifico (chiave) e in quali posizioni.
%
% Obiettivi:
% 1) trovare la prima occorrenza con stop anticipato (break);
% 2) trovare tutte le posizioni della chiave;
% 3) stampare conteggio totale, ultima occorrenza e percentuale sul totale.

array = [7 3 9 3 1 3 8 2 3];
chiave = 3;

% Prima ricerca: prima occorrenza con uscita anticipata.
prima_pos = -1;
confronti_primo = 0;
for i = 1:length(array)
    confronti_primo = confronti_primo + 1;
    if array(i) == chiave
        prima_pos = i;
        break;
    end
end

% Seconda ricerca: scansione completa per tutte le occorrenze.
posizioni = [];
conta = 0;
ultima_pos = -1;
for i = 1:length(array)
    if array(i) == chiave
        conta = conta + 1;
        ultima_pos = i;
        posizioni(end + 1) = i; %#ok<AGROW>
    end
end

if conta == 0
    fprintf("Chiave %d non trovata\n", chiave);
else
    percentuale = (conta / length(array)) * 100;
    fprintf("Chiave %d trovata\n", chiave);
    fprintf("Prima occorrenza: %d (confronti=%d)\n", prima_pos, confronti_primo);
    fprintf("Ultima occorrenza: %d\n", ultima_pos);
    fprintf("Conteggio totale: %d\n", conta);
    fprintf("Percentuale sul vettore: %.2f%%\n", percentuale);
    fprintf("Posizioni trovate: ");
    disp(posizioni);
end
