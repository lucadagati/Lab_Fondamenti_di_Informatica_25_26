% Trova DOVE compare il pattern
indici = regexp(testo, pattern)  % applica una ricerca con espressione regolare

% Trova COSA corrisponde al pattern  
match = regexp(testo, pattern, 'match')  % applica una ricerca con espressione regolare

% Sostituisci le corrispondenze
nuovo = regexprep(testo, pattern, sostituzione)  % sostituisce pattern nel testo
