function [N, C, G, U] = ex1_steady_state_ps(theta, tau_k, tau_n)

beta = 0.96;  delta = 0.08;  psi = 1.5;  phi = 0.8;

r  = (1/beta - 1 + delta) / (1 - tau_k);          % Euler: (1-tau_k)*r - delta = 1/beta - 1
k  = (theta / r)^(1/(1 - theta));                 % from r = theta*k^(theta-1)
w  = (1 - theta) * k^theta;                       % wage
xk = (1/beta - 1) * k;                            % capital income per hour worked
N  = (1 - tau_n) / ((1 - tau_n)*(1 + psi) + psi*xk/w);
C  = ((1 - tau_n)*w + xk) * N;
G  = (tau_k*r*k + tau_n*w) * N;                   % G = tau_k*r*K + tau_n*w*N, with K = k*N
U  = phi*(log(C) + psi*log(1 - N)) + (1 - phi)*log(G);

end