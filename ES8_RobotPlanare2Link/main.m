Kp = [20; 20];
Kd = [15; 15];

Gamma = eye(8) * 20;


Kp_mat = diag(Kp);   
Kd_mat = diag(Kd); 

Delta = Kd_mat \ Kp_mat; 



syms q1 q2 dq1 dq2 ddq1 ddq2 th1 th2 th3 th4 th5 th6 F1 F2  real

 % Matrice di inerzia
    B = [ th1 + 2*th3*cos(q2),   th2 + th3*cos(q2);
          th2 + th3*cos(q2),     th4 ];

    % Matrice di Coriolis
    C = [ -2*th3*sin(q2)*dq2,          -th3*sin(q2)* dq2;
           th3*sin(q2)*dq1,             0 ];

    % Gravità
    g = [ th5*cos(q1) + th6*cos(q1 + q2);
          th6*cos(q1 + q2) ];

    % Attrito viscoso
    F = [ F1*dq1;
          F2*dq2 ];

    q = [q1; q2];
    dq = [dq1; dq2];
    ddq = [ddq1; ddq2];
  