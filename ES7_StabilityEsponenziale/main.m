A = [0 1; -4 -2];
Beta = 10;

%Estraggo la P dall'equazione di Lyapunov
P = lyap(A', eye(2));
normP = norm(P);
C = 2*normP*Beta;

%Definisco il raggio della sfera che garantisce la exp stab.(Attenzione che e molto ocnservativa)
mu = sqrt(1/C);

f = @(t,x) A*x + [0; Beta*x(2)^3];

% Simulazione per una condizione iniziale fiSssata
tspan = [0 10]; x0 = [0.25; 0.25];
[t,x] = ode45(f, tspan, x0);

figure;
plot(t, x, 'LineWidth', 2);
xlabel('Tempo [s]'); ylabel('x(t)');
grid on;
title('Simulazione del sistema');

figure;hold on;grid on;
title('Regione stimata di stabilita');
xlabel('x_1'); ylabel('x_2');

th = linspace(0, 2*pi, 200);
plot(mu*cos(th), mu*sin(th), 'r', 'LineWidth', 2);

% Selezione interattiva delle condizioni iniziali
while true
    [x10, x20, button] = ginput(1);
    if isempty(button)
        break
    end

    x0 = [x10; x20];
    plot(x10, x20, 'go', 'MarkerSize', 8, 'LineWidth', 2);

    [t,x] = ode45(f, tspan, x0);
    plot(x(:,1), x(:,2), 'g', 'LineWidth', 1.5);
end