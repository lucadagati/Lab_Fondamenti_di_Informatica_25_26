tmpFile = [tempname '.fasta'];  % crea un percorso temporaneo per il file FASTA
fid = fopen(tmpFile, 'w');  % apre il file temporaneo in scrittura
fprintf(fid, '>seq_demo Homo sapiens\nATGCGTACGTTAGC\n');  % scrive un record FASTA minimale
fclose(fid);  % chiude il file dopo la scrittura

seqs = fastaread(tmpFile);  % legge il contenuto FASTA dal file appena creato
disp(seqs.Header)  % mostra l'intestazione del record
disp(seqs.Sequence)  % mostra la sequenza nucleotidica letta

delete(tmpFile);  % elimina il file temporaneo per lasciare pulita la cartella
