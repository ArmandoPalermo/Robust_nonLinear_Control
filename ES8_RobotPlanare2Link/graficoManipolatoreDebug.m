% Parametri del robot
l1 = 1;   % lunghezza primo link
l2 = 1;   % lunghezza secondo link

% Inserisci qui le tue q
q1 = 0;      % rad
q2 = 0;      % rad

% Cinematica diretta
O  = [0 0];
P1 = [l1*cos(q1),               l1*sin(q1)];
P2 = [l1*cos(q1)+l2*cos(q1+q2), l1*sin(q1)+l2*sin(q1+q2)];

% Plot del robot
figure; hold on; grid on; axis equal;

% Disegno dei link
plot([O(1) P1(1)], [O(2) P1(2)], 'LineWidth', 3);
plot([P1(1) P2(1)], [P1(2) P2(2)], 'LineWidth', 3);

% Giunti
scatter(O(1),  O(2),  80, 'filled');
scatter(P1(1), P1(2), 80, 'filled');
scatter(P2(1), P2(2), 80, 'filled');

title('Robot RR');
xlabel('x'); ylabel('y');

% Limiti del grafico
xlim([-l1-l2, l1+l2]);
ylim([-l1-l2, l1+l2]);
