for i = 1:min(3, numel(ids))  % ciclo sui valori previsti
    uid = ids{i}{1};  % assegna il risultato a uid
    pause(0.35); % NCBI: ~3 richieste/s senza API key
    sumURL = sprintf('%sesummary.fcgi?db=nuccore&id=%s&retmode=xml', baseURL, uid);  % assegna il risultato a sumURL
    sumXml = webread(sumURL, opts);  % scarica dati dal servizio web
    accTok = regexp(sumXml, '
]*>([^<]+)
', 'tokens', 'once');  % applica una ricerca con espressione regolare
    if isempty(accTok)  % controllo condizione di validità
        continue  % esegue il passo corrente della pipeline
    end  % chiude blocco di controllo
    acc = strtrim(accTok{1});  % assegna il risultato a acc
    S = getgenbank(acc);  % recupera un record da GenBank
    fprintf('%s
', S.Definition);  % stampa un messaggio formattato
end  % chiude blocco di controllo
