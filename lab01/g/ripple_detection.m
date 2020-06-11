%% RIPPLE DETECTION
% This code detects ripples for all the sessions of each rat and save a file with all its information.
% The code uses the LAN function 'lan_detect_freq_event2.m' to detect the ripple events, and needs a LAN file to work. Since the downsampled LFPs are in 'LFP.mat' files,
% before the detection is created a LAN variable in the workspace using the LAN function 'lan_check.m'.'
% 'lan_detect_freq_event2.m' creates the struct 'RT' with 3 important variables:
% RT.latency: contains the timestamp of the ripple onset of all the channels
% RT.est: specifies to which channel of the data corresponds each ripple of RT.latency. By default, the detection function set the first channel of the data as channel 1. In this code is included in 'RT.est' the vector of the original recording channels and it tetrode.'
% RT.rt: specifies the time elapsed between the ripple onset and it max voltage
% Since RT contains the detections of all the channels of the session, within 'rat_ripples' exists one RT struct per session'

%% ripple detection
% before run this section, don't forget to set the detection parameters within the 'cfg' struct
clear
clc
STD = [3,5]; % set the number of standard deviations that will serve as threshold to detect the ripples

base_dir = 'C:\Users\neuro\Dropbox\VT\LFP_data\';
ripp_dir = 'C:\Users\neuro\Dropbox\SB\RESULTADOS\RIPPLES\';
exp_dir = dir([base_dir 'SB*']);
for sd = STD
    tic
    disp('---------------------------------------');
    disp([' DETECTING RIPPLES, ' num2str(sd) ' SD THRESHOLD '])
    disp('---------------------------------------');
    
    disp('creating detection parameters...')
    cfg.freq = [100 250]; % set the ripples' frequency band
    cfg.time = 50; % min ripple duration necessary to be detected
    cfg.thr = [1 sd]; % detection threshold: 5 std
    cfg.method = 'logothetis';
    cfg.norbin = 0;
    
    rat_ripples = table(cell(size(exp_dir,1),1),cell(size(exp_dir,1),1),cell(size(exp_dir,1),1),'variablenames',{'name','sessions_info','ripples_data'});
    for n_rat = 1:size(exp_dir,1)
        disp('---------------------')
        disp(['   Rat ' exp_dir(n_rat).name])
        disp('---------------------')
        rat_ripples.name(n_rat) = {exp_dir(n_rat).name};
        sessions = dir([base_dir exp_dir(n_rat).name '\session*']);
        count = 0;
        
        for n_ses = 1:size(sessions,1)
            disp('------------------')
            disp(sessions(n_ses).name)
            disp('Loading LFP...')
            load([base_dir exp_dir(n_rat).name '\' sessions(n_ses).name '\LFP.mat'])
            if n_rat == 2 && n_ses == 1
                data = data(:,300000:2850000);
            elseif n_rat == 2 && n_ses == 2
                data = data(:,1:2100000);
            elseif n_rat == 2 && n_ses == 3
                data = data(:,1:2390000);
            elseif n_rat == 2 && n_ses == 4
                data = data(:,1000000:2190000);
            elseif n_rat == 2 && n_ses == 6
                data = data(:,1:1850000);
            elseif n_rat == 4 && n_ses == 1
                data = data(:,1:end-50000);
            elseif n_rat == 4 && n_ses == 3
                data = data(:,1:end/2-100000);
            elseif n_rat == 4 && n_ses == 4
                data = data(:,1430000:end);
            elseif n_rat == 4 && n_ses == 5
                data = data(:,1:end/2+300000);
            elseif n_rat == 4 && n_ses == 6
                data = data(:,1:end-900000);
            elseif n_rat == 4 && n_ses == 7
                data = data(:,end/2+90000:end-30000);
            elseif n_rat == 4 && n_ses == 8
                data = data(:,1:end-400000);
            elseif n_rat == 4 && n_ses == 9
                data = data(:,1000000:2010000);
            elseif n_rat == 6 && n_ses == 8
                data = data(:,250000:1400000);
            elseif n_rat == 6 && n_ses == 3
                data = data(:,end/2-10000:end-100000);
            end
            LAN.data{1,1} = data;
            LAN.srate = srate;
            LAN = lan_check(LAN);
            chan_vec = 1:size(data,1);
            cfg.chan = chan_vec; % channels to be detected
            disp('detecting ripples...')
            RT = lan_detect_freq_event2(LAN,cfg); % detection function
            disp('detecting the number of ripples during the recording of each channel...')
            new_est = nan(2,size(RT.est,2));
            for n_ch = 1:size(chan_vec,2)
                disp(['channel ' num2str(channels(n_ch,1))])
                count = count + 1;
                rat_ripples.sessions_info{n_rat,1}{count,1} = sessions(n_ses).name;
                rat_ripples.sessions_info{n_rat,1}{count,2} = num2str(channels(n_ch,1));
%                 rat_ripples(n_rat).sessions_info{count,3} = num2str(tetrodes(1,n_ch));
                rat_ripples.sessions_info{n_rat,1}{count,3} = num2str(tetrodes(1,ceil(n_ch/4)));
                if ~isempty(RT.latency)
                    new_est(1,RT.est(1,:) == n_ch) = channels(n_ch,1);
                    new_est(2,RT.est(1,:) == n_ch) = tetrodes(1,ceil(n_ch/4));
%                     new_est(1,length(find(~isnan(new_est(1,:))))+1:length(find(~isnan(new_est(1,:))))+ch_ripp) = channels(n_ch,1);
%                     new_est(2,length(find(~isnan(new_est(2,:))))+1:length(find(~isnan(new_est(2,:))))+ch_ripp) = tetrodes(1,ceil(n_ch/4));
                    rat_ripples.sessions_info{n_rat,1}{count,4} = num2str(sum(RT.est(1,:) == n_ch));
                else
                    rat_ripples.sessions_info{n_rat,1}{count,4} = nan;
                end
            end
            RT.est([2,3],:) = new_est;
            RT.est_rows_meaning{1,1} = 'default_channel';
            RT.est_rows_meaning{2,1} = 'original_recording_channel';
            RT.est_rows_meaning{3,1} = 'tetrode';
            rat_ripples.ripples_data{n_rat,1}{n_ses,1} = RT;
            rat_ripples.ripples_data{n_rat,1}{n_ses,2} = sessions(n_ses).name;
            clearvars LAN data srate channels tetrodes RT chan_vec
        end
        rat_ripples.sessions_info{n_rat,1} = cell2table(rat_ripples.sessions_info{n_rat,1},'variablenames',{'session' 'channel' 'tetrode' 'n_detections'});
    end
    disp('Saving file...')
    save([ripp_dir 'ripples_data_raw_SD_' num2str(sd) '_ina.mat'],'rat_ripples','-v7.3')
    disp('File saved')
    clearvars -except STD ripp_dir base_dir exp_dir
    toc
end

disp('--------------')
disp('     READY    ')
disp('--------------')

msgbox_icon = imread('bien.jpg');
msgbox(' Ripples were succesfully detected ','Enhorabuena','custom',msgbox_icon)
