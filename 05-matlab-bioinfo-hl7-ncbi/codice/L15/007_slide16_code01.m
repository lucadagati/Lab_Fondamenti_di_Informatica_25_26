% Simulazione ECG semplificata (versione robusta e commentata riga per riga)
fs = 500;                              % Imposta la frequenza di campionamento in Hz (500 campioni al secondo)
duration = 5;                          % Imposta la durata totale del segnale in secondi
nSamples = fs * duration + 1;          % Calcola il numero di campioni includendo sia t=0 sia t=duration
t = (0:nSamples-1)' / fs;              % Costruisce il vettore tempo come colonna (N x 1) per evitare mismatch

bpm = 72;                              % Imposta la frequenza cardiaca media in battiti al minuto
beat_interval = 60 / bpm;              % Converte i bpm in intervallo tra battiti (secondi per battito)

ecg = zeros(nSamples, 1);              % Prealloca il segnale ECG come vettore colonna pieno di zeri
qrs_shape = [linspace(0,1,6), ...      % Definisce la salita del complesso QRS (6 campioni)
             linspace(1,-0.3,5)]';     % Definisce la discesa del complesso QRS (5 campioni), poi traspone in colonna
halfWidth = 5;                         % Definisce la semi-larghezza del complesso (totale = 11 campioni)

for beat_time = 0:beat_interval:duration       % Scorre i tempi in cui inserire un battito simulato
    idx = round(beat_time * fs) + 1;           % Converte il tempo del battito nell'indice del campione MATLAB (1-based)
    if idx > halfWidth && idx <= nSamples-halfWidth  % Verifica i bordi: il segmento idx-5:idx+5 deve restare dentro il vettore
        ecg(idx-halfWidth:idx+halfWidth) = qrs_shape; % Inserisce la forma QRS nel punto corretto del segnale
    end                                         % Chiude il controllo di sicurezza sui limiti
end                                             % Chiude il ciclo su tutti i battiti simulati

ecg = ecg + 0.05 * randn(nSamples, 1);          % Aggiunge rumore gaussiano a bassa ampiezza per simulare rumore reale

figure('Position', [100 100 1000 400]);         % Crea la finestra grafica con dimensione e posizione definite
plot(t, ecg, 'b', 'LineWidth', 0.8);            % Disegna ECG in funzione del tempo (stesse dimensioni: N x 1, quindi nessun errore)
xlabel('Tempo (s)');                            % Etichetta l'asse x in secondi
ylabel('Ampiezza (mV)');                        % Etichetta l'asse y in millivolt
title('ECG Simulato - Derivazione II');         % Imposta il titolo del grafico
xlim([0 duration]);                             % Limita la vista orizzontale all'intervallo simulato
grid on;                                        % Attiva la griglia per facilitare la lettura del tracciato
