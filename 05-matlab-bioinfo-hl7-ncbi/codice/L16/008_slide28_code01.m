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

    msh = msg.segments.MSH;  % assegna il risultato a msh

    % --- Versione protocollo (MSH-12 in convenzione comune; verificare sempre il profilo IHE/regionale) ---
    if numel(msh) >= 13  % controllo condizione di validità
        version = msh{13};  % assegna il risultato a version
        if ~ismember(version, {'2.3','2.3.1','2.4','2.5','2.5.1'})  % controllo condizione di validità
            errors{end+1} = sprintf('WARNING: versione HL7 %s non nella lista prevista', version);
        end  % chiude blocco di controllo
    else  % ramo alternativo
        errors{end+1} = 'WARNING: MSH troncato — impossibile leggere la versione';  % assegna il risultato a errors{end+1}
    end  % chiude blocco di controllo
