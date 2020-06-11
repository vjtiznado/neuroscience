%% ripple detection
clc
display('---------------------------------------');
display(' DETECTING RIPPLES, 5 SD THRESHOLD ')
display('---------------------------------------');

display('creating detection parameters...')
cfg.freq = [100 250];
cfg.time = 50;
cfg.thr = [1 5]; % 5 desviaciones estandar como umbral
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
    
    for n_sessions = 1:size(sessions,1)
        cd(sessions(n_sessions).name)
        display('------------------')
        display(sessions(n_sessions).name)
        display('Loading LFP...')
        load('LFP.mat')
        LAN.data{1,1} = data(:,end-660000:end-425000);
        LAN.srate = srate;
        LAN = lan_check(LAN);
        chan_vec = 1:size(data,1);
        cfg.chan = chan_vec;
        display('detecting ripples...')
        RT = lan_detect_freq_event2(LAN,cfg);
        rat_ripples(n_rat).ripples_data{n_sessions,1} = RT;
        display('detecting the number of ripples during the recording of each channel...')
            for n_ch = 1:size(chan_vec,2)
                display(['channel ' num2str(channels(n_ch,1))])
                count = count + 1;
                rat_ripples(n_rat).sessions{count,1} = sessions(n_sessions).name;
                rat_ripples(n_rat).sessions{count,2} = ['channel ' num2str(channels(n_ch,1))];
%                 rat_ripples(n_rat).sessions{count,3} = ['tetrode ' num2str(tetrodes(1,n_ch))];
                rat_ripples(n_rat).sessions{count,3} = ['tetrode ' num2str(tetrodes(1,ceil(n_ch/4)))];
                
                if ~isempty(RT.latency)
                    ch_i = RT.est== n_ch;
                    ch_ripp = size(RT.latency(ch_i),2);
                    rat_ripples(n_rat).sessions{count,4} = num2str(ch_ripp);
                else
                    rat_ripples(n_rat).sessions{count,4} = nan;
                end
            end 
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
cfg.thr = [1 3]; % 3 desviaciones estandar como umbral
cfg.method = 'logothetis';
cfg.norbin = 0;

base_dir = 'C:\Users\pflab\Dropbox\VT\LFP_data';
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
    
    for n_sessions = 1:size(sessions,1)
        cd(sessions(n_sessions).name)
        display('----------------------')
        display(sessions(n_sessions).name)
        display('Loading LFP...')
        load('LFP.mat')
        LAN.data{1,1} = data;
        LAN.srate = srate;
        LAN = lan_check(LAN);
        chan_vec = 1:size(data,1);
        cfg.chan = chan_vec;
        display('detecting ripples...')
        RT = lan_detect_freq_event2(LAN,cfg);beep
        rat_ripples(n_rat).ripples_data{n_sessions,1} = RT;
        display('detecting the number of ripples during the recording of each channel...')
            for n_ch = 1:size(chan_vec,2)
                display(['channel ' num2str(channels(n_ch,1))])
                count = count + 1;
                rat_ripples(n_rat).sessions{count,1} = sessions(n_sessions).name;
                rat_ripples(n_rat).sessions{count,2} = ['channel ' num2str(channels(n_ch,1))];
%                 rat_ripples(n_rat).sessions{count,3} = ['tetrode ' num2str(tetrodes(1,n_ch))];
                rat_ripples(n_rat).sessions{count,3} = ['tetrode ' num2str(tetrodes(1,ceil(n_ch/4)))];   
                
                if ~isempty(RT.latency)
                    ch_i = RT.est == n_ch;
                    ch_ripp = size(RT.latency(ch_i),2);
                    rat_ripples(n_rat).sessions{count,4} = num2str(ch_ripp);
                else
                    rat_ripples(n_rat).sessions{count,4} = nan;
                end
            end 
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
disp('    READY    ')
disp('--------------')

msgbox_icon = imread('bien.jpg');
msgbox(' Ripples were succesfully detected ','Enhorabuena','custom',msgbox_icon)

