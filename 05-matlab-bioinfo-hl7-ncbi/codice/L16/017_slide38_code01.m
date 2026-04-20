% --- Pipeline tipica: caricamento → task QRS → esecuzione ---
ECGw = ECGwrapper('recording_name', 'percorso/della/registrazione');  % assegna il risultato a ECGw
ECGw.output_path = fullfile(pwd, 'results_ecg');   % cartella output (cache, referti intermedi)
ECGw.ECGtaskHandle = 'QRS_detection';  % assegna il risultato a ECGw.ECGtaskHandle

% Lista detector: confronta più algoritmi (utile in ricerca; in clinica si fissa un validato)
ECGw.ECGtaskHandle.detectors = {'gqrs', 'wavedet', 'pantompkins'};  % assegna il risultato a ECGw.ECGtaskHandle.detectors

ECGw.cacheResults = true;   % evita ricalcoli se si ripete Run() con stessi parametri
ECGw.Run();                 % può richiedere tempo su lunghe registrazioni

% Risultato: indici di picco QRS in campioni (vettore 1×Nbeats). Nome campo = detector usato.
qrs_idx = ECGw.Result.gqrs;              % esempio: output del detector gqrs
RR_sec = diff(qrs_idx) / ECGw.ECG_header.freq;   % intervalli RR in secondi
HR_inst = 60 ./ RR_sec;                  % frequenza cardiaca istantanea [bpm] beat-to-beat
