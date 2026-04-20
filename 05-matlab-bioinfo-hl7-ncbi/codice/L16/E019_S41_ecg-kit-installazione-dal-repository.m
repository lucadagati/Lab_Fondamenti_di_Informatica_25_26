% --- Fuori da MATLAB (terminale / shell) ---
% Clone ricorsivo: include submodule (WFDB, altre dipendenze del kit)
% git clone --recursive https://github.com/marianux/ecg-kit.git

% --- In MATLAB ---
cd('C:\percorso\ecg-kit')   % oppure /Users/.../ecg-kit su macOS/Linux
InstallECGkit()           % aggiunge path, compila MEX se necessario, controlla prerequisiti

examples()                % script di smoke-test su registrazioni di esempio incluse
