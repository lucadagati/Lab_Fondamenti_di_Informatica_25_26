    isMale = patients.Gender == 'M';  % costruisce una maschera logica per i soggetti maschi
    patients.Hemoglobin = 14 + 1.5*double(isMale) + randn(n,1)*1.2;  % simula emoglobina con differenza media per sesso
    patients.Glucose = 90 + exprnd(15, n, 1);  % simula glucosio con coda destra

    missingProb = 0.05 + 0.10 * double(patients.Age > 70);  % aumenta la probabilità di mancanti sopra i 70 anni
    varNames = {'Hemoglobin', 'Glucose'};  % definisce le variabili in cui inserire NaN
    for k = 1:numel(varNames)  % scorre le variabili selezionate
        mask = rand(n,1) < missingProb;  % genera una maschera casuale dei valori mancanti
        patients.(varNames{k})(mask) = NaN;  % inserisce NaN nelle posizioni selezionate
    end  % chiude il ciclo sulle variabili da degradare
end  % chiude la funzione
