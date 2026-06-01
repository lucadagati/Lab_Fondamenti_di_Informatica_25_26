% Recuperare una sequenza da GenBank
S = getgenbank('M10051');  % recupera un record da GenBank

% Esplorare la struttura
if isfield(S, 'LocusName')  % verifica presenza nome locus
    disp(S.LocusName)  % mostra il nome del locus
end  % chiude il controllo su LocusName

if isfield(S, 'Definition')  % verifica presenza descrizione record
    disp(S.Definition)  % mostra la descrizione testuale
end  % chiude il controllo su Definition

if isfield(S, 'Organism')  % verifica campo Organism
    disp(S.Organism)  % mostra organismo dalla chiave standard
elseif isfield(S, 'SourceOrganism')  % fallback per compatibilità tra release
    disp(S.SourceOrganism)  % mostra organismo dalla chiave alternativa
