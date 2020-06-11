%% This code takes every merged spk file and creates new ones of the spikes in the different task stages (sample, sleep, etc)
% It also set spike timestamps in milliseconds, and remove spikes after ten minutes of exploration
clear;clc;
if isunix
	basal_dir = '/media/labpf/3er_piso_Lab_PF/GVU/Gonzalo/'; % linux
elseif ispc
	basal_dir = 'E:\Gonzalo\'; % windows
end
if ~strcmp(basal_dir(end),'/') && ~strcmp(basal_dir(end),'\'), basal_dir = [basal_dir '/']; end

rec_step = 360000000; % recording step used to separate the spikes of the different recordings when the spikes were concatenated. This value was added 'n-1' times to the spikes' timestamp values of the task stage 'n'. Thus, the formula for creating spikes_merged was the following:
% spikes_merged = [spikes_stage1, (spikes_stage2+rec_step), (spikes_stage3+rec_step*2),..., (spikes_stageN+rec_step*(N-1))];
% This value must match with the one you have in the code data_processing.m, in the section that runs the concatenation

spikes_srate = 20000; % sampling rate of your original recording

edir = dir([basal_dir 'Exp*']);

disp('splitting spikes...')
for e = 1:size(edir,1)
	adir = dir([basal_dir edir(e).name '/GV*']);
	for a = 1:size(adir,1)
		rdir = dir([basal_dir edir(e).name '/' adir(a).name '/rec*']);
		for r = 1:size(rdir,1)
			cd([basal_dir edir(e).name '/' adir(a).name '/' rdir(r).name '/']);
				
			tsps = dir('*.tsp'); % as there is one .tsp file for each recording saved in the folder, we will use the filename of these files to infere the different recording stages
			spks = dir('spk*merged*.mat');
			if size(spks,1)==0
				continue
			end
			% get the names of the different recordings you have in the folder, that correspond to your task stages
			stages = arrayfun(@(t) strsplit(tsps(t).name,'_'),1:size(tsps,1),'uniformoutput',false);
			stages = arrayfun(@(t) stages{t}{end}(1:end-4),1:length(stages),'uniformoutput',false)';
			for s = 1:size(spks,1)
				 [~,fn,ext] = fileparts(spks(s).name); % get filename data 
				 fspl = strsplit(fn,'_'); % split the filename without extension
				 findmerge = strcmp(fspl,'merged'); % find where the word "merged" is located in the filename

				 load(spks(s).name);
				 spikes_original = spikes;
				 clear spikes
				 for m = 1:size(stages,1)
					 % detect the spikes corresponding only to the spikes of the current stage, by finding the spikes between recording steps
					 spikes = spikes_original(spikes_original > rec_step*(m-1) & spikes_original < rec_step*m,1);
					 spikes = spikes - rec_step*(m-1); % remove the rec_step to get original timestamp values
					 
					 spikes_units = 'ms'; % we will make explicit that for this files timestamps values are in miliseconds
					 spikes = (spikes/spikes_srate)*1000; % from samples to ms
					 % spikes(spikes>600000) = []; % spikes only during first ten minutes of recording

					 fspl{findmerge} = stages{m}; % replace the name of the current stage in the same place where the word "merged" was located
					 rename_spk = strcat(strjoin(fspl,'_'),ext); % join the new filename and add its extension

					 save(rename_spk,'spikes','spikes_units')
				end
			end
		end
	end
end
cd(basal_dir)
clear;clc;
disp('ready')
