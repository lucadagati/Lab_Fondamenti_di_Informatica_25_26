str = 'ID paz: PAZ0042, visita 2024-03-15';  % assegna il risultato a str
[tok, mat] = regexp(str, 'PAZ(\d{4})', 'tokens', 'match');  % applica una ricerca con espressione regolare
% tok{1}{1} = '0042'

[idxStart, idxEnd] = regexp(str, '\d{4}-\d{2}-\d{2}');  % trova indice iniziale e finale della data ISO
% intervallo della data nel testo

out = regexp(str, '(?
PAZ\d+)', 'names');  % struttura con campo id
