%% Problem Set 2 - Exercise 1 (j): what moves with automation?

clear; clc; close all;

% we set preferences on private goods vs public good
phi = 0.8;

% we define the search grid of tax rates (from 0.1% to 90%) 
tau = 0.001:0.001:0.900;

%% Household (Part A): the grid search of part (d)
% Loop through all tax rates to find steady-state utility before and after automation
for i = 1:length(tau)
    % Pre-automation (theta = 0.33) - capital tax only
    [~, ~, ~, U_k_033(i)] = ex1_steady_state_ps(0.33, tau(i), 0);
    % Pre-automation (theta = 0.33) - labor tax only
    [~, ~, ~, U_n_033(i)] = ex1_steady_state_ps(0.33, 0, tau(i));
    
    % Post-automation (theta = 0.40) - capital tax only 
    [~, ~, ~, U_k_040(i)] = ex1_steady_state_ps(0.40, tau(i), 0);
    % Post-automation (theta = 0.40) - labor tax only 
    [~, ~, ~, U_n_040(i)] = ex1_steady_state_ps(0.40, 0, tau(i));
end

% Find grid index of optimal capital tax for theta = 0.33 and theta = 0.40
[~, i1] = max(U_k_033);   [~, i2] = max(U_k_040);

% Find grid index of optimal labor tax for theta = 0.33 and theta = 0.40
[~, i3] = max(U_n_033);   [~, i4] = max(U_n_040);

% we put together the representative household optimal rates (1 x 2) -->
% (before_automation , after_automation)
household_k = [tau(i1) tau(i2)];      % first element: theta 0.33 (before aut.), second: theta 0.40 (after) 
household_n = [tau(i3) tau(i4)];

%% Worker (Part B): formulas of parts (g) and (h)
% Compare the two capital share scenarios
theta = [0.33 0.40];

% we took the formula for the worker's preferred capital tax from Lecture 5c
% B / (Aw + B) = (1 - phi)*(1 - theta) / [ (1 - phi)*(1 - theta) + theta ]
worker_k = (1 - phi)*(1 - theta) ./ (1 - phi + phi*theta);

% formula for the worker's preferred labor tax
% tau_n = 1 - phi, which depends only on preference weights and never on theta
worker_n = [1 - phi, 1 - phi];

% Print results table comparing preferred tax rates across agents and automation levels
fprintf('                                    theta = 0.33   theta = 0.40\n');
fprintf('household: optimal capital tax      %8.3f       %8.3f\n', household_k);
fprintf('household: optimal labor tax        %8.3f       %8.3f\n', household_n);
fprintf('worker: preferred capital tax       %8.3f       %8.3f\n', worker_k);
fprintf('worker: preferred labor tax         %8.3f       %8.3f\n', worker_n);

%% Figure
figure
% Create grouped bar chart comparing preferred rates across both thetas
bar(100*[household_k; household_n; worker_k; worker_n]);

% Label each group along the horizontal axis
set(gca, 'XTickLabel', {'Household: capital', 'Household: labor', 'Worker: capital', 'Worker: labor'});

ylabel('Tax rate (%)'); 
legend('\theta = 0.33', '\theta = 0.40');
title('Preferred taxes before and after automation');
