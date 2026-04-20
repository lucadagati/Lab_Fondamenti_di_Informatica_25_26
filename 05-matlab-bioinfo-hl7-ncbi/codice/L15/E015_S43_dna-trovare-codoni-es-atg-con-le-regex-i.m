dna = 'ATGCGATCGATAGCTAGTAACGATCGTGA';  % assegna il risultato a dna

% Pattern per codone START
start_codons = regexp(dna, 'ATG', 'match')  % applica una ricerca con espressione regolare
% Risultato: {'ATG', 'ATG'}

% Pattern per codoni STOP (TAA | TAG | TGA)
stop_codons = regexp(dna, 'T(AA|AG|GA)', 'match')  % applica una ricerca con espressione regolare
% Risultato: {'TAG', 'TAA', 'TGA'}

% Trovare tutti i codoni (gruppi di 3 basi)
codoni = regexp(dna, '[ATCG]{3}', 'match');  % applica una ricerca con espressione regolare

% Validare una sequenza (solo basi ATCG)
isValid = ~isempty(regexp(dna, '^[ATCG]+$', 'match'));  % applica una ricerca con espressione regolare
