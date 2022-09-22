clear all
close all
% myimgfile = 'D:\PerceiveAge\RunCode\pics\\1400003.jpg'
% imdata=imread(myimgfile, 'jpg');
% figure 
% imshow(imdata)
% load('20170510ly50s.asc')
% filename  = '20170510ly50s.asc';
filename = 'xcwang20171108freeview.asc';
% filename = '20170727testmsg.asc'
fid = fopen(filename);
fseek(fid,0,'eof');
numline=ftell(fid);
fclose(fid);
rawdata = importdata(filename,'',numline);
%find the trial start message
ind=[];
ind=regexpi(rawdata,'pic \w* start');
% ind=regexpi(data,'Pic ');
ind=~cellfun(@isempty,ind);
trialstart=rawdata(ind);
trialstart=regexprep(trialstart, 'Pic \w* Begin', '');
trialstart=strrep(trialstart,'MSG','');
trialstart=cellfun(@str2num,trialstart);

%find the message of trial end
ind=[];
ind=regexpi(rawdata,'Pic \w* End');
ind=~cellfun(@isempty,ind);
trialend=rawdata(ind);
trialend=regexprep(trialend,'Pic \w* End','');
trialend=strrep(trialend,'MSG','');
trialend=cellfun(@str2num,trialend);

% find the EFIX event
ind=[];
ind=regexpi(rawdata,'EFIX');
ind=~cellfun(@isempty,ind);
efix=rawdata(ind);
efix=regexprep(efix,'EFIX R','');
efix=cellfun(@str2num,efix,'UniformOutput',false);
efix=cell2mat(efix);
efix=round(efix(:,3:5));
numFix = size(efix);
numFix = numFix(1);
% x=
% surf(efix(:,2),efix(:,3),efix(:,1))
% 把efix转为screen的矩阵
[width,height]=Screen('WindowSize',0);
picRect = [0 0 1024 700];
wRect = [0 0 width height];
[newrect,dh,dv] = CenterRect(picRect, wRect);
minX = newrect(1);
maxX = newrect(3);
minY = newrect(2);
maxY = newrect(4);
eyefixTime=zeros(1920,1080);
% eyefixTime=zeros(1024,700);
for num_Fix=1:numFix
    x=efix(num_Fix,2);
    y=efix(num_Fix,3);
    z=efix(num_Fix,1);
    eyefixTime(x,y)=z;
%     if x>=newrect(1)&&x<=newrect(3)&&y>=newrect(2)&&y<=newrect(4)
%      
%     end
end
HeatMap(eyefixTime);
figure 
hold on
contour(eyefixTime(:,:));
colormap(jet)




% if tiralstart(1,1)<=efix(:,1)<=trialend(1,1)
%     trial1=
% % end
%        r=find(trialstart(1,1)<=efix(:,1)&efix(:,1)<=trialend(1,1));

% fixEvent=cell(length(trialstart),1);
% for trialNum=1:length(trialstart)
%     fixEvent()
% end







