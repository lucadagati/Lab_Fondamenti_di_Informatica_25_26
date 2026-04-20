    for i = 1:numel(lines)  % scorre tutte le righe del messaggio HL7
        line = strtrim(lines{i});  % ripulisce la riga corrente da spazi superflui
        if numel(line) < 3  % verifica che la riga abbia almeno un nome segmento valido
            continue  % salta righe vuote o troppo corte
        end  % chiude il controllo sulla lunghezza minima

        segName = line(1:3);  % estrae il nome del segmento, per esempio MSH o PID

        if strcmp(segName, 'MSH')  % controlla se il segmento corrente è MSH
            fields = [{line(1:3)}, {line(4)}, strsplit(line(5:end), '|')];  % tratta separatamente MSH-1 e poi divide gli altri campi
        else  % gestisce tutti gli altri segmenti HL7
            fields = strsplit(line, '|');  % divide la riga in campi usando | come separatore
        end  % chiude il parsing condizionale di MSH

        msg.segments.(segName) = fields;  % salva i campi del segmento nella struct con chiave dinamica
    end  % chiude il ciclo sulle righe
end  % chiude la funzione
