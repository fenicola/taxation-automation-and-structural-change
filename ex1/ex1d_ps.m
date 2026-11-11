%% Problem Set 2 - Exercise 1 (d): One tax at a time

clear; clc; close all;

% we set the capital income share in production
theta = 0.33;                 % part (j): set theta = 0.40 and run again

% we define the search grid of tax rates (from 0.1% to 90%) 
tau = 0.001:0.001:0.900;      

% Loop every tax rate on the grid to solve the steady state
for i = 1:length(tau)
    % in the first case we tax the capital only, keeping the labor tax fixed at zero
    [N_k(i), C_k(i), G_k(i), U_k(i)] = ex1_steady_state_ps(theta, tau(i), 0);
    
    % in the second case we tax labor only, keeping the capital tax fixed at zero
    [N_n(i), C_n(i), G_n(i), U_n(i)] = ex1_steady_state_ps(theta, 0, tau(i));
end

% we find the highest utility and the optimal rate
% taxing capital only
[U_k_max, ik] = max(U_k);     

%taxing labor only
[U_n_max, in] = max(U_n);     

% we find the tax rate that raises the most government revenue 
% from capital
[~, gk] = max(G_k);           

% from labor
[~, gn] = max(G_n);           


fprintf('theta = %.2f\n', theta);
fprintf('Optimal capital tax %.3f: N = %.4f, C = %.4f, G = %.4f, U = %.4f\n', ...
    tau(ik), N_k(ik), C_k(ik), G_k(ik), U_k_max);
fprintf('Optimal labor tax   %.3f: N = %.4f, C = %.4f, G = %.4f, U = %.4f\n', ...
    tau(in), N_n(in), C_n(in), G_n(in), U_n_max);
fprintf('Revenue-maximizing capital tax %.3f, labor tax %.3f\n', tau(gk), tau(gn));

%% Self-check 
% capital tax only, with hours fixed at their no-tax value
beta = 0.96;  delta = 0.08;  psi = 1.5;  phi = 0.8;

% we get the baseline hours worked in an economy with zero taxes
N0 = ex1_steady_state_ps(theta, 0, 0);            

% Evaluate the capital tax while preventing hours from adjusting 
for i = 1:length(tau)
    % Gross required return on capital to satisfy the household Euler equation
    r = (1/beta - 1 + delta) / (1 - tau(i));
    
    % Capital-labor ratio chosen by firms given rental rate r
    k = (theta / r)^(1/(1 - theta));
    
    % Equilibrium real wage paid by competitive firms
    w = (1 - theta) * k^theta;
    
    % Total private consumption when hours are locked at N0
    C = (w + (1/beta - 1)*k) * N0;
    
    % Total public good financed entirely by capital tax revenue
    G = tau(i)*r*k*N0;
    
    % Household period utility under fixed hours
    U_fixed(i) = phi*(log(C) + psi*log(1 - N0)) + (1 - phi)*log(G);
end

% Find the tax rate that maximizes utility when hours cannot respond
[~, ifix] = max(U_fixed);

fprintf('Self-check, hours fixed at N0 = %.4f: optimal capital tax %.3f (Lecture 5c)\n', ...
    N0, tau(ifix));

%% Figure: welfare, hours and G against the tax rate

figure

% Panel 1: Plot household welfare curves against the tax rate
subplot(1,3,1); 
plot(100*tau, U_k, 100*tau, U_n); 
xlabel('Tax rate (%)'); 
ylabel('Utility');
title('Welfare U');
legend('Capital tax', 'Labor tax', 'Location', 'south');

% Panel 2: Plot labor supply response across tax rates
subplot(1,3,2); 
plot(100*tau, N_k, 100*tau, N_n); 
xlabel('Tax rate (%)'); 
ylabel('Hours (N)');
title('Hours N');

% Panel 3: Plot the public good / revenue (the Laffer curve)
subplot(1,3,3); 
plot(100*tau, G_k, 100*tau, G_n); 
xlabel('Tax rate (%)'); 
ylabel('Public good (G)');
title('Public good G');

% Add a common overall title indicating the production parameter theta
sgtitle(sprintf('\\theta = %.2f', theta));