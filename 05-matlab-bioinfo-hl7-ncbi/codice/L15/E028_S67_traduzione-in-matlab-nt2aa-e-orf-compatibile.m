seq = 'ATGGCCATTGTAATGGGCCGCTGAAAGGGTGCCCGATAG';  % definisce la sequenza nucleotidica di partenza
aa = nt2aa(seq);  % traduce la sequenza in amminoacidi (codice a 1 lettera)

startPos = regexp(seq, 'ATG');  % trova le posizioni candidate di start codon
stopPos = regexp(seq, 'TAA|TAG|TGA');  % trova le posizioni candidate di stop codon
orfRanges = [];  % inizializza matrice [start stop] per ORF candidate

for i = 1:numel(startPos)  % scorre tutti i possibili start
    s0 = startPos(i);  % legge la posizione corrente di start
    cand = stopPos(stopPos > s0 & mod(stopPos - s0, 3) == 0);  % seleziona stop successivi nello stesso frame
    if ~isempty(cand)  % verifica che esista almeno uno stop compatibile
        orfRanges(end+1, :) = [s0, cand(1)+2];  % salva la prima ORF trovata (inclusa tripletta di stop)
    end  % chiude il controllo sulla presenza di stop validi
end  % chiude il ciclo sugli start codon

disp(orfRanges)  % mostra intervalli ORF [inizio fine] come fallback portabile
