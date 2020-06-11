%% obtaining fieldtrip's data struct from a .bdf recording file
clear;clc
tic
if ispc
    basal_path = 'G:\Mi unidad\BMI lab\Andrea\schizophrenia\data';
elseif ismac
	basal_path = '/Users/vjtiznado/Google Drive/lab_bmi/schizophrenia/data';
elseif isunix
	basal_path = '~/Dropbox/neuroscience/lab_bmi/schizophrenia/data';
end
subjects = dir([basal_path filesep 'splinter*']);
subjects = {subjects.name};

for s = subjects
	cd([basal_path filesep s{1}])
	recs = dir([basal_path filesep s{1} filesep 'splinter*.bdf']);
	recs = {recs.name};
	for r = recs
		if isfile([r{1}(1:end-4) '.mat'])
			continue
		end
		trigs = [1 2];
		window = [-.5 1]; % window time borders (in seconds) respect to trigger onset
		data = rec2ft(recs{1},trigs,window);
  
		save([r{1}(1:end-4) '.mat'],'data')
		clear data
	end
	if isfile([s{1} '.mat'])
		continue
	end
	recs_mat = dir([basal_path filesep s{1} filesep s{1} '_*.mat']);
	cfg.inputfile = {recs_mat.name}';
	cfg.outputfile = [s{1} '.mat'];
	ft_appenddata(cfg);
end
% clc
disp('ready')
toc
