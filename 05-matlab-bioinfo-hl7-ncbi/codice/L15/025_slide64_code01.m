seq1 = 'ACGTACGTACGT';  % definisce la prima sequenza da confrontare
seq2 = 'ACGTTCGTACGT';  % definisce la seconda sequenza da confrontare

[score_g, align_g] = nwalign(seq1, seq2); % globale
[score_l, align_l] = swalign(seq1, seq2); % locale
