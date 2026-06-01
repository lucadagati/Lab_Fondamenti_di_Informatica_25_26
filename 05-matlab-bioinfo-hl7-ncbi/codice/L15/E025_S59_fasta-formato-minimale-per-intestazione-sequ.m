% Esempio FASTA rappresentato in MATLAB
fasta_header = 'seq_001 Homo sapiens gene X';  % definisce l'intestazione FASTA senza il carattere '>'
fasta_seq = 'ATGCGTACGTTAGC';  % definisce una sequenza di esempio (qui non abbreviata)

fprintf('>%s
%s
', fasta_header, fasta_seq);  % stampa il record nel formato FASTA standard
