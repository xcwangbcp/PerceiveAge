function  dataReadingsingle 
% update on 2019/5/21 fix the bug on the fixation matrix and made the
% zuobiaoxi from eyelink to normal zhijiaozuobiao.
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
clear;
% filename = 'lwk20180327c.asc';
[filename,mypath] = uigetfile('*.asc')
% mypath = pwd;
cd(mypath)
load([filename(1:end-4) '.mat']);
% load('xsw20171207reportopen.mat');
% filename = 'xcwang20171108reportage.asc';
% filename = '20170727testmsg.asc'
fid = fopen(filename);
fseek(fid,0,'eof'); %将文件指针至于文件结尾处
numline=ftell(fid);
fclose(fid); 
rawdata = importdata(filename,'',numline);
ind=[];
ind=regexpi(rawdata,'pic \w* start');
ind=~cellfun(@isempty,ind);                                     
picstart=rawdata(ind);
picstart=regexprep(picstart, ' pic \w* start', '');
picstart=strrep(picstart,'MSG','');
picstart=cellfun(@str2num,picstart);

ind=[];
ind=regexpi(rawdata,'pic \w* end');
ind=~cellfun(@isempty,ind);
picend=rawdata(ind);
picend=regexprep(picend, ' pic \w* end', '');
picend=strrep(picend,'MSG','');
picend=cellfun(@str2num,picend);
% find the eye fixation event
ind=[];
ind=regexpi(rawdata,'EFIX');% locate those parts of string that match the character specified by regular expression
ind=~cellfun(@isempty,ind);
efix=rawdata(ind);
efix=regexprep(efix,'EFIX L','');
efix=cellfun(@str2num,efix,'UniformOutput',false);
efix=cell2mat(efix);

ind=[];
ind=strfind(rawdata,'...');
ind=~cellfun(@isempty,ind);
data=rawdata(ind);
clear rawdata;
data=strrep(data,'...','0'); % switch the .... to 0
data=cellfun(@str2num,data, 'UniformOutput',false);
data=cell2mat(data);% data means all of the no-zero data,including all

eyefixEvent=cell(length(picstart),1); % fixation event distributed in 20/40 pics
eyefixOrdinate = cell(length(picstart),1);%eyeFix save all the eye fixation samples during a pics
eyefixMatrix = cell(length(picstart),1);

% length=20; % number of pids
% fixFre = zeros(1080,1920);

for picNum=1:length(picstart)
%     figure;
% pstart=find(data(:,1)==picstart(picNum,1));    
%  pstart=find(data(:,1)>=picstart(picNum,1),1,'first');
%  pend=find(data(:,1)<=picend(picNum,1),1,'last');
% find the fixation events 
 pfix = find(picstart(picNum,1)<efix(:,1)&efix(:,2)<picend(picNum,1));
 eyefixEvent(picNum,1)={efix(pfix,1:5)};
%  x=eyefixEvent{picNum,1}(:,4);y=eyefixEvent{picNum,1}(:,5);
%  scatter(x,y,'filled','red');
%  axis([0 1920 0 1080]);
% eyeFix save all the eye fixation samples during a pics 
     for fixNum = 1: length(pfix) 
         s = find(data(:,1)==eyefixEvent{picNum,1}(fixNum,1));
         e = find(data(:,1)==eyefixEvent{picNum,1}(fixNum,2));
        if fixNum==1
           eyetraceFix=data(s:e,:);
        else 
           eyetraceFix= [eyetraceFix;data(s:e,:)];
        end
     end
%  hold on 
%  x=eyeFix(:,2);y=eyeFix(:,3);
%  scatter(x,y);
% exclude the eye Fix data that expand the region of screen
%  eyeFix = round(eyeFix(:,2:3));
% sy=size(eyeFix);
 eyeFix = eyetraceFix(:,2:3);
 
 excessWidth = find(eyeFix(:,1)>1920|eyeFix(:,1)<=0);
 eyeFix(excessWidth,:) = [];
 excessHei = find(eyeFix(:,2)>1080|eyeFix(:,2)<=0);
 eyeFix(excessHei,:) = [];
 eyeFix = ceil(eyeFix);
 
 fixFre = zeros(1080,1920);
    for i=1:length(eyeFix(:,1))
         fixFre(eyeFix(i,2),eyeFix(i,1)) = fixFre(eyeFix(i,2),eyeFix(i,1)) +1;
    end
    eyefixMatrix(picNum,1) = {fixFre};
    eyefixOrdinate{picNum,1}(:,1) = eyeFix(:,1);
    eyefixOrdinate{picNum,1}(:,2) = 1080-eyeFix(:,2);
end


s=cat(1,eyefixEvent{:});
for picNum=1:length(picstart)
    [r,c]=size(eyefixEvent{picNum,1});
    for name = 1:r
        pic{picNum,1}{name,1} = {results.showSeq{picNum,1}};
    end
end
pic=cat(1,pic{:});
eyefixPic=cat(2,num2cell(s),pic);
savepath = 'H:\myD\PerceiveAge\02Data\20sbs201803\preProcessData\';
save([savepath filename(1:end-4) '_eyetrace.mat'],'eyefixMatrix','eyefixPic','eyefixEvent','eyefixOrdinate');
% fid=fopen('a.txt');
% fprintf(fid,'%d %d %d %f %f %s\n',eyefixPic);
end

