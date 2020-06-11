%% separating trials depending on parameters of the behavior file (*_bh.csv)
clear;clc
tic

if ismac
	basal_path = '/Users/vjtiznado/Google Drive/lab_bmi/schizophrenia/data';
elseif isunix
	basal_path = '~/Dropbox/neuroscience/lab_bmi/schizophrenia/data';
end
subjects = dir([basal_path filesep 'splinter*']);
subjects = {subjects.name};

for s = subjects
	recs = dir([basal_path filesep s{1} filesep s{1} '.mat']);
	behav = readtable([basal_path filesep s{1} filesep s{1} '_bh.csv']);
	load([basal_path filesep s{1} filesep recs.name])
	if isfield(data,'conn_all')
		continue
	end
	chans = {'A4' 'A20'};
	freqs = [1 40];
	win = 0:.5:1; % window time borders (in seconds) respect to trigger onset

	[data.conn_all, data.freq_all] = wpliconn(data, chans, freqs, win);
	trials_neg = find(behav.CueA == 1);
	trials_pos = find(behav.CueA == 2);
	[data.conn_neg, data.freq_neg] = wpliconn(data, chans, freqs, win, trials_neg);
	[data.conn_pos, data.freq_pos] = wpliconn(data, chans, freqs, win, trials_pos);
	save([basal_path filesep s{1} filesep recs.name],'data')
	clear data
end
% clc
disp('ready')
toc
