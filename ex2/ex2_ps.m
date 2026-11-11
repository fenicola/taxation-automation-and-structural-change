%% Problem Set 2 - Exercise 2: Richer, or pricier?

clear; clc; close all;

T = readtable('PS2_Ex2_data.csv');

%% (a) Data: services share s, relative price p, income w
% India
A = T(strcmp(T.iso3, 'IND'), :);
year = A.year;                                    % 1980-2019, the same for every country
s_IND = A.srv_cd ./ (A.agr_cd + A.ind_cd + A.srv_cd);
p_IND = (A.srv_cd ./ A.srv_kd) ./ ((A.agr_cd + A.ind_cd) ./ (A.agr_kd + A.ind_kd));
w_IND = A.gdppc_ppp / 1000;                       % thousand 2021 PPP dollars, from 1990 on
w_IND(1:10) = w_IND(11) * A.gdppc_kd(1:10) / A.gdppc_kd(11);    % 1980-1989 (row 11 = 1990)

% Sri Lanka
B = T(strcmp(T.iso3, 'LKA'), :);
s_LKA = B.srv_cd ./ (B.agr_cd + B.ind_cd + B.srv_cd);
p_LKA = (B.srv_cd ./ B.srv_kd) ./ ((B.agr_cd + B.ind_cd) ./ (B.agr_kd + B.ind_kd));
w_LKA = B.gdppc_ppp / 1000;
w_LKA(1:10) = w_LKA(11) * B.gdppc_kd(1:10) / B.gdppc_kd(11);

% Windows: India rows 1-40 (1980-2019), Sri Lanka rows 4-22 (1983-2001)
fI = 1;  lI = 40;
fS = 4;  lS = 22;

fprintf('(a) Endpoints:   s (%%)    raw p   normalized p    w\n');
fprintf('India     %d   %.4f   %.4f   %.4f   %.4f\n', year(fI), 100*s_IND(fI), p_IND(fI), 1, w_IND(fI));
fprintf('India     %d   %.4f   %.4f   %.4f   %.4f\n', year(lI), 100*s_IND(lI), p_IND(lI), p_IND(lI)/p_IND(fI), w_IND(lI));
fprintf('Sri Lanka %d   %.4f   %.4f   %.4f   %.4f\n', year(fS), 100*s_LKA(fS), p_LKA(fS), 1, w_LKA(fS));
fprintf('Sri Lanka %d   %.4f   %.4f   %.4f   %.4f\n', year(lS), 100*s_LKA(lS), p_LKA(lS), p_LKA(lS)/p_LKA(fS), w_LKA(lS));

figure
subplot(3,1,1); plot(year, s_IND, year, s_LKA); title('Services share s');
xline([1983 2001], '--');  legend('India (window 1980-2019)', 'Sri Lanka (window 1983-2001)', 'Location', 'southeast');
subplot(3,1,2); plot(year, p_IND, year, p_LKA); title('Relative price of services p');
xline([1983 2001], '--');
subplot(3,1,3); plot(year, w_IND, year, w_LKA); title('Income w (thousand 2021 PPP $)');
xline([1983 2001], '--');

% Pakistan, 1998-2001 (rows 2 and 3 are 1999 and 2000)
P = T(strcmp(T.iso3, 'PAK') & T.year >= 1998 & T.year <= 2001, :);
s_PAK = P.srv_cd ./ (P.agr_cd + P.ind_cd + P.srv_cd);
p_PAK = (P.srv_cd ./ P.srv_kd) ./ ((P.agr_cd + P.ind_cd) ./ (P.agr_kd + P.ind_kd));
real_PAK = P.srv_kd ./ (P.agr_kd + P.ind_kd + P.srv_kd);
fprintf('\nPakistan               1999      2000      change\n');
fprintf('relative price p     %.4f    %.4f    %.4f (100 x change in ln p), %.3f%%\n', ...
    p_PAK(2), p_PAK(3), 100*(log(p_PAK(3)) - log(p_PAK(2))), 100*(p_PAK(3)/p_PAK(2) - 1));
fprintf('services share (%%)  %.4f   %.4f    %.4f pp\n', 100*s_PAK(2), 100*s_PAK(3), 100*(s_PAK(3) - s_PAK(2)));
fprintf('real share (%%)      %.4f   %.4f    %.4f pp\n', 100*real_PAK(2), 100*real_PAK(3), 100*(real_PAK(3) - real_PAK(2)));

figure
subplot(1,3,1); plot(P.year, p_PAK, 'o-'); xline(2000, '--'); title('(a) Relative price p');
subplot(1,3,2); plot(P.year, 100*s_PAK, 'o-'); xline(2000, '--'); title('(b) Services share (%)');
subplot(1,3,3); plot(P.year, 100*real_PAK, 'o-'); xline(2000, '--'); title('(c) Real services share (%)');

%% (d) Calibration: four equations, four unknowns [bA, bB, rho, mbar]
% A = India, B = Sri Lanka. First and last year of each window; p = 1 in the first year.
wA = [w_IND(fI); w_IND(lI)];   pA = [1; p_IND(lI)/p_IND(fI)];   sA = [s_IND(fI); s_IND(lI)];
wB = [w_LKA(fS); w_LKA(lS)];   pB = [1; p_LKA(lS)/p_LKA(fS)];   sB = [s_LKA(fS); s_LKA(lS)];
x0 = [0.5 0.5 0 0.25*min(wA(1), wB(1))];

% Self-check: targets made by the model itself at x = [0.3 0.4 -1.5 0.8]
sA_test = share_model(wA, pA, 0.3, -1.5, 0.8);
sB_test = share_model(wB, pB, 0.4, -1.5, 0.8);
x_test = fsolve(@(x) calib2(x, wA, pA, sA_test, wB, pB, sB_test), x0);
fprintf('\n(d) Self-check: fsolve gives back %.4f %.4f %.4f %.4f\n', x_test);
fprintf('largest difference from [0.3 0.4 -1.5 0.8]: %.1e\n', max(abs(x_test - [0.3 0.4 -1.5 0.8])));

% The data
[x, F, exitflag] = fsolve(@(x) calib2(x, wA, pA, sA, wB, pB, sB), x0);
bA = x(1);  bB = x(2);  rho = x(3);  mbar = x(4);
epsilon = 1/(1 - rho);
fprintf('bA = %.4f, bB = %.4f, rho = %.4f, epsilon = %.4f, mbar = %.4f\n', bA, bB, rho, epsilon, mbar);
fprintf('exitflag = %d, largest residual = %.1e\n', exitflag, max(abs(F)));
fprintf('mbar/w: India %.4f -> %.4f, Sri Lanka %.4f -> %.4f\n', mbar/wA(1), mbar/wA(2), mbar/wB(1), mbar/wB(2));
fprintf('mbar = %.4f dollars per person per day (poverty line: 3.00)\n', 1000*mbar/365);

%% (e) The years in between
s_model_IND = share_model(w_IND(fI:lI), p_IND(fI:lI)/p_IND(fI), bA, rho, mbar);
s_model_LKA = share_model(w_LKA(fS:lS), p_LKA(fS:lS)/p_LKA(fS), bB, rho, mbar);
error_IND = 100*(s_model_IND - s_IND(fI:lI));     % percentage points
error_LKA = 100*(s_model_LKA - s_LKA(fS:lS));
rmse_IND = sqrt(mean(error_IND(2:end-1).^2));     % only years strictly inside the window
rmse_LKA = sqrt(mean(error_LKA(2:end-1).^2));
[max_IND, i_IND] = max(abs(error_IND));
[max_LKA, i_LKA] = max(abs(error_LKA));
fprintf('\n(e) RMSE: India %.4f pp, Sri Lanka %.4f pp\n', rmse_IND, rmse_LKA);
fprintf('Largest miss: India %.4f pp in %d, Sri Lanka %.4f pp in %d\n', ...
    max_IND, year(fI + i_IND - 1), max_LKA, year(fS + i_LKA - 1));
fprintf('Years with the model above the data: India %d of %d, Sri Lanka %d of %d\n', ...
    sum(error_IND(2:end-1) > 0), lI - fI - 1, sum(error_LKA(2:end-1) > 0), lS - fS - 1);

figure
subplot(2,1,1); plot(year(fI:lI), s_IND(fI:lI), 'o-', year(fI:lI), s_model_IND, '--');
title('India'); legend('Data', 'Model', 'Location', 'northwest');
subplot(2,1,2); plot(year(fS:lS), s_LKA(fS:lS), 'o-', year(fS:lS), s_model_LKA, '--');
title('Sri Lanka'); legend('Data', 'Model', 'Location', 'northwest');

%% (f) Richer, or pricier?
H_A1 = 1/(1 + (bA/(1 - bA))^epsilon * pA(1)^(epsilon - 1));
H_AT = 1/(1 + (bA/(1 - bA))^epsilon * pA(2)^(epsilon - 1));
H_B1 = 1/(1 + (bB/(1 - bB))^epsilon * pB(1)^(epsilon - 1));
H_BT = 1/(1 + (bB/(1 - bB))^epsilon * pB(2)^(epsilon - 1));

change_A = 100*log(sA(2)/sA(1));
price_A  = 100*log(H_AT/H_A1);
income_A = 100*log((1 - mbar/wA(2)) / (1 - mbar/wA(1)));
change_B = 100*log(sB(2)/sB(1));
price_B  = 100*log(H_BT/H_B1);
income_B = 100*log((1 - mbar/wB(2)) / (1 - mbar/wB(1)));

fprintf('\n(f)         change   price force   income force\n');
fprintf('India      %7.4f   %9.4f   %10.4f\n', change_A, price_A, income_A);
fprintf('Sri Lanka  %7.4f   %9.4f   %10.4f\n', change_B, price_B, income_B);

figure
bar([price_A income_A change_A; price_B income_B change_B]);
set(gca, 'XTickLabel', {'India', 'Sri Lanka'}); ylabel('Log change x 100');
legend('Price force', 'Income force', 'Total change');
title('Rise in services: price and income forces');