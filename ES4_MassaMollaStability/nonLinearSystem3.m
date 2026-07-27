% Parametri del sistema (CASO 3)
M  = 20;
k1 = 10;
k2 = 1;
B1 = 10;
B2 = 10; 

% Dinamica NON lineare (caso 3: +k2*x^3 - B1*x2 + B2*x2^3)
f = @(t,x) [
    x(2);
    (-k1*x(1) + k2*x(1)^3 - B1*x(2) + B2*x(2)^3)/M
];

% Lyapunov energetica
V = @(x1,x2) 0.5*M*x2.^2 + 0.5*k1*x1.^2 - 0.25*k2*x1.^4;

% definizione della dinamica
f1 = @(x1,x2) x2;
f2 = @(x1,x2) (-k1*x1 + k2*x1.^3 - B1*x2 + B2*x2.^3)/M;

% Derivata della Lyapunov
Vdot = @(x1,x2) ...
    (k1*x1).*f1(x1,x2) - (k2*x1.^3).*f1(x1,x2) + M*x2.*f2(x1,x2);


x1max = 5; 
x1min = -5;
x2max = 5;
x2min = -5;


[x1g,x2g] = meshgrid(linspace(x1min,x1max,100), ...
                     linspace(x2min,x2max,100));
Vgrid = V(x1g,x2g);
Vdotgrid = Vdot(x1g,x2g);

figure; hold on; grid on;
contour(x1g,x2g,Vgrid,30,'LineWidth',1.2);
xlabel('x_1'); ylabel('x_2');
title('Simulazione sistema non lineare 3');

% Regione di attrazione stimata
c = 25.01;
contour(x1g,x2g,Vgrid,[c c],'y','LineWidth',2);

% Ginput scelta del punto iniziale
[x10, x20] = ginput(1);
x0 = [x10; x20];
plot(x10,x20,'go','MarkerSize',8,'LineWidth',2);

% Integrazione del sistema
tspan = [0 20];
[t,x] = ode45(f, tspan, x0);
plot(x(:,1), x(:,2), 'g', 'LineWidth', 1.5);

while true
    [x10, x20, button] = ginput(1);
    if isempty(button)
        break
    end
    x0 = [x10; x20];
    plot(x10,x20,'go','MarkerSize',8,'LineWidth',2);
    [t,x] = ode45(f, tspan, x0);
    plot(x(:,1), x(:,2), 'g', 'LineWidth', 1.5);
end
