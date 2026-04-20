if isfield(S, 'Sequence') && strlength(string(S.Sequence)) >= 100  % verifica lunghezza minima della sequenza
    disp(S.Sequence(1:100))  % mostra le prime 100 basi
elseif isfield(S, 'Sequence')  % sequenza presente ma più corta
    disp(S.Sequence)  % mostra l'intera sequenza disponibile
else  % sequenza assente nel record
    disp('Campo Sequence non presente nel record')  % avviso diagnostico
end  % chiude il controllo sulla sequenza

% Salvare su file in formato GenBank
getgenbank('M10051', 'ToFile', 'insulin.gb')  % salva il record completo su file locale

% Salvare su file in formato FASTA
getgenbank('M10051', 'FileFormat', 'FASTA', 'ToFile', 'seq.fasta')  % salva la sola sequenza in FASTA
