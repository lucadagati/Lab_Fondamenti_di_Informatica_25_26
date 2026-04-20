% Esempio: incapsulare una regex in un pattern
txt = "Variant rs12345 in gene BRCA1";  % assegna il risultato a txt
pat = regexpPattern('rs\d+');  % assegna il risultato a pat
extract(txt, pat)  % estrae la sottostringa che rispetta il pattern  % esegue il passo corrente della pipeline
