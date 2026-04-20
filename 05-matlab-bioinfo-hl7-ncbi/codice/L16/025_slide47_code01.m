            responded = false;  % inizializza il flag di risposta per il trial corrente
            while ~responded  % continua finche non arriva una risposta o un timeout
                [keyDown, secs, keyCode] = KbCheck;  % legge tastiera e timestamp corrente
                if keyDown && keyCode(KbName('space'))  % verifica se è stato premuto SPAZIO
                    results.RT(trial) = (secs - stimOnset) * 1000;  % converte il tempo di reazione in ms
                    responded = true;  % termina il loop di attesa per il trial corrente
                elseif (secs - stimOnset) > 2  % controlla se il timeout supera 2 secondi
                    results.RT(trial) = NaN;  % marca il trial come senza risposta utile
                    results.valid(trial) = false;  % marca il trial come non valido
                    responded = true;  % termina il loop di attesa
                end  % chiude blocco di controllo
            end  % chiude il loop di polling tastiera

            Screen('Flip', window);  % svuota lo schermo prima del trial successivo
            WaitSecs(0.5 + 0.5*rand());  % applica un intervallo inter-trial casuale
        end  % chiude il ciclo sui trial

        sca;  % chiude tutte le finestre di Psychtoolbox
        fprintf('Media RT (trial validi): %.1f ms (dev.st. = %.1f)
', ...
            nanmean(results.RT(results.valid)), nanstd(results.RT(results.valid)));  % stampa media e deviazione standard
    catch ME  % intercetta eventuali errori runtime
        sca;  % chiude comunque la finestra anche in errore
        rethrow(ME);  % rilancia l errore per il debugging
    end  % chiude il blocco try/catch
end  % chiude la funzione
