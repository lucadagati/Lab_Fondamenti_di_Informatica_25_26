% IMPORTANTE: esearch restituisce UID numerici Entrez; getgenbank() vuole accessioni (es. NM_..., M10051).
baseURL = 'https://eutils.ncbi.nlm.nih.gov/entrez/eutils/';  % assegna il risultato a baseURL
opts = weboptions('Timeout', 45, 'ContentType', 'text');  % assegna il risultato a opts

searchURL = [baseURL 'esearch.fcgi?db=nuccore&retmax=3&retmode=xml&term=insulin+AND+homo+sapiens%5Borganism%5D'];  % assegna il risultato a searchURL
searchReport = webread(searchURL, opts);  % scarica dati dal servizio web
ids = regexp(searchReport, '
(\d+)
', 'tokens');  % applica una ricerca con espressione regolare
