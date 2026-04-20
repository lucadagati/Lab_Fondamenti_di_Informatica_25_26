function report = processECGforFSE(ecgFile, patientID)  % definisce la funzione e la firma
% PROCESSECGFORFSE — Esempio integrato: pipeline ecg-kit → metriche → payload per referto/FSE.
% NOTA: soglie cliniche e export CDA reali richiedono validazione medico-legale e profili HL7.

    ECGw = ECGwrapper('recording_name', ecgFile);  % crea il wrapper della registrazione ECG

    ECGw.ECGtaskHandle = 'QRS_detection';  % seleziona il task di rilevazione dei complessi QRS
    ECGw.Run();  % esegue il detector QRS

    ECGw.ECGtaskHandle = 'Heartbeat_classification';  % seleziona il task di classificazione dei battiti
    ECGw.Run();  % esegue la classificazione AAMI dei battiti

    classification = ECGw.Result;  % recupera la struttura risultato del task corrente
    beatLabels = classification.labels;  % legge le etichette assegnate a ciascun battito
    n_pvc = sum(beatLabels == 'V');  % conta i battiti ventricolari etichettati come V
    pvc_burden = 100 * n_pvc / numel(beatLabels);  % calcola la percentuale di PVC sul totale
