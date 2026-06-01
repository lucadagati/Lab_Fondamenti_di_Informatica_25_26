txt = "abc123def";  % definisce una stringa mista lettere+cifre
extract(txt, lettersPattern)   % ["abc", "def"]
extract(txt, digitsPattern)    % ["123"]
