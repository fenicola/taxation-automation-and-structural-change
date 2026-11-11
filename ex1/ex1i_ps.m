%% Problem Set 2 - Exercise 1 (h)-(i): which tax does the worker prefer?

clear; clc;

theta = 0.33;                 % part (j): set theta = 0.40 and run again
beta = 0.96;  delta = 0.08;  psi = 1.5;  phi = 0.8;

N = 1/(1 + psi);                                              % worker's hours, part (f)
tau_k_w = (1 - phi)*(1 - theta) / (1 - phi + phi*theta);      % her preferred capital tax, part (g)
tau_n_w = 1 - phi;                                            % her preferred labor tax, part (h)

%% Policy 1: capital tax tau_k_w, no labor tax
r = (1/beta - 1 + delta) / (1 - tau_k_w);         % capitalist's Euler equation
k = (theta / r)^(1/(1 - theta));
w = (1 - theta) * k^theta;
K = k*N;
cw_1 = w*N;                                       % the worker consumes her wage
ck_1 = (1/beta - 1)*K;                            % the capitalist consumes the net return
G_1  = tau_k_w*r*K;
Uw_1 = phi*(log(cw_1) + psi*log(1 - N)) + (1 - phi)*log(G_1);
Uk_1 = phi*log(ck_1) + (1 - phi)*log(G_1);

%% Policy 2: labor tax tau_n_w, no capital tax
r = 1/beta - 1 + delta;
k = (theta / r)^(1/(1 - theta));
w = (1 - theta) * k^theta;
K = k*N;
cw_2 = (1 - tau_n_w)*w*N;
ck_2 = (1/beta - 1)*K;
G_2  = tau_n_w*w*N;
Uw_2 = phi*(log(cw_2) + psi*log(1 - N)) + (1 - phi)*log(G_2);
Uk_2 = phi*log(ck_2) + (1 - phi)*log(G_2);

g_worker     = exp((Uw_2 - Uw_1)/phi) - 1;        % > 0: the worker prefers the labor tax
g_capitalist = exp((Uk_2 - Uk_1)/phi) - 1;

fprintf('theta = %.2f\n', theta);
fprintf('(h) worker''s labor tax %.2f, G/cw = %.4f\n', tau_n_w, G_2/cw_2);
fprintf('                         cw       ck       G        Uw        Uk\n');
fprintf('capital tax %.4f   %.4f   %.4f   %.4f   %.4f   %.4f\n', tau_k_w, cw_1, ck_1, G_1, Uw_1, Uk_1);
fprintf('labor tax   %.4f   %.4f   %.4f   %.4f   %.4f   %.4f\n', tau_n_w, cw_2, ck_2, G_2, Uw_2, Uk_2);
fprintf('(i) gain from the labor tax: worker %.4f, capitalist %.4f\n', g_worker, g_capitalist);
