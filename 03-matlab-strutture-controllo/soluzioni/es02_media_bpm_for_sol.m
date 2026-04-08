% Soluzione esercizio 2: media e massimo BPM con for

bpm = [72, 85, 90, 78, 110, 95, 88];

somma = 0;
massimo = -inf;

for i = 1:length(bpm)
    valore = bpm(i);
    somma = somma + valore;
    if valore > massimo
        massimo = valore;
    end
end

media = somma / length(bpm);

fprintf('Media BPM: %.2f\n', media);
fprintf('Massimo BPM: %.2f\n', massimo);
