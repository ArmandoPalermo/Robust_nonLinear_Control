A = [0 1;
    -4 -2];

eigs = eig(A);
disp(eigs);

tspan = [0 10];
x0 = [0.25 0.25];

Beta = 10;

[t,x] = ode45(@(t,x) (A * x + [0 ; Beta * x(2)^3]) , tspan, x0);

figure;
plot(t, x, 'LineWidth', 2);
xlabel('Tempo [s]');
ylabel('x(t)');
grid on;
title('Simulazione sistema');



% Formula teorica per mu
mu = Beta^(-1/2);


f = @(t,x) A*x + [0 ; Beta * x(2)^3];

figure; hold on; grid on;
title('Clicca un punto per scegliere x(0)');
xlabel('x_1'); ylabel('x_2');

% Disegno regione locale (cerchio di raggio mu)
th = linspace(0, 2*pi, 200);
plot(mu*cos(th), mu*sin(th), 'r', 'LineWidth', 2);



% Ciclo ginput
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


