Z = peaks(100);
levels = -7:1:10;
contour(Z,levels)
Znoise = Z + rand(100) - 0.5;
contour(Znoise,levels)
K = 0.125*ones(3);
Zsmooth1 = conv2(Znoise,K,'same');
contour(Zsmooth1, levels)
K = 0.045*ones(5);
Zsmooth2 = conv2(Znoise,K,'same');
contour(Zsmooth2,levels)