% Metodo 3: print (robusto)
if ~exist('fig', 'var') || ~isgraphics(fig, 'figure')  % verifica che fig esista e sia un handle Figure valido
    fig = figure('Name', 'Figura export', 'NumberTitle', 'off');  % crea una nuova figura se fig non è valido
    x = linspace(0, 2*pi, 500);  % definisce asse x di esempio per il grafico
    y = sin(x);  % definisce segnale di esempio da plottare
    plot(x, y, 'LineWidth', 1.4);  % disegna il grafico nella figura appena creata
    grid on;  % attiva la griglia per migliore leggibilità
    title('Figura di esempio per export');  % imposta titolo esplicativo
end  % chiude il controllo sull'handle figura

print(fig, '-dpng', '-r300', 'output.png')  % esporta in PNG a 300 DPI usando un handle valido
print(fig, '-dsvg', 'output.svg')  % esporta in SVG vettoriale usando lo stesso handle valido

% copygraphics — figura per incollare in documenti (es. Word / PowerPoint)
copygraphics(fig, 'Resolution', 300)  % copia la figura negli appunti con risoluzione definita
