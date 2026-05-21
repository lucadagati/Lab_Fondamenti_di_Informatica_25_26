% ES 14 - Controllo password (versione semplice)
% Testo del problema:
% In un piccolo gestionale informatico vogliamo controllare se una password
% puo essere accettata prima del salvataggio.
%
% Una password e valida se rispetta TUTTE queste regole:
% 1) lunghezza almeno 8 caratteri
% 2) contiene almeno una lettera maiuscola (A-Z)
% 3) contiene almeno un numero (0-9)
%
% Obiettivo:
% - stampare se ogni regola e rispettata (1/0)
% - stampare l'esito finale (1 se valida, 0 altrimenti)
%
% Implementazione consigliata:
% 1) controlla la lunghezza con strlength
% 2) scorri i caratteri con un ciclo for
% 3) usa isstrprop per capire se un carattere e maiuscolo o cifra

password = "Lab2026";

ok_lunghezza = strlength(password) >= 8;
ok_maiuscola = false;
ok_numero = false;

testo = char(password);
for i = 1:length(testo)
	c = testo(i);
	if isstrprop(c, 'upper')
		ok_maiuscola = true;
	end
	if isstrprop(c, 'digit')
		ok_numero = true;
	end
end

valida = ok_lunghezza && ok_maiuscola && ok_numero;

fprintf("Password: %s\n", password);
fprintf("Regola lunghezza>=8: %d\n", ok_lunghezza);
fprintf("Regola maiuscola: %d\n", ok_maiuscola);
fprintf("Regola numero: %d\n", ok_numero);
fprintf("Esito finale valida(1/0): %d\n", valida);
