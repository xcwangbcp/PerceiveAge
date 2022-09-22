% myimgfile = 'E:\WXC\RunCode\pics\\1400003.jpg'
close all
myimgfile = 'D:\PerceiveAge\RunCode\pics\\1400003.jpg'
imdata=imread(myimgfile, 'jpg');
figure 
imshow(imdata)
fixation=zeros(700,1024);
% twoD=imdata(:,:,1);
% figure
% y = [70,140,210,280,350,420,490,560,630,700];
% x = [100,200,300,400,500,600,700,800,900,1000];
% % fixation(20,20) = 1; 
% % fixation(100,100)=100;
% % fixation(100,100)=100;
% % fixation(600,900) = 1; 
% % fixation(50,200)=100;
% % fixation(600,300)=100;
% % imshow(fixation);
% hold on
% scatter(x,y,10,'filled')  % the third is the size of marker,10 ids good enough
% figure
% sum=0.5*imdata+0.5*fiaxtion;
% imshow(sum)
% x=zeros(5,5);
% x(1,1)=10;x(2,2)=20;x(3,3)=30;x(4,4)=1;x(5,5)=40;
% imshow(x)