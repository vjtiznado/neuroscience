function [conn, freq] = wpliconn(data, channel_names, freqs_oi, window, trials)
if nargin < 5 || isempty(trials)
	trials = 'all';
end

cfg = [];
cfg.method           = 'mtmconvol'; 
cfg.output           = 'powandcsd';
cfg.taper            = 'hanning'; 
cfg.channel          = 'all';
cfg.channelcmb       = channel_names;
cfg.keeptrials       = 'yes'; 
cfg.foi              = freqs_oi(1):1:freqs_oi(2); 
cfg.t_ftimwin        = ones(length(cfg.foi),1).*.15; 
cfg.toi              = window; 

freq = ft_freqanalysis(cfg, data);

cfg             = []; 
cfg.channelcmb  = channel_names;
cfg.method      = 'wpli'; 
cfg.trials      = trials;
conn            = ft_connectivityanalysis(cfg, freq); 
