x = 0:0.1:2*pi;  % assegna il risultato a x
y = sin(x);  % assegna il risultato a y

figure('Position', [100 100 800 500])  % apre una nuova finestra grafica
plot(x, y, 'b-', 'LineWidth', 2)  % disegna il grafico principale

% Elementi essenziali
title('Funzione Seno', 'FontSize', 14, 'FontWeight', 'bold')  % imposta il titolo del grafico
xlabel('Angolo (radianti)', 'FontSize', 12)  % imposta etichetta asse x
ylabel('Ampiezza', 'FontSize', 12)  % imposta etichetta asse y
xlim([0 2*pi])  % imposta i limiti degli assi
ylim([-1.2 1.2])  % imposta i limiti degli assi
grid on  % attiva la griglia del grafico
legend('sin(x)', 'Location', 'northeast')  % esegue il passo corrente della pipeline

% Personalizzazione assi
ax = gca;  % assegna il risultato a ax
ax.FontSize = 11;  % assegna il risultato a ax.FontSize
ax.XTick = [0 pi/2 pi 3*pi/2 2*pi];  % assegna il risultato a ax.XTick
ax.XTickLabel = {'0', 'π/2', 'π', '3π/2', '2π'};  % assegna il risultato a ax.XTickLabel
