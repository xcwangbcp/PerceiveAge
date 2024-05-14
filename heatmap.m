% [wholeMatrix,] = hotmap()
clear ; close all
cd H:\myD\PerceiveAge\02Data\closeEyes
clear
list=ls;
list=list(3:end,:);
[r,c]=size(list);
eyefixMatrixAll=cell(20,2);
for i=1:r
    eyefixMatrixAll{i,1}=zeros(1080,1920);  0
end

for subNum=1:r 
    filename=list(1,:);
    load(filename,'eyefixMatrix');
    eyefixMatrix = sortrows(eyefixMatrix,2);
    for i=1:r
        eyefixMatrixAll{i,1} = eyefixMatrixAll{i,1}+eyefixMatrix {i,1};
%         imagesc(eyefixMatrixAll{i,1})
    end  
end
eyefixMatrixAll(:,2) = eyefixMatrix(:,2);
cd H:\myD\PerceiveAge\pics
% generate gaussian kernel
%     xcenter=1920/2;ycenter=1080/2;
%     [X,~] = meshgrid([xcenter:1:xcenter+200],[ycenter:1:ycenter+200]);
    [X,~] = meshgrid([0:1:100],[0:1:100]);
    kernel = gauss2d(X, 15, [50,50]);
    K = 0.045*ones(5);
for subNum=1:r
    heat =  eyefixMatrixAll{subNum,1};
    % convolve original data with gaussian kernel
    heat_conv  = conv2(heat, K,'same');
    figure;
    pic=eyefixMatrix{subNum,2};
    path = 'H:\myD\PerceiveAge\pics\';
    myfile=strcat(path,pic);

    myfile=imread(myfile);
    imagesc(myfile);

    hold on
    h=imagesc(heat_conv);
    axis off;
    h.AlphaData=h.CData;
    h.AlphaData=(h.CData/max(max(h.CData)));
end


close all;
% load data here
%load('/Users/siwei/Library/Containers/com.tencent.xinWeChat/Data/Library/Application Support/com.tencent.xinWeChat/2.0b4.0.9/58c9d57a97c88e45e997595a66b0c91a/Message/MessageTemp/0dfcad3f43539185c1079399e8f82c80/File/wtw20180123a_eyetrace.mat');

% original data
heat = eyefixMatrix{1,1};

% generate gaussian kernel
[X,~] = meshgrid([0:1:200],[0:1:200]);
kernel = gauss2d(X, 20, [100,100]);

% convolve original data with gaussian kernel
heat_conv  = conv2(heat, kernel,'same');
figure;
% imwrite()




pic=eyefixMatrix{1,2};
path = 'H:\myD\PerceiveAge\pics\';
myfile=strcat(path,pic);

myfile=imread(myfile);
imagesc(myfile);

hold on
h=imagesc(heat_conv);
axis off;
h.AlphaData=h.CData;
h.AlphaData=(h.CData/max(max(h.CData)));

% hold on
% h=imagesc(heat_conv);
get(gca,'ALim')
set(gca,'ALim', [0 50])
%  h.AlphaDataMapping='scaled'
%  cd H:\myD\PerceiveAge\01RunningCode\pics
% imheat=imread('m8.2.png');
% gray = uint8(double(imheat) * 255);

cmap = colormap(jet(210));
% rgb = ind2rgb(imheat, cmap);

% map = uint8(imdata * 0.5 + heat_conv* 0.5);

imshow(map)
hold on
% plot(heat_conv);




% visualization
% pcolor(heat_conv);shading interp;
function [width,height] = WindowSize(window)
% [width,height] = WindowSize(window)
%
% Returns a window's width and height.
%
% 26/03/2001 fwc based on rectsize.m

if nargin~=1
	error('Usage:  [width,height] = WindowSize(window)');
end
rect=Screen('Rect', window);
width = rect(RectRight) - rect(RectLeft);
height = rect(RectBottom)-rect(RectTop);
end

function [x,y] = WindowCenter(window)
% USAGE: [x,y] = WindowCenter(window)
% Returns a window's center point.

% History
% 26/03/2001    fwc made based on rectcenter
% 05-02-04      fwc OS X PTB compatible
if nargin~=1
	error('Usage:  [x,y] = WindowCenter(window)');
end

rect=Screen('Rect',window);
[x,y] = RectCenter(rect);
end
function showpic
load('xsw20171505free.mat');
file_path = [pwd '\pics\'];% 图像文件夹路径
img_path_list = dir(strcat(file_path,'*.png'));
showSeq=results.showSeq;%report
myimgfile = [ file_path showSeq(1)];
myimgfile = cell2mat(myimgfile);
imdata=imread(myimgfile);
imshow(imdata)
end

function noise
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
end


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
function [width,height] = RectSize(rect)
% [width,height] = RectSize(rect)
%
% Returns the rect's width and height.
%
% 10/10/2000 fwc wrote it based on PsychToolbox RectHeight/RectWidth

if nargin~=1
	error('Usage:  [width,height] = RectSize(rect)');
end
if size(rect,2)~=4
	error('Wrong size rect argument. Usage:  [width,height] = RectSize(rect)');
end
width = rect(RectRight) - rect(RectLeft);
height = rect(RectBottom)-rect(RectTop);
end

function res = lianxu1(a)
a = [0 ones(1,5)  0 0 1 0 ones(1,10) 0] ;
b = find(a) ;
res = [] ;
n = 1 ; i = 1 ;
while i < length(b)
    j = i+1 ;
    while j <= length(b) &  b(j)==b(j-1)+1 
        n = n + 1 ;
        j = j + 1 ;
    end
    if n >= 3
        res = [res ; b(i),n] ;
    end
    n = 1 ;
    i = j ;
end
end