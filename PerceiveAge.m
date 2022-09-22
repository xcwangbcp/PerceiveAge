function PerceiveAge
% AlphaImageDemo

clear all;
commandwindow;
dummymode=1;

 stopkey=KbName('space');
% check for keyboard press
        [keyIsDown,secs,keyCode] = KbCheck;
        % if spacebar was pressed stop display
        if keyCode(stopkey)
            break;
        end

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
  % STEP 3
    % Provide Eyelink with details about the graphics environment
    % and perform some initializations. The information is returned
    % in a structure that also contains useful defaults
    % and control codes (e.g. tracker state bit and Eyelink key values).
    el=EyelinkInitDefaults(window);
    % screen params    
    centerWidth = wRect(RectRight)/2;
    centerHeight = wRect(RectBottom)/2;
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
    tempName = 'TEMP';
    i = Eyelink('Openfile', tempName);
    if i~=0
        fprintf('Cannot create EDF file ''%s'' ', edffilename);
        cleanup;
        return;
    end
    
    
    
    Eyelink('command', 'add_file_preamble_text ''Recorded by PerceiveAge.m''');
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
%     Screen('HideCursorHelper', window);
%     Screen('HideCursor', window);
    HideCursor;
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
    
    
    
    
    % Import image and and convert it, stored in
    % MATLAB matrix, into a Psychtoolbox OpenGL texture using 'MakeTexture';
%   myimgfile = [ PsychtoolboxRoot 'PsyhengchDemos' filesep 'AlphaImageDemo' filesep '1400001.jpg'];
%     currentFolder=pwd;
    file_path = [pwd '\pics\'];% 图像文件夹路径
    img_path_list = dir(strcat(file_path,'*.jpg'));%获取该文件夹中所有jpg格式的图像
    img_num = length(img_path_list);%获取图像总数量
     for picSeq=1:img_num 
         
    myimgfile = [ file_path  filesep img_path_list(picSeq,1).name];
    
    fprintf('Using image ''%s''\n', myimgfile);
    imdata=imread(myimgfile, 'jpg');
    
    % Crop image if it is larger then screen size. There's no image scaling
    % in maketexture
    [iy, ix, id]=size(imdata);
    [wW, wH]=WindowSize(window);
    if ix>wW | iy>wH
        fprintf('Image size exceeds screen size\n');
        fprintf('Image will be cropped\n');
    end
    if ix>wW
        cl=round((ix-wW)/2);
        cr=(ix-wW)-cl;
    else
        cl=0;
        cr=0;
    end
    if iy>wH
        ct=round((iy-wH)/2);
        cb=(iy-wH)-ct;
    else
        ct=0;
        cb=0;
    end

    % Set up texture and rects
    imagetex=Screen('MakeTexture', window, imdata(1+ct:iy-cb, 1+cl:ix-cr,:));
    tRect=Screen('Rect', imagetex);
    [ctRect, dx, dy]=CenterRect(tRect, wRect);


%     Blank sceen
    Screen('FillRect',window, uint8(gray));
    Screen('Flip', window);

    % initialize mouse position at center
% %     [a,b]=WindowCenter(w);
% %     SetMouse(a,b,screenNumber); 
% %     HideCursor;
% %     buttons=0;

    % Bump priority for speed        
% % 	priorityLevel=MaxPriority(w);
% %     Priority(priorityLevel);
    
    % Pre-load textures
    Screen('DrawTexture', window, imagetex);
%     Screen('DrawTexture', w, masktex);
%     Screen('FillRect',w, gray);
    Screen('Flip', window);
    
    % Main mouse tracking loop
%     mxold=0;
%     myold=0;
%     while (1)
%         % We wait at least 10 ms each loop-iteration so that we
%         % don't overload the system in realtime-priority:
     Eyelink('message', 'pic', 'Pic %d Begin',picSeq);
%      WaitSecs(1);
    
     WaitSecs(50);
     Eyelink('message', 'pic', 'Pic %d End',picSeq);
     Screen('FillRect',window, uint8(gray));
     Screen('Flip', window);
     WaitSecs(1)
 end  
    % The same command which closes onscreen and offscreen windows also
    % closes textures.
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

Eyelink('command', 'set_idle_mode');
WaitSecs(0.5);
Eyelink('CloseFile');
pathname = uigetdir('C:\Documents and Settings\Gunnar Blohm\My Documents\Hong\Flora(data)', 'Please choose a folder to save file');
%% download data file
try
    fprintf('Receiving data file ''%s''\n',filename);
    status = Eyelink('ReceiveFile',tempName ,pathname,1);
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
Eyelink('ShutDown');
save([pathname '\' filename])
movefile([pathname,'\',tempName,'.edf'],[pathname,'\',filename,'.edf'],'f');
