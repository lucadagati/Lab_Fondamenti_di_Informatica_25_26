    % --- PID-7: data di nascita (spesso YYYYMMDD; tronco a 8 caratteri se serve) ---
    dobStr = pidSegment{8};  % assegna il risultato a dobStr
    if isempty(dobStr)  % controllo condizione di validità
        patient.birthDate = NaT;  % assegna il risultato a patient.birthDate
    else  % ramo alternativo
        patient.birthDate = datetime(dobStr(1:min(8,end)), 'InputFormat', 'yyyyMMdd');  % assegna il risultato a patient.birthDate
    end  % chiude blocco di controllo

    patient.gender = pidSegment{9};    % PID-8: sesso amministrativo
    patient.address = pidSegment{12};  % PID-11: indirizzo (XAD)
end  % chiude blocco di controllo
