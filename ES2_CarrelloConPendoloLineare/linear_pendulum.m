%% MODELLO LINEARE
syms M m l g real

% Momento d'inerzia del pendolo
Jp = m*l^2;

% Matrici simboliche
A = [ 0      1        0                   0;
      0      0   -(m*g)/M                0;
      0      0        0                   1;
      0      0   ((M+m)*g)*M*l/(M*(Jp))            0 ];

B = [ 0              0;
      1/M        -m*l/(M*Jp);
      0              0;
     (M*l)/(M*Jp)  (M + m)/(M*Jp) ];

C = [1 0 0 0;
     0 0 1 0];

% Valori numerici
M_val = 5;
m_val = 0.5;
l_val = 1;
g_val = 9.81;

Anum = double(subs(A, [M m l g], [M_val m_val l_val g_val]));
Bnum = double(subs(B, [M m l g], [M_val m_val l_val g_val]));
Cnum = C;


% Verifica della risolubilita del problema(H1,H2,H3*)
S = [0 4 0;
    -4 0 0;
    0 0 0];
% A 0 0 
% 0 0 B
Q =[1 0 0;
    0 0 1];

P=zeros(4,3);


disp("autovalori matrice S");
disp(eigs(S));

Contr = ctrb(Anum,Bnum);
Ae  = [[Anum P;
        zeros(3,4) S]];
Be = [Bnum; zeros(3,2)];
Ce = [Cnum -Q];
DetectM = obsv(Ae, Ce); 

%Condizioni H1 H2 e H3* valide quindi posso prendere gamma e pi che soddisfano le eq di reg.
[Pi_sol,Gamma_sol] = solver_regEquations(Anum,Bnum,C,Q,S,P);

poles_K = [-4  -5  -7  -6];
K = place(Anum, Bnum, poles_K);

poles_obs_e = [-5  -6  -7  -8  -9  -10  -4];
Le = place(Ae', Ce', poles_obs_e)';


