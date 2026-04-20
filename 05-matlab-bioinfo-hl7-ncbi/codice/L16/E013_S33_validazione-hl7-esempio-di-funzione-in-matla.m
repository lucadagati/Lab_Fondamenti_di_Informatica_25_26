function [isValid, errors] = validateHL7(msg)  % definisce la funzione e la firma
% VALIDATEHL7 — Controlli minimi su struct prodotta da parseHL7Message.
% errors: cell array di stringhe; prefissi ERROR / WARNING per filtri successivi.

    errors = {};  % assegna il risultato a errors

    % --- Presenza MSH (obbligatorio in ogni messaggio HL7 v2) ---
    if ~isfield(msg.segments, 'MSH')  % controllo condizione di validità
        errors{end+1} = 'ERROR: Segmento MSH mancante';  % assegna il risultato a errors{end+1}
        isValid = false;  % assegna il risultato a isValid
        return  % termina la funzione corrente
    end  % chiude blocco di controllo
