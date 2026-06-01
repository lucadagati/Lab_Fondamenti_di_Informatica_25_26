% Soluzione esercizio 3: validazione input con while

% Chiediamo un primo valore di SpO2 all'utente.
spo2 = input('Inserisci SpO2 (0-100): ');

% Ripetiamo finche il valore non rientra nell'intervallo valido.
while spo2 < 0 || spo2 > 100
    % Informiamo l'utente che il valore non e valido.
    fprintf('Valore non valido. Riprova.
');
    % Richiediamo nuovamente il valore.
    spo2 = input('Inserisci SpO2 (0-100): ');
end

% Quando usciamo dal while, il valore e valido e lo stampiamo.
fprintf('SpO2 accettata: %.1f
', spo2);
