    % --- Tipo messaggio (MSH-9 tipicamente TIPO^EVENTO es. ADT^A01) ---
    if numel(msh) >= 10 && ~isempty(msh{10})  % controllo condizione di validità
        msgType = msh{10};  % assegna il risultato a msgType
        if contains(msgType, 'ADT') && ~isfield(msg.segments, 'PID')  % controllo condizione di validità
            errors{end+1} = 'ERROR: messaggio ADT senza segmento PID';  % assegna il risultato a errors{end+1}
        end  % chiude blocco di controllo
    end  % chiude blocco di controllo

    % Valido se non ci sono stringhe che iniziano per "ERROR"
    isValid = ~any(startsWith(errors, 'ERROR'));  % assegna il risultato a isValid
end  % chiude blocco di controllo
