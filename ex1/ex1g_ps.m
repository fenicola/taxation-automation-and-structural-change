%% Problem Set 2 - Exercise 1 (g): preferred capital taxes, worker and capitalist
clear; clc;

theta = 0.33;                 % part (j): set theta = 0.40 and run again
beta = 0.96;  phi = 0.8;

tau_worker = (1 - phi)*(1 - theta) / (1 - phi + phi*theta);   % same as Lecture 5c, any gamma
tau_capitalist_0  = (1 - phi)*(1 - theta) / (1 + phi*0);      % gamma = 0
tau_capitalist_05 = (1 - phi)*(1 - theta) / (1 + phi*0.5);    % gamma = 0.5

% Does the worker want to save? Only if beta*R > 1, with R = 1 + (1/beta - 1)/(1 + gamma)
beta_R_0  = beta*(1 + (1/beta - 1)/(1 + 0));
beta_R_05 = beta*(1 + (1/beta - 1)/(1 + 0.5));

fprintf('theta = %.2f\n', theta);
fprintf('             worker   capitalist   beta*R\n');
fprintf('gamma = 0    %.4f   %.4f       %.4f\n', tau_worker, tau_capitalist_0, beta_R_0);
fprintf('gamma = 0.5  %.4f   %.4f       %.4f\n', tau_worker, tau_capitalist_05, beta_R_05); 

