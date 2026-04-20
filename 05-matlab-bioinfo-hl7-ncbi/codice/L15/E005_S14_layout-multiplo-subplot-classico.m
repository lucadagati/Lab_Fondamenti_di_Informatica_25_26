% Metodo classico
figure  % esegue il passo corrente della pipeline
subplot(2,2,1); plot(x, sin(x)); title('Seno')  % disegna il grafico principale
subplot(2,2,2); plot(x, cos(x)); title('Coseno')  % disegna il grafico principale
subplot(2,2,3); histogram(randn(1000,1)); title('Distribuzione')  % disegna il grafico principale
subplot(2,2,4); bar([1 2 3], [10 20 15]); title('Categorie')  % disegna il grafico principale
