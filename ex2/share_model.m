function s = share_model(w,p,b,rho,mbar)
% SHARE_MODEL Services share of spending in the two-sector model.
% w and mbar: thousand 2021 PPP dollars per person per year.
% p: price of services relative to goods, = 1 in the first year of the window.
% Works on vectors w and p of the same size.

elasticity = 1./(1-rho);
H = 1./(1 + (b./(1-b)).^elasticity .* p.^(elasticity-1));
s = H .* (1-mbar./w);

end