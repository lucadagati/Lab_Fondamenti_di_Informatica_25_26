% ES 11 - While con obiettivo: sbloccare accesso con PIN
% Testo del problema:
% Simulare un controllo accessi informatico con massimo 5 tentativi.
% Il ciclo while deve continuare FINCHE':
% 1) il PIN non e corretto, e
% 2) i tentativi sono <= al massimo consentito.
%
% Obiettivo finale:
% - stampare "Accesso consentito" se il PIN viene trovato,
% - altrimenti "Account bloccato" quando i tentativi finiscono.

pin_corretto = 4321;
tentativi_massimi = 5;

% Sequenza di tentativi simulata (in un programma interattivo arriverebbe da input).
tentativi = [1111, 1234, 9999, 4321, 8888];

i = 1;
accesso = false;

while i <= tentativi_massimi && ~accesso
    pin_inserito = tentativi(i);
    fprintf("Tentativo %d: PIN inserito = %d\n", i, pin_inserito);

    if pin_inserito == pin_corretto
        accesso = true;
    else
        i = i + 1;
    end
end

if accesso
    fprintf("Accesso consentito al tentativo %d\n", i);
else
    fprintf("Account bloccato dopo %d tentativi\n", tentativi_massimi);
end
