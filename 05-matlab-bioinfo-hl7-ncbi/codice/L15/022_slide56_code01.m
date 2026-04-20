S = getgenbank('M10051');  % recupera un record GenBank per accession

if isfield(S, 'Organism')  % verifica il campo Organism (presente in molte release)
    disp(S.Organism)  % mostra organismo quando il campo è disponibile
elseif isfield(S, 'SourceOrganism')  % fallback compatibile con altre strutture
    disp(S.SourceOrganism)  % mostra organismo dal campo alternativo
else  % gestisce output con nomi campo diversi
    disp('Campo organismo non trovato: usare fieldnames(S) per ispezione')  % messaggio diagnostico
end  % chiude il controllo sul campo organismo

if isfield(S, 'Features') && ~isempty(S.Features)  % verifica presenza di almeno una feature
    disp(S.Features(1))  % mostra la prima annotazione disponibile
else  % gestisce record senza feature valorizzate
    disp('Nessuna feature disponibile in questo record')  % messaggio diagnostico
end  % chiude il controllo sulle feature
