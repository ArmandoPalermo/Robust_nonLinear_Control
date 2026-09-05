%Sistema
A = [1 -2;
     0  1];

B = [0;
     1];

% Matrice di costo sullo stato e sul controllo
Q = [1 0;
     0 1];

R =1;
S = 0;

% Soluzione ARE analitica 
P = care(A,B,Q,R,S);


n = size(A,1);   % dimensione del sistema
P_dot = @(t,P_dre) - (reshape( A' * reshape(P_dre,n,n) ...
                          + reshape(P_dre,n,n) * A ...
                          + Q ...
                          - reshape(P_dre,n,n) * B * (1/R) * B' * reshape(P_dre,n,n), n*n, 1 ));

%condizioni iniziali, inizializzazione funzione e tempo di integrazione
tspan = [10 0];
P0 = S * eye(2);
[t, P_sol] = ode45(P_dot, tspan, P0);

%Array di P nel tempo
P_t = zeros(n,n,length(t));
for k = 1:length(t)
    P_t(:,:,k) = reshape(P_sol(k,:),n,n);
end




% Grafico dell errore della ARE e la DRE integrata nel tempo
figure;

plot(t, squeeze(P_t(1,1,:) - P(1,1))); hold on;
plot(t, squeeze(P_t(1,2,:) - P(1,2)));
plot(t, squeeze(P_t(2,1,:) - P(2,1)));
plot(t, squeeze(P_t(2,2,:) - P(2,2)));
set(gca,'XDir','reverse');
title('Errore tra P_{ARE} e P(t) ottenuta dalla DRE');
xlabel('Tempo t');
ylabel('Errore P(t) - P_{ARE}');
legend('e_{11}','e_{12}','e_{21}','e_{22}');
grid on;

%Metodo del gradiente adattivo sulla pendenza della DRE
% Calcolo del gradiente della DRE
max_iter = length(t);
alphak = 0.3;
P_list = zeros(n,n,length(t));
Pgrad = zeros(n,n); 

for i = 1:length(t)
    grad = -(A' * Pgrad + Pgrad * A + Q - Pgrad * B * (1/R) * B' * Pgrad);
    Pgrad = Pgrad - alphak * grad;
    P_list(:,:,i) = Pgrad;
end

% Grafico dell errore della ARE e la DRE integrata nel tempo
figure;
plot(1:length(t), squeeze(P_list(1,1,:) - P(1,1))); hold on;
plot(1:length(t), squeeze(P_list(1,2,:) - P(1,2)));
plot(1:length(t), squeeze(P_list(2,1,:) - P(2,1)));
plot(1:length(t), squeeze(P_list(2,2,:) - P(2,2)));

xlabel('Iterazione k');
ylabel('Errore rispetto a P_{ARE}');
title('Convergenza del metodo iterativo');
legend('e_{11}','e_{12}','e_{21}','e_{22}');
grid on;


disp(Pgrad);
disp(P);
disp(P_t(:,:,length(t)))