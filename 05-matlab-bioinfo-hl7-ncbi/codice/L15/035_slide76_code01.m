acc = 'M10051';  % definisce una accession GenBank valida e compatta
S = getgenbank(acc);  % scarica il record dal database nucleotide NCBI

if isfield(S, 'Definition')  % verifica che il campo descrizione sia presente
    disp(S.Definition)  % mostra la descrizione del record scaricato
end  % chiude il controllo sulla descrizione

if isfield(S, 'Sequence')  % verifica che la sequenza sia presente nella struct
    disp(S.Sequence(1:min(60, end)))  % mostra solo le prime 60 basi per non riempire la console
end  % chiude il controllo sulla sequenza
