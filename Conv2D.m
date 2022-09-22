close all;
% load data here
%load('/Users/siwei/Library/Containers/com.tencent.xinWeChat/Data/Library/Application Support/com.tencent.xinWeChat/2.0b4.0.9/58c9d57a97c88e45e997595a66b0c91a/Message/MessageTemp/0dfcad3f43539185c1079399e8f82c80/File/wtw20180123a_eyetrace.mat');

% original data
heat = eyefixMatrix{20,1};

% generate gaussian kernel
[X,~] = meshgrid([0:1:200],[0:1:200]);
kernel = gauss2d(X, 100, [100,100]);

% convolve original data with gaussian kernel
heat_conv  = conv2(heat, kernel,'same');

% visualization
pcolor(heat_conv);shading interp;



% 2D_Gauss. You can use your own 2D_Gauss function.
function mat = gauss2d(mat, sigma, center)
gsize = size(mat);
for r=1:gsize(1)
    for c=1:gsize(2)
        mat(r,c) = gaussC(r,c, sigma, center);
    end
end
end

function val = gaussC(X, Y, sigma, center)
xc = center(1);
yc = center(2);
exponent = ((X-xc).^2 + (Y-yc).^2)./(2*sigma);
val = (exp(-exponent));
end