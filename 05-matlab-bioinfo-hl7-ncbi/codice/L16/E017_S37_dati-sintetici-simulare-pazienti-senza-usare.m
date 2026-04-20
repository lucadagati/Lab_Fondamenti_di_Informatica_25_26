function patients = generateSyntheticEHR(n)  % definisce la funzione e la firma
% GENERATESYNTHETICEHR — Crea una table di n pazienti fittizi (solo didattica / test software).
% Non sostituisce dati reali per validazione clinica: serve a pipeline, UI e unit test.

    rng(42, 'twister');  % fissa il seed per rendere i risultati riproducibili

    patients = table();  % crea una tabella vuota in memoria
    patients.ID = (1:n)';  % assegna un ID progressivo a ogni paziente
    patients.Age = round(20 + betarnd(2, 5, n, 1) * 70);  % genera età con prevalenza di adulti/anziani
    patients.Gender = categorical(randsample({'M','F'}, n, true, [0.48, 0.52]));  % genera il sesso con proporzioni plausibili

    patients.SystolicBP = 120 + randn(n,1)*15 + (patients.Age-50)*0.5;  % simula pressione sistolica correlata con età
    patients.DiastolicBP = 0.55 * patients.SystolicBP + randn(n,1)*8;  % simula diastolica correlata alla sistolica
    patients.HeartRate = 75 - 0.2*(patients.Age-40) + randn(n,1)*12;  % simula frequenza cardiaca con lieve trend per età
