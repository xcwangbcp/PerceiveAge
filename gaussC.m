function val = gaussC(X, Y, sigma, center)
xc = center(1);
yc = center(2);
exponent = ((X-xc).^2 + (Y-yc).^2)./(2*sigma*sigma);
val = (exp(-exponent))*0.5;
end