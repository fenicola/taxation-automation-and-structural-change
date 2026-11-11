%% Problem Set 2 - Exercise 1 (k): a capital tax in the background

clear; clc;

phi = 0.8;
tau_k = 0.25;

tau_n_033 = (1 - phi) - phi*tau_k*0.33/(1 - 0.33);   % worker's preferred labor tax, theta = 0.33
tau_n_040 = (1 - phi) - phi*tau_k*0.40/(1 - 0.40);   % theta = 0.40
theta_zero = (1 - phi) / ((1 - phi) + phi*tau_k);    % theta at which her labor tax reaches zero

fprintf('Worker''s labor tax with tau_k = 0.25: theta 0.33 -> %.4f, theta 0.40 -> %.4f\n', tau_n_033, tau_n_040);
fprintf('It reaches zero at theta = %.2f\n', theta_zero);
