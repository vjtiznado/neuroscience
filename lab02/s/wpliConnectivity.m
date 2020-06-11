cd('D:\MDomic'); 
load('PLANNING.mat'); 

%% loading data as requested by fieldtrip 

sig             = squeeze(Scouts.data(1,:,:,:)); 

data            = [];
data.label      = Scouts.labels; 
data.time       = repmat({Scouts.time}, [size(sig,3),1])'; 
for n = 1:size(sig,3); data.trial{n} = squeeze(sig(:,:,n)');end 
data.fsample    = 1000; 
data.trialinfo  = repmat([1 length(Scouts.time)], [size(sig,3), 1]); 

% check if everything is working
cfg             = [];
[data]          = ft_preprocessing(cfg, data); 

%% performing freq-analysis

cfg                  = []; 
cfg.method           = 'mtmconvol'; 
cfg.output          = 'powandcsd';
cfg.taper            = 'hanning'; 
cfg.channel          = 'all';
cfg.channelcmb       = {'G_and_S_cingul-Ant L' 'G_and_S_cingul-Ant R'};
cfg.keeptrials       = 'yes'; 
cfg.foi              = 1:1:40; 
cfg.t_ftimwin        = ones(length(cfg.foi),1).*.25; 
cfg.toi              = -1:0.05:4; 

[freq] = ft_freqanalysis(cfg, data);

%% performing WPLI

cfg             = []; 
cfg.channelcmb  = {'G_and_S_cingul-Ant L' 'G_and_S_cingul-Ant R'};
cfg.method      = 'wpli'; 
conn            = ft_connectivityanalysis(cfg, freq); 

%% Plotting 

pcolor(conn.time, conn.freq, squeeze(conn.wplispctrm)); shading interp; colorbar; colormap('jet');
