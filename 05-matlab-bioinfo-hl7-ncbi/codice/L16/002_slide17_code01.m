% --- Messaggio HL7 v2.5 (esempio didattico) ---
% MSH: intestazione; ^~\& = caratteri di encoding; ADT^A01 = ammissione
MSH|^~\&|ACCETTAZIONE|OSPEDALE_MILANO|LAB|OSPEDALE_MILANO|20240115083000||ADT^A01|MSG00001|P|2.5
% EVN: tipo di evento (A01 = admit)
EVN|A01|20240115083000
% PID: anagrafica; ^ in PID-5 separa Cognome^Nome^Secondo nome
PID|1||PAZ123456^^^OSPEDALE^MR||ROSSI^MARIO^GIUSEPPE||19750315|M|||VIA ROMA 15^^MILANO^^20100^IT||+39021234567
% PV1: visita/ricovero; I = inpatient, reparto e medico curante
PV1|1|I|MEDICINA^201^A|E|||12345^BIANCHI^LUIGI^DR|||MED||||7|||12345^BIANCHI^LUIGI^DR|S||||||||||||||||||OSPEDALE|||20240115080000
