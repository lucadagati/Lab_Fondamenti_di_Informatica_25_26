seq = 'ATGCGATCGATCGATCGTACGATCG';  % come slide precedente (autocontenuto)

% Complemento inverso
rev_comp = seqrcomplement(seq);  % assegna il risultato a rev_comp

% Traduzione in proteina
proteina = nt2aa(seq);  % assegna il risultato a proteina

% Trovare Open Reading Frames (compatibile con release recenti)
startPos = regexp(seq, 'ATG');  % trova tutte le posizioni START candidate
stopPos = regexp(seq, 'TAA|TAG|TGA');  % trova tutte le posizioni STOP candidate
orfs = [];  % inizializza matrice ORF [inizio fine]
for i = 1:numel(startPos)  % scorre le posizioni start
    s0 = startPos(i);  % seleziona lo start corrente
    cand = stopPos(stopPos > s0 & mod(stopPos - s0, 3) == 0);  % filtra stop nello stesso frame
    if ~isempty(cand)  % verifica presenza di almeno uno stop valido
        orfs(end+1, :) = [s0, cand(1)+2];  % salva la prima ORF start-stop compatibile
    end  % chiude controllo stop validi
end  % chiude ciclo sulle posizioni start
