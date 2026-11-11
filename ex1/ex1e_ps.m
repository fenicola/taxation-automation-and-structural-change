%% Problem Set 2 - Exercise 1 (e): which tax?

clear; clc; close all;

% Assign structural calibration parameters
theta = 0.33;                 % capital share; part (j): set theta = 0.40 and run again
phi = 0.8;                    % weight placed on private goods vs public good
tau = 0.001:0.001:0.900;      % Search grid for tax rates (0.1% to 90%)

%% Step 1: compare the two optima of part (d)
% Loop across the tax grid to evaluate tax policies
for i = 1:length(tau)
    % steady state when taxing only capital (labor tax at zero)
    [~, ~, ~, U_k(i)] = ex1_steady_state_ps(theta, tau(i), 0);
    % steady state when taxing only labor (capital tax at zero)
    [~, ~, ~, U_n(i)] = ex1_steady_state_ps(theta, 0, tau(i));
end


% we measure the percentage consumption increase needed under capital tax to reach labor-tax welfare
g = exp((max(U_n) - max(U_k))/phi) - 1;

fprintf('theta = %.2f\n', theta);
fprintf('Step 1: g = %.4f  (g > 0: the labor tax is better)\n', g);

%% Step 2: both taxes together
% Grid of fixed capital tax rates to test with labor taxation
tau_k_list = 0:0.05:0.40;

fprintf('\nStep 2:  tau_k   best tau_n      U        N        C        G\n');

% For each capital tax rate we find the welfare maximizing labor tax rate
for j = 1:length(tau_k_list)
    % we search across all labor taxes for the current fixed capital tax
    for i = 1:length(tau)
        [~, ~, ~, U(i)] = ex1_steady_state_ps(theta, tau_k_list(j), tau(i));
    end
    % Identify highest welfare and optimal labor tax rate for row j
    [U_best(j), i_best] = max(U);
    tau_n_best(j) = tau(i_best);
    % Retrieve steady-state quantities at this conditional optimum
    [N, C, G] = ex1_steady_state_ps(theta, tau_k_list(j), tau_n_best(j));
   
    fprintf('        %5.2f   %7.3f   %9.4f  %7.4f  %7.4f  %7.4f\n', ...
        tau_k_list(j), tau_n_best(j), U_best(j), N, C, G);
end

% we locate the global optimum across all tested pairs of (tau_k, tau_n)
[U_all, j_all] = max(U_best);
fprintf('\nBest pair: tau_k = %.2f, tau_n = %.3f\n', tau_k_list(j_all), tau_n_best(j_all));

% we calculate welfare loss (in consumption-equivalent terms) of fixing tau_k = 25% (row 6)
loss_25 = exp((U_all - U_best(6))/phi) - 1;       % row 6 is tau_k = 0.25
fprintf('Loss from taxing capital at 25%%: %.4f\n', loss_25);

%% Figure: best labor tax and highest welfare for each capital tax

figure

% Subplot 1: Optimal labor tax plotted against the background capital tax
subplot(1,2,1); 
plot(100*tau_k_list, 100*tau_n_best, '-o'); 
xlabel('Capital tax (%)'); 
ylabel('Labor tax (%)');
title('Best labor tax (%)');

% Subplot 2: Highest achievable welfare plotted against the background capital tax
subplot(1,2,2); 
plot(100*tau_k_list, U_best, '-o'); 
xlabel('Capital tax (%)'); 
ylabel('Utility level');
title('Highest welfare U');

% Overall title showing the baseline capital income share
sgtitle(sprintf('\\theta = %.2f', theta));
