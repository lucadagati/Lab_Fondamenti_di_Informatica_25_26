% Ingressi:
%   qrs_locations — indici campione dei picchi R (vettore monotono crescente)
%   fs            — frequenza di campionamento [Hz]

RR_ms = diff(qrs_locations) / fs * 1000;   % intervalli RR in ms (da post-processing escludere artefatti)

% --- Dominio del tempo (linee guida Task Force HRV, 1996) ---
SDNN = std(RR_ms, 'omitnan');              % variabilità globale lungo la registrazione
dRR = diff(RR_ms);  % assegna il risultato a dRR
RMSSD = sqrt(mean(dRR.^2, 'omitnan'));     % Root Mean Square of Successive Differences
pNN50 = 100 * mean(abs(dRR) > 50, 'omitnan');  % frazione di |ΔRR| > 50 ms tra battiti successivi

fprintf('SDNN: %.1f ms | RMSSD: %.1f ms | pNN50: %.1f%%\n', SDNN, RMSSD, pNN50);

% Nota: con pochi picchi R (numel(qrs_locations) < 3) le metriche non sono statisticamente significative.
