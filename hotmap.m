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