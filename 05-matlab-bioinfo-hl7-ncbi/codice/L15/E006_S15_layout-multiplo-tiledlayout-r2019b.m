% Metodo moderno (R2019b+)
figure  % esegue il passo corrente della pipeline
tiledlayout(2, 2, 'TileSpacing', 'compact')  % esegue il passo corrente della pipeline
nexttile; plot(x, sin(x)); title('Seno')  % disegna il grafico principale
nexttile; plot(x, cos(x)); title('Coseno')  % disegna il grafico principale
nexttile([1 2]); plot(x, sin(x).*cos(x)); title('Prodotto')  % disegna il grafico principale
sgtitle('Funzioni Trigonometriche')  % imposta il titolo del grafico
