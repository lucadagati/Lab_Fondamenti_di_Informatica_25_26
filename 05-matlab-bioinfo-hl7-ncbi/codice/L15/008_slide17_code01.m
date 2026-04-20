% Creare figura
fig = figure;  % assegna il risultato a fig
plot(x, y, 'LineWidth', 2);  % disegna il grafico principale
title('Grafico per Paper');  % imposta il titolo del grafico

% Metodo 1: saveas
saveas(fig, 'figura.png')  % esegue il passo corrente della pipeline
saveas(fig, 'figura.fig')  % Editabile

% Metodo 2: exportgraphics (R2020a+, raccomandato)
exportgraphics(fig, 'figura_hd.png', 'Resolution', 300)  % esegue il passo corrente della pipeline
exportgraphics(fig, 'figura.pdf', 'ContentType', 'vector')  % esegue il passo corrente della pipeline
