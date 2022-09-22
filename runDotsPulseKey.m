function runDotsPulseKey  

% Random dots task with pulses of coherence change at 6 different intervals
% to test model in Standage et al. 2013. The program is currently set up to
% produce a negative pulse (decrease in coherence) and the amount to
% decrease by is set by the experimenter.Subjects use eye movements to make
% a response.
%
% This program calls coherentMOT6.m. Please make sure it is in the current
% folder.
%
% Saves 2 files: 1) an EDF file from Eyelink that needs to be converted into
% ASC format using SR Research's program. This program can be found inside
% the Utilities folder in Eyelink's folder. 2) a .mat file containing many
% useful variables used in the program. The variable 'result' is the most
% useful.
%
% Made using 64-bit Windows 7 running 32-bit Matlab 2009a with
% Psychtoolbox. Tested on Eyelink 1000.
%
% HISTORY
%
% mm/dd/yy
% 06/??/13 JK   Made program by combining
% "C:\toolbox\Psychtoolbox\PsychHardware\EyelinkToolbox\Frank_testing\Eyeli
% nkExample.m", "cd \Old versions\noiseXPVer1_EL_Flora2.m", and
% "C:\toolbox\Psychtoolbox\PsychHardware\EyelinkToolbox\EyelinkDemos\GazeCo
% ntingentDemos\EyelinkGazeContingentDemo.m"
%
% 07/12/13 JK 	Added 2 more stimulus durations, giving experimenter 3
% choices: 700ms, 1000ms, and 1500ms. Pulse times for 1000ms are according to
% Dominic's model, all other pulse times are evenly distributed so that the
% 1st pulse always start at 100ms and the last pulse ends at the end of the
% stimulus

clear all;
commandwindow;
dummymode=1;

try
    % STEP 1
    % Ask subjects for input about trial number, coherence and file name
    
    c.coh = input('Please input the coherence: ');
%     c.coh = 0.04;

    gotNumTrials = 'No';
    while strcmp(gotNumTrials,'No')
        numTrials = input('Please input how many trials you want run: ');
        if numTrials > 300
            question = sprintf( 'Are you sure you want %d trials?', numTrials);
            gotNumTrials = questdlg(question,'Check number of trials','Yes','No','No');
        else
            gotNumTrials = 'Yes';
        end
    end
    edfFile = input('Please enter file name: ','s');
    filename = edfFile;
    deltaCohIn = input('Please input decrease coherence: ');
    while deltaCohIn > c.coh
        warning = sprintf('Decrease coherence must be below default coherence (%0.2f).',c.coh);
        warndlg(warning,'Invalid decreasee coherence')
        deltaCohIn = input('Please input decrease coherence: ');
    end
    tMotion = input('Please input stimulus duration (700, 1000, 1500): ');
    while tMotion~=700 && tMotion~=1000 && tMotion~=1500
        warning = sprintf('Stimulus duration must be 700, 1000, or 1500');
        warndlg(warning,'Invalid stimulus duration')
        tMotion = input('Please input stimulus duration (700, 1000, 1500): ');
    end
    tempName = 'TEMP';
    
    
    
    % STEP 2
    % Open a graphics window on the main screen
    % using the PsychToolbox's Screen function.
    fprintf('sceen will start\n');
    screenNumber=max(Screen('Screens'));
    fprintf('screen started\n');
    [window, wRect]=Screen('OpenWindow', screenNumber, 0,[],32,2);
    Screen(window,'BlendFunction',GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    
    frameRate = round(FrameRate(window));
    ifi_duration = Screen('GetFlipInterval',window);
    
    %set up xp parameter
    
    timeScale = 1;
    if tMotion == 700
        pulse = [100, 160, 220, 280, 340, 400]/timeScale/1000;
    elseif tMotion == 1000
        pulse = [100, 250, 400, 550, 625, 700]/timeScale/1000; % Dom's original numbers 
    elseif tMotion == 1500
        pulse = [100, 280, 460, 640, 820, 1000]/timeScale/1000;
    else
        disp('Invalid stimulus duration!!')
        keyboard
    end
    tMotion = tMotion/timeScale/1000; % from ms to s
    dir = [0 180];
    randData1 = randperm(numTrials);% for pulse
    randData2 = randperm(numTrials);% for direction
    randData3 = randperm(numTrials);
    
    durPulse = 300; %ms
    deltaCoh = [0, -deltaCohIn];%deltaConIn=decrease
    c.screensize = wRect(RectBottom)*1/3;% in pixels
    c.numberdots = 250;
    c.LM = tMotion * frameRate; % movie length (frames)
    c.velo = 5; % dot movement speed in pixels / frame
    c.q1 = 1;%quartile, eg: 1: 100%, 0.5:50%
    c.q2 = 1;%quartile for change back, eg: 1: 100%, 0.5:50%
    c.nRand = 10;%how many times to change random dots position
    lPulse = round(durPulse/timeScale/1000* frameRate);
    objectdiam = 3 ;
    %     c.coh = 0.08; %change to input
    rwd = 0;
    numCorrect = 0;
    numWrong = 0;
    numAbort = 0;
    
    % Set colors.
    black = BlackIndex(window);
    white = WhiteIndex(window);
    red = [255 0 0];
    col = [1:250; 1:250; 1:250;]';
    green = [0 255 0];
    
    % screen params    
    centerWidth = wRect(RectRight)/2;
    centerHeight = wRect(RectBottom)/2;
    fixLocation = CenterRectOnPoint( [0 0 objectdiam objectdiam], wRect(RectRight)/2, wRect(RectBottom)/2);
    windowFix = 50;
    
    
    % STEP 3
    % Provide Eyelink with details about the graphics environment
    % and perform some initializations. The information is returned
    % in a structure that also contains useful defaults
    % and control codes (e.g. tracker state bit and Eyelink key values).
    el=EyelinkInitDefaults(window);
    
    
    
    % STEP 4
    % Initialization of the connection with the Eyelink Gazetracker.
    % exit program if this fails.
    
    if ~EyelinkInit(dummymode)
        fprintf('Eyelink Init aborted.\n');
        cleanup;  % cleanup function
        return;
    end
    
    % the following code is used to check the version of the eye tracker
    % and version of the host software
    sw_version = 0;
    [v vs]=Eyelink('GetTrackerVersion');
    fprintf('Running experiment on a ''%s''tracker.\n', vs );
    fprintf('tracker version v=%d\n', v);
    
    
    
    % open file to record data to
    i = Eyelink('Openfile', tempName);
    if i~=0
        fprintf('Cannot create EDF file ''%s'' ', edffilename);
        cleanup;
        return;
    end
    
    
    
    Eyelink('command', 'add_file_preamble_text ''Recorded by runDotsPulseKey.m''');
    [width, height]=Screen('WindowSize', screenNumber);
    
    
    % STEP 5
    % SET UP TRACKER CONFIGURATION
    % Setting the proper recording resolution, proper calibration type,
    % as well as the data file content;
    Eyelink('command','screen_pixel_coords = %ld %ld %ld %ld', 0, 0, width-1, height-1);
    Eyelink('message', 'DISPLAY_COORDS %ld %ld %ld %ld', 0, 0, width-1, height-1);
    % set calibration type.
    Eyelink('command', 'calibration_type = HV9');
    % set parser (conservative saccade thresholds)
    
    % set online drift correct
    Eyelink('command', 'online_dcorr_refposn = %1d, %1d', centerWidth, centerHeight);
    Eyelink('command', 'online_dcorr_maxangle = %1d', 30.0);
    
    
    % set EDF file contents using the file_sample_data and
    % file-event_filter commands
    % set link data thtough link_sample_data and link_event_filter
    Eyelink('command', 'file_event_filter = LEFT,RIGHT,FIXATION,SACCADE,BLINK,MESSAGE,BUTTON,INPUT');
    Eyelink('command', 'link_event_filter = LEFT,RIGHT,FIXATION,SACCADE,BLINK,MESSAGE,BUTTON,INPUT');
    
    % check the software version
    % add "HTARGET" to record possible target data for EyeLink Remote
    if sw_version >=4
        Eyelink('command', 'file_sample_data  = LEFT,RIGHT,GAZE,HREF,AREA,HTARGET,GAZERES,STATUS,INPUT');
        Eyelink('command', 'link_sample_data  = LEFT,RIGHT,GAZE,GAZERES,AREA,HTARGET,STATUS,INPUT');
    else
        Eyelink('command', 'file_sample_data  = LEFT,RIGHT,GAZE,HREF,AREA,GAZERES,STATUS,INPUT');
        Eyelink('command', 'link_sample_data  = LEFT,RIGHT,GAZE,GAZERES,AREA,STATUS,INPUT');
    end
    
    
    % allow to use the big button on the eyelink gamepad to accept the
    % calibration/drift correction target
    Eyelink('command', 'button_function 5 "accept_target_fixation"');
    
    % make sure we're still connected.
    if Eyelink('IsConnected')~=1 && dummymode == 0
        fprintf('not connected, clean up\n');
        cleanup;
        return;
    end
    
    
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
    EyelinkUpdateDefaults(el);
    
    % Hide the mouse cursor;
    Screen('HideCursorHelper', window);
    EyelinkDoTrackerSetup(el);
    
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
            transferimginfo=imfinfo(imgfile);
    
            % image file should be 24bit or 32bit bitmap
            % parameters of ImageTransfer:
            % imagePath, xPosition, yPosition, width, height, trackerXPosition, trackerYPosition, xferoptions
            transferStatus =  Eyelink('ImageTransfer',transferimginfo.Filename,0,0,transferimginfo.Width,transferimginfo.Height,width/2-transferimginfo.Width/2 ,height/2-transferimginfo.Height/2,4);
             if transferStatus ~= 0
                fprintf('Transfer image to host failed\n');
             end
    
    
            WaitSecs(0.1);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % STEP 7.2
    % Do a drift correction at the beginning of each trial
    % Performing drift correction (checking) is optional for
    % EyeLink 1000 eye trackers.
    EyelinkDoDriftCorrection(el);
    
    % STEP 7.3
    % start recording eye position (preceded by a short pause so that
    % the tracker can finish the mode transition)
    % The paramerters for the 'StartRecording' call controls the
    % file_samples, file_events, link_samples, link_events availability
    Eyelink('Command', 'set_idle_mode');
    WaitSecs(0.05);
    %         Eyelink('StartRecording', 1, 1, 1, 1);
    Eyelink('StartRecording');
    eye_used = Eyelink('EyeAvailable'); % get eye that's tracked
    
    % record a few samples before we actually start displaying
    % otherwise you may lose a few msec of data
    WaitSecs(0.1);
    
    Screen('TextSize', window, 40);
    
    
    for trialI=1:numTrials
        
        c.dir = dir(mod(randData2(trialI),length(dir))+1);
        
        
        %         if mod(randData1(trialI),3) == 0, %1/3 control trial, no pulse
        %             c.pulse = 0;
        %             c.lPulse = 0;
        %             c.deltaCoh = 0;
        %         else
        c.pulse = round(pulse(mod(randData1(trialI),length(pulse))+1)* frameRate);
        c.lPulse = lPulse; %pulse time
        c.deltaCoh =  deltaCoh(mod(randData3(trialI),length(deltaCoh))+1);
        %         end
        
        
         fixed = false;
         
         while ~fixed
             [XR, YR] = coherentMOT6(c); %change coherent at c.lPulse start at c.pulse, coherent increase with (+/-)c.deltaCoh
             
             HideCursor;
             
             for i = 1:c.LM, % movie length (frames)
                 for j=1:c.numberdots, % 1:250
                     obj(:,i,j) = CenterRectOnPoint( [0 0 objectdiam objectdiam], centerWidth+XR(j,i), centerHeight+YR(j,i));
                 end  % CenterRectOnPoint(rect,x,y),offsets the rect to center it around an x and y position.
             end
             
             while ~fixed
                 %show fixation
                 Screen('FillRect',window,red,fixLocation);
                 vbl = Screen('Flip',window);
                 eyelink('message','fixation');
                 while ((getsecs - vbl) < 1), end; %wait for 1 sec
                 if Eyelink( 'NewFloatSampleAvailable') > 0
                     % get the sample in the form of an event structure
                     evt = Eyelink( 'NewestFloatSample');
                     if eye_used ~= -1 % do we know which eye to use yet?
                         % if we do, get current gaze position from sample
                         x = evt.gx(eye_used+1); % +1 as we're accessing MATLAB array
                         y = evt.gy(eye_used+1);
                         % do we have valid data and is the pupil visible?
                         if x~=el.MISSING_DATA && y~=el.MISSING_DATA && evt.pa(eye_used+1)>0
                             mx=x;
                             my=y;
                         end
                     end
                     
                     if mx<centerWidth-windowFix || mx>centerWidth+windowFix || my<centerHeight-windowFix || my>centerHeight+windowFix % if leave fixation
                         rspText = 'Fixation Break';
                         rspCol = red;
                         rspLocX = round(wRect(RectRight)/2)-150;
                         rspLocY = round(wRect(RectBottom)/2)-50;
                         Screen('DrawText',window, rspText,rspLocX,rspLocY,rspCol);
                         feedFB = Screen('Flip',window);
                         while (getsecs - feedFB)<1,  end;
                     else
                         fixed = true;
                     end
                 else
                     fixed = true;
                 end
             end
             
             %motion
             
             keyPressed = false;
             moved = false;
             eyelink('message','motion begin');
             for i = 1:c.LM,
                 
                 Screen('FillRect',window,red,fixLocation);
                 for j=1:c.numberdots,
                     %                 Screen('FillOval',window,col(j),obj(:,i,j));
                     Screen('FillOval',window,0.5*white,obj(:,i,j));
                 end
                 tMotionFrame(trialI,i) = Screen('Flip',window,vbl + ifi_duration);
                 if i == 1,
                     startSecs = tMotionFrame(trialI,i);
                 end
                 
                 % Check for fixation breaks
                 if Eyelink( 'NewFloatSampleAvailable') > 0 && ~moved
                     % get the sample in the form of an event structure
                     evt = Eyelink( 'NewestFloatSample');
                     if eye_used ~= -1 % do we know which eye to use yet?
                         % if we do, get current gaze position from sample
                         x = evt.gx(eye_used+1); % +1 as we're accessing MATLAB array
                         y = evt.gy(eye_used+1);
                         % do we have valid data and is the pupil visible?
                         if x~=el.MISSING_DATA && y~=el.MISSING_DATA && evt.pa(eye_used+1)>0
                             mx=x;
                             my=y;
                         end
                     end
                     
                     if mx<centerWidth-windowFix || mx>centerWidth+windowFix || my<centerHeight-windowFix || my>centerHeight+windowFix % if leave fixation
                         moved = true;
                         fixed = false;
                         rspText = 'Fixation Break';
                         rspCol = red;
                         rspLocX = round(wRect(RectRight)/2)-150;
                         rspLocY = round(wRect(RectBottom)/2)-50;
                         Screen('DrawText',window, rspText,rspLocX,rspLocY,rspCol);
                         feedFB = Screen('Flip',window);
                         while (getsecs - feedFB)<1,  end;
                     else
                         fixed = true;
                     end
                 elseif Eyelink( 'NewFloatSampleAvailable') <= 0 && ~moved
                     fixed = true;
                 end
                 
                 % Check for premature response
                 if ~keyPressed
                     %%check keyboard
                     [ keyIsDown, timeSecs, keyCode ] = KbCheck;
                     if keyIsDown
                         keyPressed = true;
                         rspText = 'Too Fast !';
                         rspLocX = round(wRect(RectRight)/2)-150;
                         rspLocY = round(wRect(RectBottom)/2)-50;
                         rspCol = red;
                         numAbort = numAbort+1;
                         %fprintf('"trial%i: %s" typed at time %.3f seconds\n',trialI, KbName(keyCode), timeSecs - startSecs);
                         if strcmp(KbName(keyCode),'LeftArrow')
                             result(trialI).keyName = 'l'; % lower case indicates aborted trials
                         else strcmp(KbName(keyCode),'RightArrow')
                             result(trialI).keyName = 'r'; % lower case indicates aborted trials
                         end
                         result(trialI).keyTime = timeSecs - startSecs;%second
                         %wait until all keys have been released.
                         while KbCheck;  end
                         %                     if KbName(keyCode) == 'p' || KbName(keyCode) == 'P',pause;
                         %                     end
                     end
                 end
                 
                 if (tMotionFrame(trialI,i) - tMotionFrame(trialI,1)) >= tMotion,
                     break
                 end
                 
             end
         end
         
         %Set Background color
         Screen('FillRect',window,black,wRect);
         Screen('Flip',window);
         eyelink('message','motion end');
         %check keyboard
         while ~keyPressed && (getsecs - tMotionFrame(trialI,i))<1
             
             [ keyIsDown, timeSecs, keyCode ] = KbCheck;
             if keyIsDown
                 keyPressed = true;
                 %                 fprintf('"trial%i: %s" typed at time %.3f seconds\n',trialI, KbName(keyCode), timeSecs - startSecs);
                 if strcmp(KbName(keyCode),'LeftArrow')
                     result(trialI).keyName = 'L'; % upper case indicates successful trials
                 else strcmp(KbName(keyCode),'RightArrow')
                     result(trialI).keyName = 'R'; % upper case indicates successful trials
                 end
                 result(trialI).keyTime = timeSecs - startSecs;%second
                 %wait until all keys have been released.
                 while KbCheck;   end
                 
                 if ((c.dir == 0)&& strcmp(result(trialI).keyName,'R')) || ((c.dir == 180) && strcmp(result(trialI).keyName,'L')),
                     rwd = rwd + 0.2;
                     rspText = sprintf('Your total reward = %.2fRMB',rwd);
                     rspLocX = round(wRect(RectRight)/2)-350;
                     rspLocY = round(wRect(RectBottom)/2)-50;
                     rspCol = green;
                     numCorrect = numCorrect + 1;
                 else
                    rspText = 'Incorrect !';
                    rspCol = red;
                    rspLocX = round(wRect(RectRight)/2)-150;
                    rspLocY = round(wRect(RectBottom)/2)-50;
                    numWrong = numWrong + 1;
                end
            end
        end
        
        
        %Respond screen
        
        if ~keyPressed
            rspText = 'Too Slow !';
            rspCol = red;
            rspLocX = round(wRect(RectRight)/2)-150;
            rspLocY = round(wRect(RectBottom)/2)-50;
            numAbort = numAbort + 1;
            result(trialI).keyName = 'x';
        end
        while keyPressed && (getsecs - tMotionFrame(trialI,i))<1,  end; %Make sure responds screen duration is 1 sec
        Screen('DrawText',window, rspText,rspLocX,rspLocY,rspCol);
        feedT0 = Screen('Flip',window);
        eyelink('message','response screen');
        result(trialI).param = c;
        while (getsecs - feedT0)<1,  end; %Make sure responds screen duration is 1 sec
        eyelink('message','trial end');
        
        % Create a rest point after trials 100 and 200
        if trialI == 100 || trialI == 200
            rspCol = white;
            Screen('TextSize', window, 40);
            Screen('DrawText',window, 'press any key to continue',round(wRect(RectRight)/2)-350,round(wRect(RectBottom)/2)-50,rspCol);
            Screen('Flip',window);
            eyelink('message','rest screen');
            keyPressed = false;
            while ~keyPressed % keep checking until key pressed
                keyIsDown = KbCheck;
                if keyIsDown
                    keyPressed = true;
                    while KbCheck;   end % wait for user to release key
                end
            end
        end
        
    end%trialI
    
    eyelink('StopRecording');
    
    durFrame = tMotionFrame(:,2:end)-tMotionFrame(:,1:end-1);
    durFrame(durFrame<0) = 0;
    durMot = sum(durFrame,2);
    SetMouse(centerWidth,centerHeight,window);
    ShowCursor('CrossHair');
    
    Screen('CloseAll')
    
catch ME
    Screen('CloseAll');
    rethrow(ME);
end
eyelink('command', 'set_idle_mode');
waitsecs(0.5);
eyelink('CloseFile');
pathname = uigetdir('C:\Documents and Settings\Gunnar Blohm\My Documents\Hong\Flora(data)', 'Please choose a folder to save file');
%% download data file
try
    fprintf('Receiving data file ''%s''\n',edfFile);
    status = eyelink('ReceiveFile',tempName ,pathname,1);
    if status > 0
        fprintf('ReceiveFile status %d\n ', status);
    end
    if 2 == exist(edfFile, 'file')
        fprintf('Data file ''%s'' can be found in '' %s\n',edfFile, pwd);
    end
catch
    fprintf('Problem receiving data file ''%s''\n',edfFile);
end

%close the eye tracker.
Eyelink('ShutDown');


% allDir = dir(mod(randData1,length(dir))+1);
% allDeltaCoh =  deltaCoh(mod(randData2,length(deltaCoh))+1);

%save result to file
trialType = 'runDotsPulseKey';
save([pathname '\' filename], 'frameRate','result','numTrials','durFrame','durMot','rwd','wRect','numCorrect','numWrong','numAbort','trialType','tMotion','pulse')
movefile([pathname,'\',tempName,'.edf'],[pathname,'\',edfFile,'.edf'],'f');



%
%     	% STEP 7.4
%         % Prepare and show the screen.
%      	Screen('FillRect', window, el.backgroundcolour);
%         imdata=imread(imgfile);
%         imageTexture=Screen('MakeTexture',window, imdata);
%         Screen('DrawTexture', window, imageTexture);
%      	Screen('DrawText', window, 'Press the SPACEBAR or BUTTON 5 to end the recording of the trial.', width/5, height/2, 0);
%       	Screen('Flip', window);
%        % write out a message to indicate the time of the picture onset
%        % this message can be used to create an interest period in EyeLink
%        % Data Viewer.
%         Eyelink('Message', 'SYNCTIME');
%
%         % Send an integration message so that an image can be loaded as
%         % overlay backgound when performing Data Viewer analysis.  This
%         % message can be placed anywhere within the scope of a trial (i.e.,
%         % after the 'TRIALID' message and before 'TRIAL_RESULT')
%         % See "Protocol for EyeLink Data to Viewer Integration -> Image
%         % Commands" section of the EyeLink Data Viewer User Manual.
%         Eyelink('Message', '!V IMGLOAD CENTER %s %d %d', imgfile, width/2, height/2);
%
%         stopkey=KbName('space');
%
%
%         % STEP 7.5
%         % Monitor the trial events;
%         while 1 % loop till error or space bar is pressed
%             % Check recording status, stop display if error
%             error=Eyelink('CheckRecording');
%             if(error~=0)
%                 break;
%             end
%
%           % ending by pressing button 5
%           buttonResult = Eyelink('ButtonStates');
%           if buttonResult
%             if(bitshift(buttonResult, -4)==1)  %fprintf('button 5 pressed\n');
%                 Eyelink('Message','Button 5 pressed');
%                 break;
%             end
%           end
%
%             % check for keyboard press
%             [keyIsDown,secs,keyCode] = KbCheck;
%             % if spacebar was pressed stop display
%             if keyCode(stopkey)
%                 Eyelink('Message', 'Key pressed');
%                 break;
%             end
%         end % main loop
%
%
%         % STEP 7.6
%         % Clear the display
%         Screen('FillRect', window, el.backgroundcolour);
%      	Screen('Flip', window);
%         Eyelink('Message', 'BLANK_SCREEN');
%         % adds 100 msec of data to catch final events
%         WaitSecs(0.1);
%         % stop the recording of eye-movements for the current trial
%         Eyelink('StopRecording');
%
%
%         % STEP 7.7
%         % Send out necessary integration messages for data analysis
%         % Send out interest area information for the trial
%         % See "Protocol for EyeLink Data to Viewer Integration-> Interest
%         % Area Commands" section of the EyeLink Data Viewer User Manual
%         % IMPORTANT! Don't send too many messages in a very short period of
%         % time or the EyeLink tracker may not be able to write them all
%         % to the EDF file.
%         % Consider adding a short delay every few messages.
%         % Please note that  floor(A) is used to round A to the nearest
%         % integers less than or equal to A
%
%         WaitSecs(0.001);
%         Eyelink('Message', '!V IAREA ELLIPSE %d %d %d %d %d %s', 1, floor(width/2)-50, floor(height/2)-50, floor(width/2)+50, floor(height/2)+50,'center');
%         Eyelink('Message', '!V IAREA RECTANGLE %d %d %d %d %d %s', 2, floor(width/4)-50, floor(height/2)-50, floor(width/4)+50, floor(height/2)+50,'left');
%         Eyelink('Message', '!V IAREA RECTANGLE %d %d %d %d %d %s', 3, floor(3*width/4)-50, floor(height/2)-50, floor(3*width/4)+50, floor(height/2)+50,'right');
%         Eyelink('Message', '!V IAREA RECTANGLE %d %d %d %d %d %s', 4, floor(width/2)-50, floor(height/4)-50, floor(width/2)+50, floor(height/4)+50,'up');
%         Eyelink('Message', '!V IAREA RECTANGLE %d %d %d %d %d %s', 5, floor(width/2)-50, floor(3*height/4)-50, floor(width/2)+50, floor(3*height/4)+50,'down');
%
%
%         % Send messages to report trial condition information
%         % Each message may be a pair of trial condition variable and its
%         % corresponding value follwing the '!V TRIAL_VAR' token message
%         % See "Protocol for EyeLink Data to Viewer Integration-> Trial
%         % Message Commands" section of the EyeLink Data Viewer User Manual
%         WaitSecs(0.001);
%         Eyelink('Message', '!V TRIAL_VAR index %d', i)
%         Eyelink('Message', '!V TRIAL_VAR imgfile %s', imgfile)
%
%         % STEP 7.8
%         % Sending a 'TRIAL_RESULT' message to mark the end of a trial in
%         % Data Viewer. This is different than the end of recording message
%         % END that is logged when the trial recording ends. The viewer will
%         % not parse any messages, events, or samples that exist in the data
%         % file after this message.
%         Eyelink('Message', 'TRIAL_RESULT 0')
%     end
%
%     % STEP 8
%     % End of Experiment; close the file first
%     % close graphics window, close data file and shut down tracker
%
%     Eyelink('Command', 'set_idle_mode');
%     WaitSecs(0.5);
%     Eyelink('CloseFile');
%
%     % download data file
%     try
%         fprintf('Receiving data file ''%s''\n', edfFile );
%         status=Eyelink('ReceiveFile');
%         if status > 0
%             fprintf('ReceiveFile status %d\n', status);
%         end
%         if 2==exist(edfFile, 'file')
%             fprintf('Data file ''%s'' can be found in ''%s''\n', edfFile, pwd );
%         end
%     catch
%         fprintf('Problem receiving data file ''%s''\n', edfFile );
%     end
%
%     % STEP 9
%     % run cleanup function (close the eye tracker and window).
%     cleanup;
%     catch
%      %this "catch" section executes in case of an error in the "try" section
%      %above.  Importantly, it closes the onscreen window if its open.
%      cleanup;
%     end %try..catch.
%
%
%
% % Cleanup routine:
% function cleanup
% % Shutdown Eyelink:
% Eyelink('Shutdown');
%
% % Close window:
% %sca;
% Screen('CloseAll');
% commandwindow;
%
% % Restore keyboard output to Matlab:
% % % ListenChar(0);
%
