% Soluzione 5 - Patterns
righe = ["bpm:101", "spo2:94", "eta:67", "bad_format"];
pat = lettersPattern + ":" + digitsPattern;

chiavi = strings(0,1);
valori = zeros(0,1);

for i = 1:numel(righe)
    r = righe(i);
    if ~matches(r, pat)
        continue
    end
    parts = split(r, ":");
    chiavi(end+1,1) = parts(1); %#ok<SAGROW>
    valori(end+1,1) = str2double(parts(2)); %#ok<SAGROW>
end

T = table(chiavi, valori);
disp(T)
