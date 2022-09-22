function  dataReading
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
clear;
% file=load('lwy20171123free.mat');
filename = 'xsw20171207reportopen.asc';
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

ind=[];
ind=regexpi(rawdata,'EFIX');
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
data=cell2mat(data);
eyefixEvent=cell(length(picstart),1);
eyeFix = cell(length(picstart),1);
eyefixMatrix = cell(length(picstart),1);
for picNum=1:length(picstart)
%     figure;
% pstart=find(data(:,1)==picstart(picNum,1));    
%  pstart=find(data(:,1)>=picstart(picNum,1),1,'first');
%  pend=find(data(:,1)<=picend(picNum,1),1,'last');
% find the fixation events 
 pfix = find(picstart(picNum,1)<efix(:,1)&efix(:,2)<picend(picNum,1));
 eyefixEvent(picNum,1)={efix(pfix,1:5)};
 x=eyefixEvent{picNum,1}(:,4);y=eyefixEvent{picNum,1}(:,5);
 scatter(x,y,'filled','red');
 axis([0 1920 0 1080]);
 for fixNum = 1: length(pfix) 
     s = find(data(:,1)==eyefixEvent{picNum,1}(fixNum,1));
     e = find(data(:,1)==eyefixEvent{picNum,1}(fixNum,2));
     if fixNum==1
         eyeFix=data(s:e,:);
     else 
         eyeFix= [eyeFix;data(s:e,:)];
     end
 end
 hold on 
 x=eyeFix(:,2);y=eyeFix(:,3);
 scatter(x,y);
 eyeFix = round(eyeFix(:,2:3));
 fixFre = zeros(1080,1920);
 excessWidth = find(eyeFix(:,1)>1920|eyeFix(:,1)<=0);
 eyeFix(excessWidth,:) = [];
 excessHei = find(eyeFix(:,2)>1080|eyeFix(:,2)<=0);
 eyeFix(excessHei,:) = [];
 
 for i=1:length(eyeFix(:,1))
         fixFre(eyeFix(i,2),eyeFix(i,1)) = fixFre(eyeFix(i,2),eyeFix(i,1)) +1;
 end
 eyefixMatrix(picNum,1) = {fixFre};
 eyefixOrdinate(picNum,1) ={eyeFix};
 
end

save([filename(1:end-4) '_eyetrace.mat'],'eyefixEvent','eyefixOrdinate','eyefixMatrix');
end

