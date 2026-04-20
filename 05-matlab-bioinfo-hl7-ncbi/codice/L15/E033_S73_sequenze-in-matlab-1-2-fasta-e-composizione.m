% Opzione A — da file: metti un .fasta nella cartella corrente e decommenta
% seqs = fastaread('sequenze.fasta');
% seq = seqs(1).Sequence;

% Opzione B — stringa di esempio (nessun file richiesto)
seq = 'ATGCGATCGATCGATCGTACGATCG';  % assegna il risultato a seq
comp = basecount(seq)  % assegna il risultato a comp
% comp.A = 6, comp.T = 6, comp.G = 7, comp.C = 6

% Contenuto GC (stabilità DNA)
gc = (comp.G + comp.C) / length(seq) * 100;  % assegna il risultato a gc
fprintf('Contenuto GC: %.1f%%\n', gc);
