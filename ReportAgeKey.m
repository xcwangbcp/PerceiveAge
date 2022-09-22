function ReportAgeKey
% AlphaImageDemo

clear all;
commandwindow;
dummymode=1;
% Standard coding practice, use try/catch to allow cleanup on error.
try
    % This script calls Psychtoolbox commands available only in OpenGL-based
    % versions of the Psychtoolbox. The Psychtoolbox command AssertPsychOpenGL will issue
    % an error message if someone tries to execute this script on a computer without
    % an OpenGL Psychtoolbox
    AssertOpenGL;

    % Screen is able to do a lot of configuration and performance checks on
	% open, and will print out a fair amount of detailed information when
	% it does.  These commands supress that checking behavior and just let
    % the demo go straight into action.  See ScreenTest for an example of
    % how to do detailed checking.
	oldVisualDebugLevel = Screen('Preference', 'VisualDebugLevel', 3);
    oldSupressAllWarnings = Screen('Preference', 'SuppressAllWarnings', 1);
    
    % Say hello in command window
%     fprintf('\nAlphaImageDemo\n');
    
    % Get the list of screens and choose the one with the highest screen number.
    % Screen 0 is, by definition, the display with the menu bar. Often when
    % two monitors are connected the one without the menu bar is used as
    % the stimulus display.  Chosing the display with the highest dislay number is
    % a best guess about where you want the stimulus displayed.
%     screenNumber=max(Screen('Screens'));

%     STEP1
    filename  = input('Please enter file name: ','s');
%     filename = edfFile;
    % Open a double buffered fullscreen window and draw a gray background
    % and front and back buffers.
        % STEP 2
    % Open a graphics window on the main screen
    % using the PsychToolbox's Screen function.
    fprintf('sceen will start\n');
    screenNumber=max(Screen('Screens'));
    fprintf('screen started\n');
    [window, wRect]=Screen('OpenWindow',screenNumber, 0,[],32,2);
    Screen(window,'BlendFunction',GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

    
    % Find the color values which correspond to white and black.
    white=WhiteIndex(screenNumber);
    black=BlackIndex(screenNumber);
    gray=GrayIndex(screenNumber); 
%     Green = [0 255 0];
%     Grey = [144 144 144];
  % STEP 3
    % Provide Eyelink with details about the graphics environment
    % and perform some initializations. The information is returned
    % in a structure that also contains useful defaults
    % and control codes (e.g. tracker state bit and Eyelink key values).
%     el=EyelinkInitDefaults(window);
    % screen params    
    centerWidth = wRect(RectRight)/2;
    centerHeight = wRect(RectBottom)/2;
      % STEP 4
    % Initialization of the connection with the Eyelink Gazetracker.
    % exit program if this fails.
    
%     if ~EyelinkInit(dummymode)
%         fprintf('Eyelink Init aborted.\n');
%         cleanup;  % cleanup function
%         return;
%     end
    
    % the following code is used to check the version of the eye tracker
    % and version of the host software
    sw_version = 0;
%     [v vs]=Eyelink('GetTrackerVersion');
%     fprintf('Running experiment on a ''%s''tracker.\n', vs );
%     fprintf('tracker version v=%d\n', v);
    
%      % open file to record data to
    tempName = 'TEMP';
%     i = Eyelink('Openfile', tempName);
%     if i~=0
%         fprintf('Cannot create EDF file ''%s'' ', edffilename);
%         cleanup;
%         return;
%     end
%     
%     
%     
%     Eyelink('command', 'add_file_preamble_text ''Recorded by runDotsPulseKey.m''');
    [width, height]=Screen('WindowSize', screenNumber);
    
    
    % STEP 5
    % SET UP TRACKER CONFIGURATION
    % Setting the proper recording resolution, proper calibration type,
    % as well as the data file content;
%     Eyelink('command','screen_pixel_coords = %ld %ld %ld %ld', 0, 0, width-1, height-1);
%     Eyelink('message', 'DISPLAY_COORDS %ld %ld %ld %ld', 0, 0, width-1, height-1);
%     % set calibration type.
%     Eyelink('command', 'calibration_type = HV9');
%     % set parser (conservative saccade thresholds)
%     
%     % set online drift correct
%     Eyelink('command', 'online_dcorr_refposn = %1d, %1d', centerWidth, centerHeight);
%     Eyelink('command', 'online_dcorr_maxangle = %1d', 30.0);
%     
%     
%     % set EDF file contents using the file_sample_data and
%     % file-event_filter commands
%     % set link data thtough link_sample_data and link_event_filter
%     Eyelink('command', 'file_event_filter = LEFT,RIGHT,FIXATION,SACCADE,BLINK,MESSAGE,BUTTON,INPUT');
%     Eyelink('command', 'link_event_filter = LEFT,RIGHT,FIXATION,SACCADE,BLINK,MESSAGE,BUTTON,INPUT');
%     
%     % check the software version
%     % add "HTARGET" to record possible target data for EyeLink Remote
%     if sw_version >=4
% %         Eyelink('command', 'file_sample_data  = LEFT,RIGHT,GAZE,HREF,AREA,HTARGET,GAZERES,STATUS,INPUT');
% %         Eyelink('command', 'link_sample_data  = LEFT,RIGHT,GAZE,GAZERES,AREA,HTARGET,STATUS,INPUT');
%     else
% %         Eyelink('command', 'file_sample_data  = LEFT,RIGHT,GAZE,HREF,AREA,GAZERES,STATUS,INPUT');
% %         Eyelink('command', 'link_sample_data  = LEFT,RIGHT,GAZE,GAZERES,AREA,STATUS,INPUT');
%     end
%     
%     
%     % allow to use the big button on the eyelink gamepad to accept the
%     % calibration/drift correction target
%     Eyelink('command', 'button_function 5 "accept_target_fixation"');
%     
%     % make sure we're still connected.
%     if Eyelink('IsConnected')~=1 && dummymode == 0
%         fprintf('not connected, clean up\n');
%         cleanup;
%         return;
%     end
%     
    
    % STEP 6
    % Calibrate the eye tracker
    % setup the proper calibration foreground and background colors

    el.backgroundcolour = black;
    el.calibrationtargetcolour = white;
    el.msgfontcolour = white;
    
    % parameters are in frequency, volume, and duration
    % set the second value in each line to 0 to turn off the sound
    el.cal_target_beep=[600 0.5 0.05];
    el.drift_correction_target_beep=[600 0.5 0.05];
    el.calibration_failed_beep=[400 0.5 0.25];
    el.calibration_success_beep=[800 0.5 0.25];
    el.drift_correction_failed_beep=[400 0.5 0.25];
    el.drift_correction_success_beep=[800 0.5 0.25];
    % you must call this function to apply the changes from above
%     EyelinkUpdateDefaults(el);
    
    % Hide the mouse cursor;
%     Screen('HideCursorHelper', window);
%     Screen('HideCursor', window);
    HideCursor;
    Screen('HideCursorHelper', window);
%     EyelinkDoTrackerSetup(el);
    
      % STEP 7
    % Now starts running individual trials;
    % You can keep the rest of the code except for the implementation
    % of graphics and event monitoring
    % Each trial should have a pair of "StartRecording" and "StopRecording"
    % calls as well integration messages to the data file (message to mark
    % the time of critical events and the image/interest area/condition
    % information for the trial)
    
    %     for i=1:3
            % Now within the scope of each trial;
            imageList = {'screenSmall.bmp'};
            imgfile= char(imageList(1));
    
            % STEP 7.1
            % Sending a 'TRIALID' message to mark the start of a trial in Data
            % Viewer.  This is different than the start of recording message
            % START that is logged when the trial recording begins. The viewer
            % will not parse any messages, events, or samples, that exist in
            % the data file prior to this message.
    %         Eyelink('Message', 'TRIALID %d', i);
    
            % This supplies the title at the bottom of the eyetracker display
    %         Eyelink('command', 'record_status_message "TRIAL %d/%d  %s', i, 3, imgfile);
            % Before recording, we place reference graphics on the host display
            % Must be offline to draw to EyeLink screen
    %         Eyelink('Command', 'set_idle_mode');
            % clear tracker display and draw box at center
    %         Eyelink('Command', 'clear_screen 0')
    %         Eyelink('command', 'draw_box %d %d %d %d 15', width/2-50, height/2-50, width/2+50, height/2+50);
    
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %transfer image to host
%             transferimginfo=imfinfo(imgfile);
    
            % image file should be 24bit or 32bit bitmap
            % parameters of ImageTransfer:
            % imagePath, xPosition, yPosition, width, height, trackerXPosition, trackerYPosition, xferoptions
%             transferStatus =  Eyelink('ImageTransfer',transferimginfo.Filename,0,0,transferimginfo.Width,transferimginfo.Height,width/2-transferimginfo.Width/2 ,height/2-transferimginfo.Height/2,4);
             if transferStatus ~= 0
                fprintf('Transfer image to host failed\n');
             end
    
    
            WaitSecs(0.1);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % STEP 7.2
    % Do a drift correction at the beginning of each trial
    % Performing drift correction (checking) is optional for
    % EyeLink 1000 eye trackers.
%     EyelinkDoDriftCorrection(el);
    
    % STEP 7.3
    % start recording eye position (preceded by a short pause so that
    % the tracker can finish the mode transition)
    % The paramerters for the 'StartRecording' call controls the
    % file_samples, file_events, link_samples, link_events availability
%     Eyelink('Command', 'set_idle_mode');
    WaitSecs(0.05);
%     %         Eyelink('StartRecording', 1, 1, 1, 1);
%     Eyelink('StartRecording');
%     eye_used = Eyelink('EyeAvailable'); % get eye that's tracked
    
    % record a few samples before we actually start displaying
    % otherwise you may lose a few msec of data
    WaitSecs(0.1);
    
    
    
    
    % Import image and and convert it, stored in
    % MATLAB matrix, into a Psychtoolbox OpenGL texture using 'MakeTexture';
%   myimgfile = [ PsychtoolboxRoot 'PsyhengchDemos' filesep 'AlphaImageDemo' filesep '1400001.jpg'];
%     currentFolder=pwd;
    file_path = [pwd '\pics\'];% 图像文件夹路径
    img_path_list = dir(strcat(file_path,'*.png'));%获取该文件夹中所有jpg格式的图像
    img_num = length(img_path_list);%获取图像总数量
    picSeq = randperm(img_num);
    showSeq = cell(img_num,1);
    ageRangeChoose = cell(img_num,1);
    
    results.ageRangeR2 = zeros(5,4);
    rspTextCol = white;
    rangeCol = [222 125 44];
    Screen('TextSize', window, 30);
    loaRange = zeros(6,2);
    loaRange(:,2)=300;
    loaRange(1,1)=400;loaRange(2,1)=600;loaRange(3,1)=800;loaRange(4,1)=1000;
    loaRange(5,1)=1200;loaRange(6,1)=1400;
    rangeX = loaRange(1,1)-10;
    rangeY = loaRange(1,2)-150;
    ageRange = {'20~30','30~40','40~50','50~60','60~70','70~80'}; 
    agelist = [30 31 32 33 34 35 36 37 38 39];
    age_num = length(agelist);
    reportAge = zeros(img_num,1);
    loaAge = zeros(10,2); 
    loaAge(1:5,2) = 600; loaAge(6:10,2) = 700;
    loaAge(1,1)=500;loaAge(2,1)=700;loaAge(3,1)=900;loaAge(4,1)=1100;loaAge(5,1)=1300;
    loaAge(6,1)=500;loaAge(7,1)=700;loaAge(8,1)=900;loaAge(9,1)=1100;loaAge(10,1)=1300;
    yDistance = 300;
    
%     frameRate = round(FrameRate(window));
%     ifi_duration = Screen('GetFlipInterval',window);
%     reportBackCol = [179 168 150];
    objectdiam = 15;
    fixLocation = CenterRectOnPoint( [0 0 objectdiam objectdiam], wRect(RectRight)/2, wRect(RectBottom)/2);
    windowFix = 50;
    fixationTime=0.8;
    picOnTime = 1; % in seconds
    backGrounCol =[0 0 0];
    fixCol = [0 255 0];
    rspCol = [0 255 0];
    
    % show pic by pic and report
  for   Pic=1:img_num      
        myimgfile = [ file_path  filesep img_path_list(picSeq(Pic),1).name];
        showSeq (Pic,1)={img_path_list(picSeq(Pic),1).name};
        imdata=imread(myimgfile, 'png');
%         Eyelink('message', 'trial %d start',Pic);
   
    % Add a fixaion page to do drift correction
%         Screen('FillRect',window, backGrounCol);
%         Screen('FillOval',window,fixCol,fixLocation);
        fixed = false;
%         while ~fixed
%                  %show fixation
%                   Screen('FillRect',window,  backGrounCol);
%                   Screen('FillOval',window,fixCol,fixLocation);
%                   vbl = Screen('Flip',window);
% %                   Eyelink('message','fixation start');
%                   while ((GetSecs - vbl) < fixationTime), end; %wait for 1 sec
%                   if Eyelink( 'NewFloatSampleAvailable') > 0
%                      % get the sample in the form of an event structure
%                      evt = Eyelink( 'NewestFloatSample');
%                      if eye_used ~= -1 % do we know which eye to use yet?
%                          % if we do, get current gaze position from sample
%                          x = evt.gx(eye_used+1); % +1 as we're accessing MATLAB array
%                          y = evt.gy(eye_used+1);
%                          % do we have valid data and is the pupil visible?
%                          if x~=el.MISSING_DATA && y~=el.MISSING_DATA && evt.pa(eye_used+1)>0
%                              mx=x;
%                              my=y;
%                          end
%                      end
%                      if mx<centerWidth-windowFix || mx>centerWidth+windowFix || my<centerHeight-windowFix || my>centerHeight+windowFix % if leave fixation
%                          rspText = 'Fixation Break';
%                          rspLocX = round(wRect(RectRight)/2)-150;
%                          rspLocY = round(wRect(RectBottom)/2)-50;
%                          Screen('DrawText',window, rspText,rspLocX,rspLocY,rspCol);
%                          Screen('FillOval',window,fixCol,fixLocation);
%                          feedFB = Screen('Flip',window);
%                          while (GetSecs - feedFB)<fixationTime,  end;
%                      else
%                          fixed = true;
%                      end
%                  else
%                      fixed = true;
%                   end
%         end
%       Eyelink('message', 'fixation end');
    % set up texture and rects
      imagetex=Screen('MakeTexture', window, imdata(1:end, 1:end,:));
      tRect=Screen('Rect', imagetex);
      CenterRect(tRect, wRect);

%     Flip the picSeq_th pic on the  sceen
      Screen('DrawTexture', window, imagetex);
      HideCursor;
     [VBLTimestamp StimulusOnsetTime FlipTimestamp Missed Beampos] = Screen('Flip', window);
%     [vbl,stimulusOnset] = Screen('Flip',window);
%      Eyelink('message', 'pic %d start',Pic);
        while (GetSecs-VBLTimestamp)<picOnTime % make sure subjects look at the pics at least 5 second
        end
     Beeper(400,0.4,0.15);
     results.StimulusOnsetTime(Pic,1) = VBLTimestamp;

%%%% wait for the key to be pressed then move to the report page
     keyPressed = false;
     while ~keyPressed %&& (getsecs - tMotionFrame(trialI,i))<1
             [ keyIsDown, timeSecs, keyCode ] = KbCheck;
             if keyIsDown
                 keyPressed = true;
                 results.responseTime(Pic,1) = timeSecs - VBLTimestamp;%second
%                  results.responseTime = responseTime;
                 break,
             end
      end
%      Eyelink('message',  'pic %d end',Pic);
     
     % draw the rangetext and range on the screen
     Screen('FillRect',window, uint8(gray));
     rangeText = 'Choose the Age Range for this Picture.';
%      rangeX =  round(wRect(RectRight)/3); 
%      rangeY =  round(wRect(RectBottom)/4)-70;
     Screen('DrawText',window, rangeText,rangeX,rangeY,rspTextCol);

       for rangeSeqDraw = 1:length(ageRange)
             switch rangeSeqDraw
                   
                   case 1
                       ageRangeText = '20~30';
                   case 2
                       ageRangeText = '30~40';
                   case 3
                       ageRangeText = '40~50';
                   case 4
                       ageRangeText = '50~60';
                   case 5
                       ageRangeText = '60~70';
                   case 6 
                       ageRangeText = '70~80';
             end

          [R1,R2]=Screen('TextBounds',window,ageRangeText,loaRange(rangeSeqDraw,1),loaRange(rangeSeqDraw,2));
          results.ageRangeR2(rangeSeqDraw,:)=[R2(1)-10 R2(2)-10 R2(3)+10 R2(4)+10];
          Screen('FillRect',window,rangeCol,results.ageRangeR2(rangeSeqDraw,:));
          Screen('DrawText',window, ageRangeText,loaRange(rangeSeqDraw,1),loaRange(rangeSeqDraw,2),rspTextCol);
       end
%       Eyelink('message', 'show pic range on the screen');
      Screen('Flip', window);
%     WaitSecs(5) % 
    %%% Get the button position and judge which it is point to.
     mousePressed=0;
     ShowCursor('Arrow',window)
     
     while ~mousePressed
         [clicks,mAgeRangeX,mAgeRangeY,botton]=GetClicks(window);
%          mX>=R2(1)&&mX<=R2(3)&&mY>=R2(2)&&mY<=R2(4)
         mAgeRangePosition(Pic,:)=[mAgeRangeX,mAgeRangeY];
         for rangeSeqChoose = 1:length(ageRange)
             if mAgeRangeX>=results.ageRangeR2(rangeSeqChoose,1)&&mAgeRangeX<=results.ageRangeR2(rangeSeqChoose,3)&&mAgeRangeY>=results.ageRangeR2(rangeSeqChoose,2)&& mAgeRangeY<=results.ageRangeR2(rangeSeqChoose,4)
                results.rangePionter(Pic)=rangeSeqChoose;
                mousePressed=1;
             end
         end
     end
     

      % draw again
%      rangeText = 'Choose the Age Range List for this Picture.';
%      rangeX =  round(wRect(RectRight)/3)-140; 
%      rangeY =  round(wRect(RectBottom)/4)-70;
     Screen('DrawText',window, rangeText,rangeX,rangeY,rspTextCol);

         switch results.rangePionter(Pic)
             case 1
                 ageRangeText = '20~30';
             case 2
                 ageRangeText = '30~40';
             case 3
                 ageRangeText = '40~50';
             case 4
                 ageRangeText = '50~60';
             case 5
                 ageRangeText = '60~70';
             case 6
                 ageRangeText = '70~80';
         end
        ageRangeChoose (Pic,1) = {ageRangeText};
        rangeSeq = 3; % place the chosen choice in the middle.
        [R1,R2]=Screen('TextBounds',window,ageRangeText,loaRange(rangeSeq,1),loaRange(rangeSeq,2));
        results.ageRangeR2(rangeSeq,:)=[R2(1)-10 R2(2)-10 R2(3)+10 R2(4)+10];
        Screen('FillRect',window,rangeCol,results.ageRangeR2(rangeSeq,:));
        Screen('DrawText',window, ageRangeText,loaRange(rangeSeq,1),loaRange(rangeSeq,2),rspTextCol);%y position move 50 up

     questionText = 'Choose a Specific Age with Mouse.';
     Screen('DrawText',window, questionText,rangeX,rangeY+yDistance,rspTextCol);% draw question

    rangePionter = cell(5,1);
    switch results.rangePionter(Pic)
        case 1
            age = [20 21 22 23 24 25 26 27 28 29];
        case 2 
            age = [30 31 32 33 34 35 36 37 38 39];

        case 3
            age = [40 41 42 43 44 45 46 47 48 49];

        case 4
            age = [50 51 52 53 54 55 56 57 58 59];

        case 5
            age = [60 61 62 63 64 65 66 67 68 69];
        case 6
            age = [70 71 72 73 74 75 76 77 78 79];
    end
    
%     pionter=0;
     for age_Seq=1:age_num
         Agetext=num2str(age(age_Seq));
         X=loaAge(age_Seq,1)-50;Y=loaAge(age_Seq,2)-50;
         [R1,R2] = Screen('TextBounds',window,Agetext,X,Y);% draw first option
%      Screen('FrameRect',window,0,R2);
%      R2=OffsetRect(R2,10,10); %将文本边界向右向下位移10个像素
         R2=[R2(1)-25 R2(2)-5 R2(3)+25 R2(4)+5];
         R(age_Seq,:)=R2;
         Screen('FillRect',window,rangeCol,R2);
         Screen('DrawText',window, Agetext,X,Y,rspTextCol);
     end 
%      Eyelink('message', 'show pic age option on the screen');
     Screen('Flip', window);
     WaitSecs(0.1)

%%% Get the button position and judge which it is point to.
     mousePressed=0;
     ShowCursor('Arrow',window)
     
     while ~mousePressed
         [clicks,mX,mY,botton]=GetClicks(window);
%          mX>=R2(1)&&mX<=R2(3)&&mY>=R2(2)&&mY<=R2(4)
         mousePosition(Pic,:)=[mX,mY];
         for ageSeq=1:age_num
%         [clicks,mX,mY,botton]=GetClicks(window);      
             if mX>=R(ageSeq,1)&&mX<=R(ageSeq,3)&&mY>=R(ageSeq,2)&& mY<=R(ageSeq,4)
                agePointer(Pic)=ageSeq;
                mousePressed=1;
             end
         end
     end
      HideCursor;
%       Eyelink('message', 'trial %d end',Pic);
      reportAge(Pic) = agePointer(Pic)+(results.rangePionter(Pic)+2)*10-1;
 end  
    % The same command which closes onscreen and offscreen windows also
    % closes textures.
    
    results.showSeq = showSeq;
    results.ageRange = ageRangeChoose;
    results.age = reportAge;
    results.agePointer=agePointer;
    results.rangeSeqChoose = rangeSeqChoose;
    Screen('CloseAll');
    ShowCursor;
    Priority(0);
    
    % Restore preferences
    Screen('Preference', 'VisualDebugLevel', oldVisualDebugLevel);
    Screen('Preference', 'SuppressAllWarnings', oldSupressAllWarnings);
    
% This "catch" section executes in case of an error in the "try" section
% above.  Importantly, it closes the onscreen window if it's open.
catch ME

    Screen('CloseAll');
    ShowCursor;
    Priority(0);
    rethrow(ME);
    % Restore preferences
    Screen('Preference', 'VisualDebugLevel', oldVisualDebugLevel);
    Screen('Preference', 'SuppressAllWarnings', oldSupressAllWarnings);
    psychrethrow(psychlasterror);
end

% Eyelink('command', 'set_idle_mode');
WaitSecs(0.5);
% Eyelink('CloseFile');
pathname = uigetdir('C:\Documents and Settings\Gunnar Blohm\My Documents\Hong\Flora(data)', 'Please choose a folder to save file');
%% download data file
try
    fprintf('Receiving data file ''%s''\n',filename);
%     status = Eyelink('ReceiveFile',tempName ,pathname,1);
    if status > 0
        fprintf('ReceiveFile status %d\n ', status);
    end
    if 2 == exist(filename, 'file')
        fprintf('Data file ''%s'' can be found in '' %s\n',filename, pwd);
    end
catch
    fprintf('Problem receiving data file ''%s''\n',filename);
end

%close the eye tracker.
% Eyelink('ShutDown');
save([pathname '\' filename],'results');
movefile([pathname,'\',tempName,'.edf'],[pathname,'\',filename,'.edf'],'f');

