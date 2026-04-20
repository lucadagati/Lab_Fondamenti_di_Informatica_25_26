s = "paziente_001";      % string array
v = [1.1 2.2 3.3];       % double
T = table(v', ...  % crea una tabella in memoria
  categorical(["A";"B";"C"]), ...  % esegue il passo corrente della pipeline
  'VariableNames', {'Valore','Gruppo'});  % esegue il passo corrente della pipeline
whos  % esegue il passo corrente della pipeline
