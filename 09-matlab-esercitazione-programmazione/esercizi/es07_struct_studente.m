% ES 7 - Struct studente con validazione e fascia voto
% Testo (ben spiegato): creare una struct studente con campi nome,
% voto, lode e cfu. Verificare che il voto sia nell'intervallo 0..30.
% Se il voto non e valido, stampare errore. Se valido, classificare:
% con lode (voto=30 e lode=true), promosso (voto>=18), bocciato (<18).
% In aggiunta, assegnare fascia: base (18-23), buona (24-27), ottima (28-30).
% Implementazione consigliata:
% 1) Definire la struct con tutti i campi richiesti.
% 2) Delegare il controllo validita voto a una funzione locale.
% 3) Delegare esito e fascia a due funzioni locali dedicate.
% 4) Stampare una riga finale completa con tutti i campi utili.

studente.nome = "Giulia";                                % Inserisce il nome della studentessa nel campo nome.
studente.voto = 30;                                       % Inserisce il voto in trentesimi nel campo voto.
studente.lode = true;                                     % Inserisce il valore booleano che indica la presenza della lode.
studente.cfu = 9;                                         % Inserisce i crediti formativi dell'esame nel campo cfu.

if ~voto_valido(studente.voto)                           % Controlla validita del voto richiamando una funzione locale dedicata.
    fprintf("Errore: voto non valido per %s\n", studente.nome); % Stampa un messaggio di errore in caso di input fuori range.
else                                                      % Entra nel ramo in cui il voto e valido e classificabile.
    esito = calcola_esito(studente.voto, studente.lode); % Calcola l'esito finale richiamando una funzione locale dedicata.
    fascia = calcola_fascia_voto(studente.voto);          % Calcola la fascia del voto richiamando una funzione locale dedicata.

    fprintf("%s | voto=%d | cfu=%d | esito=%s | fascia=%s\n", studente.nome, studente.voto, studente.cfu, esito, fascia); % Stampa il riepilogo completo dello studente.
end                                                       % Chiude il blocco principale di validazione/classificazione.

function ok = voto_valido(voto)                           % Definisce una funzione locale che controlla se il voto rientra nell'intervallo ammesso.
    ok = voto >= 0 && voto <= 30;                         % Restituisce vero solo quando il voto e compreso tra 0 e 30 inclusi.
end                                                       % Chiude la funzione locale voto_valido.

function esito = calcola_esito(voto, lode)                % Definisce una funzione locale che determina l'esito finale dell'esame.
    if voto == 30 && lode                                 % Verifica la condizione specifica per il massimo con lode.
        esito = "con lode";                              % Restituisce esito con lode nel caso massimo.
    elseif voto >= 18                                     % Verifica il caso di voto sufficiente.
        esito = "promosso";                              % Restituisce esito promosso quando il voto e almeno 18.
    else                                                  % Gestisce il caso di voto insufficiente.
        esito = "bocciato";                              % Restituisce esito bocciato quando il voto e sotto 18.
    end                                                   % Chiude il blocco di classificazione dell'esito.
end                                                       % Chiude la funzione locale calcola_esito.

function fascia = calcola_fascia_voto(voto)               % Definisce una funzione locale che assegna la fascia qualitativa del voto.
    if voto < 18                                          % Controlla se il voto appartiene alla fascia insufficiente.
        fascia = "insufficiente";                        % Restituisce fascia insufficiente.
    elseif voto <= 23                                     % Controlla se il voto appartiene alla fascia base.
        fascia = "base";                                 % Restituisce fascia base.
    elseif voto <= 27                                     % Controlla se il voto appartiene alla fascia buona.
        fascia = "buona";                                % Restituisce fascia buona.
    else                                                  % Gestisce il caso residuo di voto elevato.
        fascia = "ottima";                               % Restituisce fascia ottima.
    end                                                   % Chiude il blocco di classificazione della fascia.
end                                                       % Chiude la funzione locale calcola_fascia_voto.
