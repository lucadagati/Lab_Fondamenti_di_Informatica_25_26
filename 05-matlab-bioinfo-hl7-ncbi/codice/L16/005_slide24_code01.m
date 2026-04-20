function msg = parseHL7Message(rawMessage)  % definisce la funzione e la firma
% PARSEHL7MESSAGE — Converte una stringa HL7 v2 in una struct MATLAB (esempio didattico).
% Limitazioni tipiche: segmenti ripetuti (es. più OBX), sequenze di escape HL7 (\T\ \| …), charset.

    rawMessage = strrep(rawMessage, [char(13) char(10)], char(13));  % normalizza i terminatori Windows in carriage return
    lines = strsplit(strtrim(rawMessage), char(13));  % divide il messaggio nelle singole righe HL7

    msg = struct();  % crea la struct contenitore del messaggio
    msg.segments = struct();  % crea il sotto-campo che ospiterà i segmenti
    msg.raw = rawMessage;  % conserva il messaggio originale completo
