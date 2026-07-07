function xdot = linear_system( x, A, B, K)
    u = -K*x;
    xdot = A*x + B*u;
end
