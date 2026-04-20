% ECGwrapper: oggetto "facciata" unica per molti formati (MIT, HL7-aECG, …)
ECGw = ECGwrapper('recording_name', '/percorso/completo/al/file.ext');  % assegna il risultato a ECGw

disp(ECGw)   % riepilogo proprietà: path, task associati, stato cache, …

% Metadati nel campo ECG_header (nomi e unità dipendono dal driver del formato)
fs = ECGw.ECG_header.freq;        % frequenza di campionamento [Hz]
leads = ECGw.ECG_header.desc;     % elenco derivazioni (cell array di stringhe o char)
nsamp = ECGw.ECG_header.nsamp;    % numero totale di campioni per canale
duration_sec = nsamp / fs;        % durata registrazione [s]

fprintf('Registrazione: %d derivazioni, %.1f min @ %d Hz\n', ...
    numel(leads), duration_sec/60, round(fs));  % esegue il passo corrente della pipeline
