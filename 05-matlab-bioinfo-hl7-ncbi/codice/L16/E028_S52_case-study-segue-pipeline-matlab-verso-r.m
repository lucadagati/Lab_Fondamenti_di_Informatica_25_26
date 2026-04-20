    if pvc_burden > 10  % controlla se il burden PVC supera la soglia didattica
        alert_level = 'ALTO';  % imposta un alert alto
        alert_msg = sprintf(['Burden PVC = %.1f%% — in scenario reale si collega a ', ...
            'workflow clinico e referto strutturato (CDA).'], pvc_burden);  % costruisce un messaggio esplicativo
    else  % gestisce il caso sotto soglia
        alert_level = 'NORMALE';  % imposta un alert normale
        alert_msg = 'Burden PVC sotto soglia didattica; verificare sempre tracciato grezzo.';  % descrive il caso non critico
    end  % chiude la logica decisionale

    report = struct( ...  % costruisce la struct finale del report
        'patient_id', patientID, ...  % salva l identificativo paziente
        'alert', alert_level, ...  % salva il livello di alert
        'message', alert_msg, ...  % salva il messaggio clinico sintetico
        'pvc_count', n_pvc, ...  % salva il numero di PVC rilevati
        'pvc_burden_pct', pvc_burden, ...  % salva la percentuale di burden PVC
        'timestamp', datetime('now', 'TimeZone', 'Europe/Rome') ...  % aggiunge il timestamp di generazione
        );
end  % chiude la funzione
