%% RIPPLE DETECTION
% This code detects ripples and save a file with all its information

%% ripple detection
clear
clc
display('---------------------------------------');
display(' DETECTING RIPPLES, 5 SD THRESHOLD ')
display('---------------------------------------');

display('creating detection parameters...')
cfg.freq = [100 250];
cfg.time = 50;
cfg.thr = [1 5]; % detection threshold: 5 std
cfg.method = 'logothetis';
cfg.norbin = 0;

base_dir = 'C:\Users\neuro\Dropbox\VT\LFP_data\';
exp_dir = dir([base_dir 'SB*']);
rat_ripples = table(cell(size(exp_dir,1),1),cell(size(exp_dir,1),1),cell(size(exp_dir,1),1),'variablenames',{'name' 'sessions' 'data'});
for n_rat = 1:size(exp_dir,1)
    display('---------------------');
    display(['   Rat ' exp_dir(n_rat).name])
    display('---------------------');
    rat_ripples.name(n_rat) = {exp_dir(n_rat).name};
    sessions = dir([base_dir exp_dir(n_rat).name '\session*']);
    count = 0;
    
    for n_ses = 1:size(sessions,1)
        display('------------------')
        display(sessions(n_ses).name)
        display('Loading LFP...')
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
        elseif n_rat == 4 && n_ses == 1;
            data = data(:,1:end-50000);
        elseif n_rat == 4 && n_ses == 3;
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
        elseif n_rat == 6 && n_ses == 8;
            data = data(:,250000:1400000);
        elseif n_rat == 6 && n_ses == 3;
            data = data(:,end/2-10000:end-100000);
        end
        LAN.data{1,1} = data;
        LAN.srate = srate;
        LAN = lan_check(LAN);
        chan_vec = 1:size(data,1);
        cfg.chan = chan_vec;
        display('detecting ripples...')
        RT = lan_detect_freq_event2(LAN,cfg);
        display('detecting the number of ripples during the recording of each channel...')
        new_est = nan(2,size(RT.est,2));
            for n_ch = 1:size(chan_vec,2)
                display(['channel ' num2str(channels(n_ch,1))])
                count = count + 1;
                rat_ripples.sessions{n_rat,1}{count,1} = sessions(n_ses).name;
                rat_ripples.sessions{n_rat,1}{count,2} = ['channel ' num2str(channels(n_ch,1))];
%                 rat_ripples(n_rat).sessions{count,3} = ['tetrode ' num2str(tetrodes(1,n_ch))];
                rat_ripples(n_rat).sessions{count,3} = ['tetrode ' num2str(tetrodes(1,ceil(n_ch/4)))];
                if ~isempty(RT.latency)
                    new_est(1,RT.est(1,:) == n_ch) = channels(n_ch,1);
                    new_est(2,RT.est(1,:) == n_ch) = tetrodes(1,ceil(n_ch/4));
%                     new_est(1,length(find(~isnan(new_est(1,:))))+1:length(find(~isnan(new_est(1,:))))+ch_ripp) = channels(n_ch,1);
%                     new_est(2,length(find(~isnan(new_est(2,:))))+1:length(find(~isnan(new_est(2,:))))+ch_ripp) = tetrodes(1,ceil(n_ch/4));
                    rat_ripples(n_rat).sessions{count,4} = num2str(sum(RT.est(1,:) == n_ch));
                else
                    rat_ripples(n_rat).sessions{count,4} = nan;
                end
            end
            RT.est([2,3],:) = new_est;            
            rat_ripples(n_rat).ripples_data{n_ses,1} = RT;
            clearvars LAN data srate channels tetrodes RT chan_vec
            cd ..
    end    
    cd ..
end
display('Analysis ready.')
disp('Saving file...')
save('ripples_data_raw_SD_5.mat','rat_ripples','-v7.3')
disp('File saved')
clear all

%%
display('---------------------------------------');
display(' DETECTING RIPPLES, 3 SD THRESHOLD ')
display('---------------------------------------');

display('creating detection parameters...')
cfg.freq = [100 250];
cfg.time = 50;
cfg.thr = [1 3]; % detection threshold: 3 std
cfg.method = 'logothetis';
cfg.norbin = 0;

base_dir = 'C:\Users\neuro\Dropbox\VT\LFP_data';
cd(base_dir)
exp_dir = dir(fullfile(base_dir,'SB*'));
rat_ripples(1:size(exp_dir,1)) = struct('name',[],'sessions',[],'ripples_data',[]);
for n_rat = 1:size(exp_dir,1)
    display('---------------------');
    display(['   Rat ' exp_dir(n_rat).name])
    display('---------------------');
    rat_ripples(n_rat).name = exp_dir(n_rat).name;
    cd(exp_dir(n_rat).name)
    sessions = dir('session*');
    count = 0;
    
    for n_ses = 1:size(sessions,1)
        cd(sessions(n_ses).name)
        display('----------------------')
        display(sessions(n_ses).name)
        display('Loading LFP...')
        load('LFP.mat')
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
        elseif n_rat == 4 && n_ses == 1;
            data = data(:,1:end-50000);
        elseif n_rat == 4 && n_ses == 3;
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
        elseif n_rat == 6 && n_ses == 8;
            data = data(:,250000:1400000);
        elseif n_rat == 6 && n_ses == 3;
            data = data(:,end/2-10000:end-100000);
        end
        LAN.data{1,1} = data;
        LAN.srate = srate;
        LAN = lan_check(LAN);
        chan_vec = 1:size(data,1);
        cfg.chan = chan_vec;
        display('detecting ripples...')
        RT = lan_detect_freq_event2(LAN,cfg);
        display('detecting the number of ripples during the recording of each channel...')
        new_est = nan(2,size(RT.est,2));        
            for n_ch = 1:size(chan_vec,2)
                display(['channel ' num2str(channels(n_ch,1))])
                count = count + 1;
                rat_ripples(n_rat).sessions{count,1} = sessions(n_ses).name;
                rat_ripples(n_rat).sessions{count,2} = ['channel ' num2str(channels(n_ch,1))];
%                 rat_ripples(n_rat).sessions{count,3} = ['tetrode ' num2str(tetrodes(1,n_ch))];
                rat_ripples(n_rat).sessions{count,3} = ['tetrode ' num2str(tetrodes(1,ceil(n_ch/4)))];   
                if ~isempty(RT.latency)
                    new_est(1,RT.est(1,:) == n_ch) = channels(n_ch,1);
                    new_est(2,RT.est(1,:) == n_ch) = tetrodes(1,ceil(n_ch/4));
%                     new_est(1,length(find(~isnan(new_est(1,:))))+1:length(find(~isnan(new_est(1,:))))+ch_ripp) = channels(n_ch,1);
%                     new_est(2,length(find(~isnan(new_est(2,:))))+1:length(find(~isnan(new_est(2,:))))+ch_ripp) = tetrodes(1,ceil(n_ch/4));
                    rat_ripples(n_rat).sessions{count,4} = num2str(sum(RT.est(1,:) == n_ch));
                else
                    rat_ripples(n_rat).sessions{count,4} = nan;
                end
            end
            RT.est([2,3],:) = new_est;            
            rat_ripples(n_rat).ripples_data{n_ses,1} = RT;
            clearvars LAN data srate channels tetrodes RT chan_vec
            cd ..
    end  
    cd ..
end
display('Analysis ready.')
disp('Saving file...')
save('ripples_data_raw_SD_3.mat','rat_ripples','-v7.3')
disp('File saved')
clear all

disp('--------------')
disp('     READY    ')
disp('--------------')

msgbox_icon = imread('bien.jpg');
msgbox(' Ripples were succesfully detected ','Enhorabuena','custom',msgbox_icon)

