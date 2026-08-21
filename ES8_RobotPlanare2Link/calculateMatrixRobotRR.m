function [B, C, g, F] = calculateMatrixRobotRR(q, dq)

    % Parametri numerici
    th1 = 10.6125;
    th2 = 0.85;
    th3 = 2.25;
    th4 = 1.6;
    th5 = 80.9325;
    th6 = 14.7150;
    F1  = 0.85;
    F2  = 0.85;

    q1 = q(1);
    q2 = q(2);
    dq1 = dq(1);
    dq2 = dq(2);

    % Matrice di inerzia
    B = [ th1 + 2*th3*cos(q2),   th2 + th3*cos(q2);
          th2 + th3*cos(q2),     th4 ];

    % Matrice di Coriolis
    C = [ -2*th3*sin(q2)*dq2,          -th3*sin(q2)*(dq1 + dq2);
           th3*sin(q2)*dq1,             0 ];

    % Gravità
    g = [ th5*cos(q1) + th6*cos(q1 + q2);
          th6*cos(q1 + q2) ];

    % Attrito viscoso
    F = [ F1*dq1;
          F2*dq2 ];
end
