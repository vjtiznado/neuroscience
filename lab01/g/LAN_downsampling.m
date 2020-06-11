%% LAN downsampling
% You just need to specify the new sampling rate that you want for your recordings

clear;clc;
disp('downsampling LAN files...')
basal_dir = 'E:\Gonzalo\Exp GV15 - GV16 Septiembre 2018\'; % Add the path of your data
if ~strcmp(basal_dir(end),'/') && ~strcmp(basal_dir(end),'\'), basal_dir = [basal_dir '/']; end

new_srate = 1000; % new sampling rate

edir = dir([basal_dir 'GV*']);
for e = 1:size(edir,1)
    rdir = dir([basal_dir edir(e).name '/rec*']);
    for r = 1:size(rdir,1)
        %         apdir = dir([basal_dir edir(e).name '/' rdir(r).name '/rec*']);
        %         for ap = 1:size(apdir,1)
        lans = dir([basal_dir edir(e).name '/' rdir(r).name '/LAN*.mat']);
        for f = 1:size(lans,1)
            load([basal_dir edir(e).name '/' rdir(r).name '/' lans(f).name])
            % the following line performs downsampling for each channel
            data_ds = cell2mat(arrayfun(@(ch) resample(double(LAN.data{1,1}(ch,:)),new_srate,LAN.srate),1:LAN.nbchan,'uniformoutput',false)');
            clear LAN % remove the old LAN from your workspace
            LAN.data = {data_ds}; % create a new LAN struct of the downsampled data
            LAN.srate = new_srate;
            LAN = lan_check(LAN);
            
            lan_name = strsplit(lans(f).name,'_'); % splits the orignal LAN filename wherever a '_' was present
            lanpos = find(strcmpi(lan_name,'lan'));
            lan_name(lanpos+2:end+1) = lan_name(lanpos+1:end);
            lan_name{lanpos+1} = ['ds' num2str(new_srate)]; % changes the name of the original LAN file to specify that this is the downsampled one
            lan_name = strjoin(lan_name,'_');
            save([basal_dir edir(e).name '/' rdir(r).name '/' lan_name],'LAN','-v7.3')
            clear LAN lname lanpos
            
        end
    end
end

clc;
disp('ready')
clc
clear
