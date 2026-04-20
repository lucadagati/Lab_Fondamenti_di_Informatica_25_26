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
