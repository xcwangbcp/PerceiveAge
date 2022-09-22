load('xsw20171505free.mat');
file_path = [pwd '\pics\'];% Í¼ÏñÎÄ¼þ¼ÐÂ·¾¶
img_path_list = dir(strcat(file_path,'*.png'));
showSeq=results.showSeq;%report
myimgfile = [ file_path showSeq(1)];
myimgfile = cell2mat(myimgfile);
imdata=imread(myimgfile);
imshow(imdata)