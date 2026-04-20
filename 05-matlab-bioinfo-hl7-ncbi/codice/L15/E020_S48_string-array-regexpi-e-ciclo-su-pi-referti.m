referti = [  % definisce un array di stringhe, una riga per referto
  "Glicemia 92 mg/dL"  % esempio senza due punti
  "glicemia: 105 mg/dl"  % esempio con due punti e unità minuscola
  "GLICEMIA   88  mg/dL"  % esempio con maiuscole e spazi multipli
];  % chiude l'array dei referti da analizzare
pat = 'glicemia\s*:?\s*(\d+)\s*mg/dL';  % rende il due punti opzionale e cattura il valore numerico
for i = 1:numel(referti)  % scorre tutte le righe del vettore referti
  tok = regexpi(referti(i), pat, 'tokens', 'once');  % estrae il primo match in modo case-insensitive
  if ~isempty(tok)  % verifica che sia stato trovato almeno un valore
    fprintf('Riga %d: %s mg/dL\n', i, tok{1});  % stampa il valore catturato (con 'once' basta tok{1})
  else  % gestisce il caso in cui la riga non rispetti il pattern
    fprintf('Riga %d: nessun valore glicemia trovato\n', i);  % segnala assenza di match
  end  % chiude il controllo presenza match
end  % chiude il ciclo su tutte le righe
