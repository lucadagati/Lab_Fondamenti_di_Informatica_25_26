% Recuperare porzione
S_partial = getgenbank('M10051', 'PartialSeq', [100, 500]);  % recupera un record da GenBank

% Sequenza proteica (RefSeq; verificabile su NCBI Protein)
P = getgenpept('NP_000198');  % recupera un record proteico da GenPept
