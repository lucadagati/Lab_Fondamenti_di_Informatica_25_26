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
