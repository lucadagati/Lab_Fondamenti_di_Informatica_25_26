% Soluzione esercizio 3: validazione input con while

spo2 = input('Inserisci SpO2 (0-100): ');

while spo2 < 0 || spo2 > 100
    fprintf('Valore non valido. Riprova.\n');
    spo2 = input('Inserisci SpO2 (0-100): ');
end

fprintf('SpO2 accettata: %.1f\n', spo2);
