function dat=loadasc(filename,hres,vres,pixel2deg)
%import ascfile to matlab
%hres,horizontal reslution of the screen
%vres,vertical reslucton of the screen
%pixel2deg,one degree equal to pixel2deg pixels
%
% 02/21/14 MP made program
% 
% 02/21/14 JK changed "subject response" to "key response" and "eye
% response"
%
% 03/04/14 JK changed program to account for lost "trial start" messages

if nargin<4
    pixel2deg=33.8703;
end
if nargin<3
    vres=1024;
end
if nargin<2
    hres=1280;
end
fid=fopen(filename);
fseek(fid,0,'eof');
numline=ftell(fid);
fclose(fid);
rawdata=importdata(filename,' ',numline);
%find the trial start message
ind=[];
ind=regexpi(rawdata,'trial \w* start');
ind=~cellfun(@isempty,ind);
trialstart=rawdata(ind);
trialstart=regexprep(trialstart, ' trial \w* start', '');
trialstart=strrep(trialstart,'MSG','');
trialstart=cellfun(@str2num,trialstart);
%find the fixation start
ind=[];
ind=regexpi(rawdata,'fixation start');
ind=~cellfun(@isempty,ind);
fixst=rawdata(ind);
fixst=strrep(fixst,' fixation start','');
fixst=strrep(fixst,'MSG','');
fixst=cellfun(@str2num,fixst);
%find the target01 on
ind=[];
ind=regexpi(rawdata,'target01 on');
ind=~cellfun(@isempty,ind);
targeton01=rawdata(ind);
targeton01=strrep(targeton01,' target01 on','');
targeton01=strrep(targeton01,'MSG','');
targeton01=cellfun(@str2num,targeton01);
%find the target02 before flip on
ind=[];
ind=regexpi(rawdata,'target02 before flip on');
ind=~cellfun(@isempty,ind);
targeton02_b=rawdata(ind);
targeton02_b=strrep(targeton02_b,' target02 before flip on','');
targeton02_b=strrep(targeton02_b,'MSG','');
targeton02_b=cellfun(@str2num,targeton02_b);
%find the target02 on
ind=[];
ind=regexpi(rawdata,'target02 on');
ind=~cellfun(@isempty,ind);
targeton02=rawdata(ind);
targeton02=strrep(targeton02,' target02 on','');
targeton02=strrep(targeton02,'MSG','');
targeton02=cellfun(@str2num,targeton02);
%find the target03 on
ind=[];
ind=regexpi(rawdata,'target03 on');
ind=~cellfun(@isempty,ind);
targeton03=rawdata(ind);
targeton03=strrep(targeton03,' target03 on','');
targeton03=strrep(targeton03,'MSG','');
targeton03=cellfun(@str2num,targeton03);
%find the target04 on
ind=[];
ind=regexpi(rawdata,'target04 on');
ind=~cellfun(@isempty,ind);
targeton04=rawdata(ind);
targeton04=strrep(targeton04,' target04 on','');
targeton04=strrep(targeton04,'MSG','');
targeton04=cellfun(@str2num,targeton04);
%find the message of trial end
ind=[];
ind=regexpi(rawdata,'trial end');
ind=~cellfun(@isempty,ind);
trialend=rawdata(ind);
trialend=strrep(trialend,' trial end','');
trialend=strrep(trialend,'MSG','');
trialend=cellfun(@str2num,trialend);
%extrace data
ind=[];
ind=strfind(rawdata,'...');
ind=~cellfun(@isempty,ind);
data=rawdata(ind);
clear rawdata;
data=strrep(data,'...','');
data=cellfun(@str2num,data, 'UniformOutput',false);
data=cell2mat(data);
%insert the nan to blink time point that missed from cell2mat(data)
time=[];
time=data(:,1);
dt=mode(diff(time));
ind=[];
ind=(time-time(1))/dt+1;
ndata=[];
ndata=zeros(ind(end),size(data,2))*nan;
ndata(:,1)=time(1):dt:time(end);
ndata(ind,2:end)=data(:,2:end);
clear data;
%change the units from pixel to degree
ndata(:,2)=(ndata(:,2)-(hres/2))/pixel2deg;
ndata(:,3)=(ndata(:,3)-(vres/2))/pixel2deg;%the positive degree here is downward
ndata(:,3)=-1*ndata(:,3); %we change the downward degree form positive to negative
%refine the st and et of every trial
emp=[];
repInd=[];
repVal=[];
for k=1:length(trialend)
    row=[];
    if k==1
        row=find(trialstart<trialend(k));
        if length(row)>1
            emp=[emp;row(1:end-1)];
        end
    else
        row=find(trialstart>=trialend(k-1)&trialstart<trialend(k));
        if length(row)>1
            emp=[emp;row(1:end-1)];
        elseif length(row)<1 % for errors in recording "trial start" messages
            repInd=[repInd;k];
            tempInd=find(fixst>=trialend(k-1)&fixst<trialend(k),1,'last');
            repVal=[repVal;fixst(tempInd)];
        end
    end
end
trialstart(emp)=[];
for x=1:size(repInd,1)
    trialstart=[trialstart(1:repInd(x)-1);repVal(x);trialstart(repInd(x):end)];
end
trialend(end)=ndata(end,1);
%group the datapoint to different trials
for k=1:length(trialstart)
    indst=[];indet=[];
    indst=find(ndata(:,1)>=trialstart(k),1,'first');
    indet=find(ndata(:,1)<=trialend(k),1,'last');
    dat(k).time=ndata(indst:indet,1);
    dat(k).x=ndata(indst:indet,2);
    dat(k).y=ndata(indst:indet,3);
    dat(k).pupil=ndata(indst:indet,4);
    
    dis=[];
    dis=abs(dat(k).time-fixst(fixst>=trialstart(k)&fixst<=trialend(k)));
    [peak,pos]=min(dis);
    dat(k).fixst=dat(k).time(pos);
    
    dis=[];
    dis=abs(dat(k).time-targeton01(targeton01>=trialstart(k)&targeton01<=trialend(k)));
    [peak,pos]=min(dis);
    dat(k).targeton01=dat(k).time(pos);
    
    dis=[];
    dis=abs(dat(k).time-targeton02_b(targeton02_b>=trialstart(k)&targeton02_b<=trialend(k)));
    [peak,pos]=min(dis);
    dat(k).targeton02_b=dat(k).time(pos);
    
    dis=[];
    dis=abs(dat(k).time-targeton02(targeton02>=trialstart(k)&targeton02<=trialend(k)));
    [peak,pos]=min(dis);
    dat(k).targeton02=dat(k).time(pos);
    
    dis=[];
    dis=abs(dat(k).time-targeton03(targeton03>=trialstart(k)&targeton03<=trialend(k)));
    [peak,pos]=min(dis);
    dat(k).targeton03=dat(k).time(pos);
    
    dis=[];
    dis=abs(dat(k).time-targeton04(targeton04>=trialstart(k)&targeton04<=trialend(k)));
    [peak,pos]=min(dis);
    dat(k).targeton04=dat(k).time(pos);
    
    dat(k).freq=(1/dt)*1000;
end

save([filename(1:end-4) '_eyetrace.mat'],'dat');
