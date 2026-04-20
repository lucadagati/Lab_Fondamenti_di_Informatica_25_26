% Schema logico HL7 v2 (notazione ad albero — non è codice eseguibile)
% MESSAGGIO: unità di trasmissione completa (es. ADT, ORU, ACK)
MESSAGGIO  % esegue il passo corrente della pipeline
 └── SEGMENTO   % riga di testo, tipicamente terminata da CR (ASCII 13) o CR+LF
      └── CAMPO % valori separati dal carattere "|" definito in MSH-1
           └── COMPONENTE   % sotto-campi separati da "^"
                └── SOTTOCOMPONENTE  % separati da "&" (es. codici composti)
