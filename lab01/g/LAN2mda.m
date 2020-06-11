%% This code will create the .mda files for each electrode neighborhood (tetrode/shank) of your data. It will take the raw data from a LAN struct.
% This code is a guide. It is made to get into every folder of your data and create the files (it uses a 'for' loop for that). 
% However, it is written in a generic way (animal->recording session->LAN/s), so maybe it will not run properly just as it is.
% Since every person in the lab arranges their data differently, maybe you will need yo adjust the 'for' loop according to your data arrangement.
% Please do not modify this file. Copy/paste it in your matlab codes folder and use/modify your own LAN2mda.m code.
% *** this code runs on every operating system, but first ensure that the folder ~/Dropbox/lab/mountainlab/matlab/ and its subfolders are in your matlab path ***
% * Below this section there is an 'option 2' version, which could be better for you

clear;clc;
disp('creating mda files...')
basal_dir = 'E:\Gonzalo\Exp GV15 - GV16 Septiembre 2018'; % Add the path of your data
if ~strcmp(basal_dir(end),'/') && ~strcmp(basal_dir(end),'\'), basal_dir = [basal_dir '/']; end

% Set your electrode neighborhood
% Amplipex
TT =[26 28 30 32;  % TT1
     18 20 22 24;  % TT2
     10 12 14 16;  % TT3
     02 04 06 08;  % TT4
     25 27 29 31;  % TT5
     17 19 21 23;  % TT6
     09 11 13 15;  % TT7
     01 03 05 07]; % TT8

% % Buzsaki32 probe (tetrodes)
% TT =[31 26 27 21;  % TT1
%      22 23 18 28;  % TT2
%      29 17 24 32;  % TT3
%      20 19 25 30;  % TT4
%      01 02 16 08;  % TT5
%      03 10 14 09;  % TT6
%      07 04 15 05;  % TT7
%      11 13 12 06]; % TT8

% % Buzsaki32 probe (tetrodes)
% TT =[31 26 27 21 22 23 18 28;  % SHANK 1
%      29 17 24 32 20 19 25 30;  % SHANK 2
%      01 02 16 08 03 10 14 09;  % SHANK 3
%      07 04 15 05 11 13 12 06]; % SHANK 4

% A1x32-Poly2-5mm probe
% TT = [01 02 32 31;
%       17 16 15 18;
%       23 10 24 09;
%       29 04 30 03;
%       28 05 19 14;
%       27 06 20 13;
%       26 07 21 12;
%       25 08 22 11];
 
edir = dir([basal_dir 'GV*']);
for e = 1:size(edir,1)
    rdir = dir([basal_dir edir(e).name '/rec*']);
    for r = 1:size(rdir,1)
        apdir = dir([basal_dir edir(e).name '/' rdir(r).name '/rec*']);
        for ap = 1:size(apdir,1)
            lans = dir([basal_dir edir(e).name '/' rdir(r).name '/' apdir(ap).name '/LAN*.mat']);
            for f = 1:size(lans,1)
                load([basal_dir edir(e).name '/' rdir(r).name '/' apdir(ap).name '/' lans(f).name])
                % the following 'if' statement is to change the TT matrix when the headstage was not connected properly
                if strcmp(edir(e).name,'GV01') && strcmp(rdir(r).name(end-4:end),'02_03') && strcmp(lans(f).name, 'LAN_GV01_02_03c.mat') ...
                        || strcmp(edir(e).name,'GV01') && strcmp(rdir(r).name(end-4:end),'02_04')
                    TT = [01 03 05 07;  %TT1
                          09 11 13 15;  %TT2
                          17 19 21 23;  %TT3
                          25 27 29 31;  %TT4
                          02 04 06 08;  %TT5
                          10 12 14 16;  %TT6
                          18 20 22 24;  %TT7
                          26 28 30 32]; %TT8
                end
                for tt = 1:size(TT,1)
                    data = double(LAN.data{1,1}(TT(tt,:),:));
                    lan_name = strsplit(lans(f).name,'.');
                    writemda16i(data,[basal_dir edir(e).name '/' rdir(r).name '/' apdir(ap).name '/' lan_name{1}(5:end) '_tt' num2str(tt) '_raw.mda']);
                end
                clear LAN data lan_name
            end
        end
    end
end
clc;
disp('ready')

%% option 2: This version is the same as the previous one but it saves que .mda files directly into an external hard drive. It is recommended if you are using a non-Linux operating system,
% because it means that you will have to move the files anyway. It is also good if you do not have too much space in your computer, because the .mda files will have the same size of your original recordings, thus duplicating their size might be too heavy.
% This code will create the same folders where your different recordings are located, so the data arrangement in the hard drive will be preserved.

clear;clc;
disp('creating mda files...')
basal_dir = 'E:\Gonzalo\Exp GV16\'; % Add the path of your data
dest_dir = 'E:\Gonzalo\Exp GV16\mda_files\'; % The path of the destination folder in the hardrive
if ~strcmp(basal_dir(end),'/') && ~strcmp(basal_dir(end),'\'), basal_dir = [basal_dir '/']; end
if ~strcmp(dest_dir(end),'/') && ~strcmp(dest_dir(end),'\'), dest_dir = [dest_dir '/']; end
baslast = strsplit(basal_dir,'\');
mkdir([dest_dir baslast{1,end-1}])
dest_dir = [dest_dir baslast{1,end-1}];
if ~strcmp(dest_dir(end),'/') && ~strcmp(dest_dir(end),'\'), dest_dir = [dest_dir '/']; end

% Set your electrode neighborhood
% Amplipex
TT =[26 28 30 32;  % TT1
     18 20 22 24;  % TT2
     10 12 14 16;  % TT3
     02 04 06 08;  % TT4
     25 27 29 31;  % TT5
     17 19 21 23;  % TT6
     09 11 13 15;  % TT7
     01 03 05 07]; % TT8

% % Buzsaki32 probe (tetrodes)
% TT =[31 26 27 21;  % TT1
%      22 23 18 28;  % TT2
%      29 17 24 32;  % TT3
%      20 19 25 30;  % TT4
%      01 02 16 08;  % TT5
%      03 10 14 09;  % TT6
%      07 04 15 05;  % TT7
%      11 13 12 06]; % TT8

% % Buzsaki32 probe (tetrodes)
% TT =[31 26 27 21 22 23 18 28;  % SHANK 1
%      29 17 24 32 20 19 25 30;  % SHANK 2
%      01 02 16 08 03 10 14 09;  % SHANK 3
%      07 04 15 05 11 13 12 06]; % SHANK 4

% A1x32-Poly2-5mm probe
% TT = [01 02 32 31;
%       17 16 15 18;
%       23 10 24 09;
%       29 04 30 03;
%       28 05 19 14;
%       27 06 20 13;
%       26 07 21 12;
%       25 08 22 11];

edir = dir([basal_dir 'GV*']);
for e = 1:size(edir,1)
    mkdir([dest_dir edir(e).name])
    rdir = dir([basal_dir edir(e).name '/rec*']);
    for r = 1:size(rdir,1)
        mkdir([dest_dir edir(e).name '/' rdir(r).name])
        apdir = dir([basal_dir edir(e).name '/' rdir(r).name '/rec*']);
        for ap = 1:size(apdir,1)
            mkdir([dest_dir edir(e).name '/' rdir(r).name '/' apdir(ap).name])
            lans = dir([basal_dir edir(e).name '/' rdir(r).name '/' apdir(ap).name '/LAN*.mat']);
            for f = 1:size(lans,1)
                load([basal_dir edir(e).name '/' rdir(r).name '/' apdir(ap).name '/' lans(f).name])
                % the following 'if' statement is to change the TT matrix when the headstage was not connected properly
                if strcmp(edir(e).name,'GV01') && strcmp(rdir(r).name(end-4:end),'02_03') && strcmp(lans(f).name, 'LAN_GV01_02_03c.mat') ...
                        || strcmp(edir(e).name,'GV01') && strcmp(rdir(r).name(10:14),'02_04')
                    TT = [01 03 05 07;  %TT1
                          09 11 13 15;  %TT2
                          17 19 21 23;  %TT3
                          25 27 29 31;  %TT4
                          02 04 06 08;  %TT5
                          10 12 14 16;  %TT6
                          18 20 22 24;  %TT7
                          26 28 30 32]; %TT8
                end
                for tt = 1:size(TT,1)
                    data = double(LAN.data{1,1}(TT(tt,:),:));
                    lan_name = strsplit(lans(f).name,'.');
                    writemda16i(data,[dest_dir edir(e).name '/' rdir(r).name '/' apdir(ap).name '/' lan_name{1} '_tt' num2str(tt) '_raw.mda']);
                end
                clear LAN data lan_name
            end
        end
    end
end
clc;
disp('ready') 
