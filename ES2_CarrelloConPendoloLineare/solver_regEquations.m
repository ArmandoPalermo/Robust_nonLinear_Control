function [Pi_sol, Gamma_sol] = solver_regEquations(A,B,C,Q,S,P)

% Dimensioni
n = size(A,1);
m = size(B,2);
r = size(S,1);

% Variabili simboliche
Pi    = sym('Pi',    [n r], 'real');
Gamma = sym('Gamma', [m r], 'real');

% Equazioni di regolazione CANONICHE
eq1 = A*Pi + B*Gamma + P - Pi*S;  
eq2 = C*Pi -Q; %Nel mio caso perche Q non viene dal modello


% Sistema simbolico
eqs  = [eq1(:); eq2(:)];
vars = [Pi(:); Gamma(:)];

sol = solve(eqs == 0, vars, 'real', true);

% Estrazione valori numerici
vals = zeros(length(vars),1);
for k = 1:length(vars)
    vals(k) = double(sol.(char(vars(k))));
end

Pi_sol    = reshape(vals(1:n*r), n, r);
Gamma_sol = reshape(vals(n*r+1:end), m, r);

end
