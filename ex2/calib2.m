function F = calib2(x,wA,pA,sA,wB,pB,sB)

modelA = share_model(wA,pA,x(1),x(3),x(4));
modelB = share_model(wB,pB,x(2),x(3),x(4));
F = [modelA(:)-sA(:); modelB(:)-sB(:)];

end