s = tf('s');


G0 = [12.8 /(16.7*s + 1),   -18.9/(21*s + 1);
    6.6/(10.95*s + 1),      -19.4/(14.4*s + 1)];

omega0 = 0.02;
A = 10e-4;
M = 1.5;

%Inviluppo ritardi
theta = 7;
Delta_m = exp(-theta*s) - 1;
Wm = 2*theta*s/(theta*s + 1);

figure;
bodemag(Delta_m,Wm);
grid on;
legend('|\Delta_m(j\omega)|','|W_m(j\omega)|');
title('Errore relativo del ritardo e peso di incertezza');

%Rappresentazione nominale piu ritardo
theta11 = 1; theta12 = 3; theta21 = 7; theta22 = 3;
W11 = 2*theta11*s/(1 + theta11*s);
W12 = 2*theta12*s/(1 + theta12*s);
W21 = 2*theta21*s/(1 + theta21*s);
W22 = 2*theta22*s/(1 + theta22*s);

D1 = ultidyn('D1',[1 1]);

Gunc = [
    G0(1,1)*(1 + W11*D1),  G0(1,2)*(1 + W12*D1);
    G0(2,1)*(1 + W21*D1),  G0(2,2)*(1 + W22*D1)
];


%Norme da minimizzare
wp =  ((s/M) + omega0)/ (s + (omega0*A));
Wp = wp * eye(2);

thetamax = 7;
wt = 2*thetamax*s/(1 + thetamax*s);
Wt = wt * eye(2);

%forme di stato e sinteesi
G0s = ss(G0);
Wps = ss(Wp);
Wts = ss(Wt);

P = augw(G0s, Wp, [], Wt);

[K, CL, gamma] = hinfsyn(P, 2, 2);

disp('Gamma Ottenuto');
disp(gamma);
S = feedback(eye(2), G0*K);
T = feedback(G0*K, eye(2));

disp('Norma WT T');
disp(norm(Wt * T,inf));
disp('Norma WP S');
disp(norm(Wp * S,inf));


Gunc_cl = feedback(Gunc * K, eye(2));
realizzazioni_Gunc = usample(Gunc_cl,5);
G0_cl = feedback(G0 * K, eye(2));
realizzaizoni_nom = usample(G0_cl);

figure
step(realizzazioni_Gunc);
figure
step(realizzaizoni_nom);


%Analisi performance vs robusteza
omegas = linspace(0.1,0.2,200);
gammas = zeros(size(omegas));

for k = 1:length(omegas)

    omega0 = omegas(k);

    wp = ((s/M) + omega0) / (s + omega0*A);
    Wp = wp * eye(2);
    wt = 2*thetamax*s/(1 + thetamax*s);
    Wt = wt * eye(2);

    P = augw(G0s, ss(Wp), [],ss(Wt));

    [K,CL,gamma] = hinfsyn(P,2,2);
    gammas(k) = gamma;

end

i = find(gammas > 1, 1);   
omega_lim = omegas(i); 
figure;
plot(omegas, gammas, 'LineWidth', 2);
xline(omega_lim, '--r');
xlabel('\omega_0');
ylabel('\gamma');
grid on;


%Worstcase con configurazione attuale
[stabmarg,wcu] = robstab(Gunc_cl);
Gunc_wc = usubs(Gunc_cl,wcu);

figure;
step(Gunc_wc);
grid on;