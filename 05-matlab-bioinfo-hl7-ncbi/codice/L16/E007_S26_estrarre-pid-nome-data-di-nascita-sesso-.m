function patient = extractPatientFromPID(pidSegment)  % definisce la funzione e la firma
% EXTRACTPATIENTFROMPID — Estrae campi anagrafici dal segmento PID (messaggio HL7 v2).
% Ingresso: pidSegment = cell array da strsplit sulla riga PID usando '|' come separatore.
% Gli indici {4}, {6}, … dipendono dalla convenzione PID-3, PID-5, … (vedi guida HL7).

    patient = struct();  % costruisce una struct con i campi

    % --- PID-3: Patient Identifier List (ID interno, CF, tessera, …) ---
    patient.id = pidSegment{4};  % assegna il risultato a patient.id

    % --- PID-5: Patient Name (formato XPN: Cognome^Nome^…) ---
    nameStr = pidSegment{6};  % assegna il risultato a nameStr
    nameParts = strsplit(nameStr, '^');  % divide una stringa in parti
    patient.lastName = nameParts{1};  % assegna il risultato a patient.lastName
    if numel(nameParts) >= 2  % controllo condizione di validità
        patient.firstName = nameParts{2};  % assegna il risultato a patient.firstName
    else  % ramo alternativo
        patient.firstName = '';  % assegna il risultato a patient.firstName
    end  % chiude blocco di controllo

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
