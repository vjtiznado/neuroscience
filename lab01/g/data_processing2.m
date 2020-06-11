%% automatic code to create LAN, .ttr files and run the RunClustBatch function

clear; clc;
tic
basal_path = 'E:\Gonzalo\Exp GV15 - GV16 Septiembre 2018\'; % set the path where the folders of your different rats are located

TT =[26 28 30 32;  % TT1                  % FALTA AGREGAR LA EXCEPCION DEL REGISTRO EN QUE EL HEADSTAGE FUE CONECTADO AL REVES
     18 20 22 24;  % TT2
     10 12 14 16;  % TT3
     2 4 6 8;      % TT4
     25 27 29 31;  % TT5
     17 19 21 23;  % TT6
     9 11 13 15;   % TT7
     1 3 5 7];     % TT8

r_dir = dir([basal_path 'GV*']); % get the folder's name of all your rats

for r = 1:size(r_dir,1)
    disp('-------------------')
    disp(['  animal ' r_dir(r).name])
    disp('-------------------')
    s_dir = dir([basal_path r_dir(r).name '\rec*']); % get the folder's name of all the recording days of this rat
    for s = 1:size(s_dir,1)
        disp(['session ' s_dir(s).name(13:end)])
        wday_recs = dir([basal_path r_dir(r).name '\' s_dir(s).name '\rec_*M']);
        for ampm = 1:size(wday_recs,1)
            dat_dir = dir([basal_path r_dir(r).name '\' s_dir(s).name '\' wday_recs(ampm).name '\*.dat']); % get the .dat file names of this recording day
            for d = 1:size(dat_dir,1)
                disp(['recording ' dat_dir(d).name])
                lan_dir = dir([basal_path r_dir(r).name '\' s_dir(s).name '\' wday_recs(ampm).name '\LAN_' dat_dir(d).name(1:end-4) '.mat']); % get the LAN file names of this recording day
                if size(lan_dir,1) == 0 % if there is no LAN file created for this .dat file
                    disp('importing data and creating LAN struct...')
                    cd([basal_path r_dir(r).name '\' s_dir(s).name '\' wday_recs(ampm).name])
                    LAN = lan_from_dat_aut2(dat_dir(d).name); % create the LAN struct
                    LAN.srate = 20000;
                    LAN = lan_check(LAN);
                    disp('saving LAN file...')
                    save(['LAN_' dat_dir(d).name(1:end-4) '.mat'],'LAN','-v7.3') % save the LAN as a .mat file
                    disp('LAN file saved')
                    clear LAN
                    
                    disp(' ')
                    disp('creating .ttr files...')
                    % the following 'if' statement is to change the TT matrix when the headstage was not connected properly
                    if strcmp(r_dir(r).name,'GV01') && strcmp(s_dir(s).name(end-4:end),'02_03') && strcmp(dat_dir(d).name, 'GV01_02_03c.dat') ...
                            || strcmp(r_dir(r).name,'GV01') && strcmp(s_dir(s).name(end-4:end),'02_04')
                        TT = [1 3 5 7;      %TT1
                            9 11 13 15;   %TT2
                            17 19 21 23;  %TT3
                            25 27 29 31;  %TT4
                            2 4 6 8;      %TT5
                            10 12 14 16;  %TT6
                            18 20 22 24;  %TT7
                            26 28 30 32]; %TT8
                    end
                    
                    try
                        for tt = 1:size(TT,1) % for each tetrode...
                            display(' ')
                            display(['TT' num2str(tt)])
                            display('filtering between 300-5000 Hz and detecting occurrences (putative spikes)...')
                            [T,WV,n] = makeTTDAT2(TT(tt,:),dat_dir(d).name); % detect the occurrences of each putative spike
                            disp(['saving ttr' num2str(tt) ' file...']);
                            save([dat_dir(d).name(1:end-4) '_tt' num2str(tt) '.ttr'],'T','WV','n'); % save the .ttr file of this tetrode
                            disp(['TT' num2str(tt) ' file ready']);
                            clear T WV n
                        end
                    catch
                        disp('WARNING: this recording is too large to create the .ttr files normally')
                        disp('creating .ttr files by splitting the LAN file...')
                        cd([basal_path r_dir(r).name '\' s_dir(s).name '\' wday_recs(ampm).name])
                        ac_ttr = dir([dat_dir(d).name(1:end-4) '_tt*.ttr']);
                        ac_ttr = {ac_ttr.name};
                        cellfun(@(x) delete(x), ac_ttr)
                        for tt = 1:size(TT,1) % for each tetrode...
                            display(' ')
                            display(['TT' num2str(tt)])
                            display('filtering between 300-5000 Hz and detecting occurrences (putative spikes)...')
                            [T1,WV1,n1] = makeTTDAT2_split(TT(tt,:),dat_dir(d).name,1); % detect the occurrences of each putative spike for the first half of the recording
                            [T2,WV2,n2] = makeTTDAT2_split(TT(tt,:),dat_dir(d).name,2);
                            n = n1 + n2;
                            WV = cat(1,WV1,WV2);
                            T = [T1 T2];
                            clear T1 T2 WV1 WV2 n1 n2
                            disp(['saving ttr' num2str(tt) ' file...']);
                            save([dat_dir(d).name(1:end-4) '_tt' num2str(tt) '.ttr'],'T','WV','n'); % save the .ttr file of this tetrode
                            disp(['TT' num2str(tt) ' file ready']);
                            clear T WV n
                        end
                        
                    end
                    
                else
                    disp('LAN structs and .ttr files were already created and saved for this recording')
                    disp(' ')
                end
            end
            fd_dir = dir([basal_path r_dir(r).name '\' s_dir(s).name '\' wday_recs(ampm).name '\FD*']);
            if size(fd_dir,1) == 0 && size(dat_dir,1) == 1
                cd([basal_path r_dir(r).name '\' s_dir(s).name '\' wday_recs(ampm).name])
                RunClustBatch('Batch_Q.txt') % clustering of all the occurrences (putative neurons)
            end
        end
    end
end
cd(basal_path)
disp(' ')
disp('*****   ready   *****')
disp(' ')
msgbox_icon = imread('bien.jpg');
msgbox('YOUR DATA IS READY','Enhorabuena','custom',msgbox_icon)
toc

%% Concatenation of the different '.ttr' files of each tetrode before clustering. 
% This concatenation occurrs only in the folders having more than one '.ttr' file per tetrode
% After concatenating the .ttr files, the code runs the RunClustBatch function
% **** maybe is better to sort the .ttr files before its concatenation in the same order as they were in the recording, 
% because the 'dir' function may not take the same order since it is based on the alphabetic order of the files. vt: 02102018
clear; clc;
tic
basal_path = 'E:\Gonzalo\Exp GV15 - GV16 Septiembre 2018\'; % set the path where the folders of your different rats are located
n_tetrodes = 8; % set the number of tetrodes you have

r_dir = dir([basal_path 'GV*']); % get the folder's name of all your rats
for r = 1:size(r_dir,1)
    s_dir = dir([basal_path r_dir(r).name '\rec*']); % get the folder's name of all the recording days of this rat
    for s = 1:size(s_dir,1)
        disp(s_dir(s).name)
        wday_recs = dir([basal_path r_dir(r).name '\' s_dir(s).name '\rec_*M']);
        for ampm = 1:size(wday_recs,1)
            disp(wday_recs(ampm).name)
            cd([basal_path r_dir(r).name '\' s_dir(s).name '\' wday_recs(ampm).name])
            ttrs_dir_test = dir('*tt1.ttr'); % detect all the '.ttr' files of one tetrode. If there is more than one .ttr file for one tetrode, it means that the code has to concatenate them
            ttrmerg_dir = dir('*merged.ttr'); % if the '_merged.ttr' files already exist, the code will skip this folder
            if size(ttrs_dir_test,1) > 1 && size(ttrmerg_dir,1) == 0
                % concatenation of the '.ttr' file of each tetrode
                for n_tt = 1:n_tetrodes
                    disp(['concatenating TT' num2str(n_tt) ' .ttr files...'])
                    ttrs_dir = dir(['*' num2str(n_tt) '.ttr']); % detect all the .ttr files of the tetrode 'n_tt'
                    ttr_conc_order = {ttrs_dir.name}';
                    cd([basal_path r_dir(r).name '\' s_dir(s).name '\' wday_recs(ampm).name])
%                     t = arrayfun(@(x) importdata(x.name),ttrs_dir); ---> using importdata showed an error in a particular recording. it was replaced by 'load' function
                    t = arrayfun(@(x) load(x.name,'T','WV','n','-mat'), ttrs_dir); % import the data of all the .ttr files of this tetrode (n_tt)
                    T = nan(1,sum(cell2mat({t.n}))); % memory preallocation
                    WV = nan(sum(cell2mat({t.n})),4,32); % memory preallocation
                    n = sum(cell2mat({t.n}));
                    
                    T(1,1:t(1).n) = t(1).T;
                    WV(1:t(1).n,:,:) = t(1).WV;
                    for ttr = 1:size(t,1)
                        t(ttr).T = t(ttr).T + 360000000*(ttr-1);
                        
                        T(1,sum(cell2mat({t(1:ttr-1).n}))+1:sum(cell2mat({t(1:ttr).n}))) = t(ttr).T;
                        WV(sum(cell2mat({t(1:ttr-1).n}))+1:sum(cell2mat({t(1:ttr).n})),:,:) = t(ttr).WV;
                    end
                    disp(['saving concatenated TT' num2str(n_tt) ' .ttr file...']);
                    save([ttrs_dir(1).name(1:10) '_tt' num2str(n_tt) '_merged.ttr'],'T','WV','n','ttr_conc_order'); % save the .ttr file of this tetrode
                    disp(['TT' num2str(n_tt) ' file ready']);
                    disp(' ')
                    clear T WV n t
                end
            elseif size(ttrs_dir_test,1) > 1 && size(ttrmerg_dir,1) > 0
                disp('this recording session has its .ttr files already concatenated')
                disp(' ')
            elseif size(ttrs_dir_test,1) == 1
                disp('this recording session does not need to concatenate .ttr files')
                disp(' ')
            end
            fd_dir = dir([basal_path r_dir(r).name '\' s_dir(s).name '\' wday_recs(ampm).name '\FD*']);
            if size(fd_dir,1) == 0
                cd([basal_path r_dir(r).name '\' s_dir(s).name '\' wday_recs(ampm).name])
                RunClustBatch('Batch_Q.txt') % clustering of all the occurrences (putative neurons)
            end
        end
    end
end
disp(' ***   ready   *** ')
msgbox_icon = imread('bien.jpg');
msgbox('YOUR DATA IS READY','Enhorabuena','custom',msgbox_icon)
toc
%% data downsampling, for LFP plotting
clear;clc;
basal_dir = 'E:\Gonzalo\Exp GV11 - GV12 Mayo 2018\GV12\rec_03_OPR2\rec_AM\';
lan_dir = dir([basal_dir '\LAN_GV*.mat']);

lan_for_downsampling = 2; % 1,2 or 3
load([basal_dir lan_dir(lan_for_downsampling).name])

new_srate = 1000;
disp('downsampling data...')
ds_data = nan(size(LAN.data{1,1},1),size(LAN.data{1,1},2)/(LAN.srate/new_srate));
for ch = 1:size(LAN.data{1,1},1)
    disp(['ch ' num2str(ch) '...'])
    ds_data(ch,:) = resample(double(LAN.data{1,1}(ch,:)),new_srate,LAN.srate);
end
clear LAN
LAN.data{1,1} = ds_data;
LAN.srate = new_srate;
LAN = lan_check(LAN);
lansplit = strsplit(lan_dir(lan_for_downsampling).name,'_');
lanjoin = strjoin(lansplit(2:end),'_');
save([basal_dir 'LAN_ds' num2str(new_srate) '_' lanjoin],'LAN','-v7.3')
display('ready')

%% LFP plotting, using a MATLAB figure
basal_dir = 'E:\Gonzalo\Exp GV11 - GV12 Mayo 2018\GV12\rec_03_OPR2\rec_AM\';
lan_dir = dir([basal_dir '\LAN*ds*.mat']);
lan_for_plotting = 1;

load([basal_dir lan_dir(lan_for_plotting).name])

clf
for ch = 1:size(LAN.data{1,1},1)
    plot((LAN.data{1,1}(ch,:) - 2000*(ch-1)),'k')
    hold on
    
end
set(gcf,'color','w')

%% LFP plotting, using lan_master_gui
clear;clc;
basal_dir = 'E:\Gonzalo\Exp GV11 - GV12 Mayo 2018\GV12\rec_03_OPR2\rec_AM\';
lan_dir = dir([basal_dir '\LAN*ds*.mat']);
lan_for_plotting = 2;

load([basal_dir lan_dir(lan_for_plotting).name])
lan_master_gui(LAN)

%% plotting a window of interest
win = [1087 1089]; % seconds
win = win*LAN.srate;
chans = [20];
lan_win = LAN.data{1,1}(chans,win(1):win(2));
t = (win(1):win(2))/LAN.srate;

figure(77);clf;set(gcf,'color','w')
for ch = 1:length(chans)
    plot(t,detrend(lan_win(ch,:))+ 1100*(ch-1),'k')
    hold on
end
