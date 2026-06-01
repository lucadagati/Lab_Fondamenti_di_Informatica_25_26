seq1 = 'ACGTACGTACGT';  % assegna il risultato a seq1
seq2 = 'ACGTTCGTACGT';  % assegna il risultato a seq2

% Allineamento globale (Needleman-Wunsch)
[score_g, align_g] = nwalign(seq1, seq2);  % assegna il risultato a [score_g, align_g]
disp(align_g)  % mostra il valore a video

% Allineamento locale (Smith-Waterman)
[score_l, align_l] = swalign(seq1, seq2);  % assegna il risultato a [score_l, align_l]
