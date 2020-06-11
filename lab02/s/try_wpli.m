%%
clear;clc;
basal_path = '/Users/vjtiznado/Google Drive/lab_bmi/schizophrenia/data/splinter_01';
load([basal_path filesep 'splinter_01.mat'])
behav = readtable([basal_path filesep 'splinter_01_bh.csv']);
%% performing freq-analysis

cfg                  = []; 
cfg.method           = 'mtmconvol'; 
cfg.output          = 'powandcsd';
cfg.taper            = 'hanning'; 
cfg.channel          = 'all';
cfg.channelcmb       = {'A4' 'A20'};
cfg.keeptrials       = 'yes'; 
cfg.foi              = 1:1:40; 
cfg.t_ftimwin        = ones(length(cfg.foi),1).*.15; 
cfg.toi              = 0:0.05:3; 

[freq] = ft_freqanalysis(cfg, data);

%% performing WPLI

cfg             = []; 
cfg.channelcmb  = {'A4' 'A20'};
cfg.method      = 'wpli'; 
% cfg.trials = find(behav.CueA == 1 & behav.DelayA == 0.033);
% conn_neg            = ft_connectivityanalysis(cfg, freq); 
% cfg.trials = find(behav.CueA == 2 & behav.DelayA == 0.033);
% conn_pos            = ft_connectivityanalysis(cfg, freq); 
cfg.trials = 'all';
conn            = ft_connectivityanalysis(cfg, freq); 

%% Plotting 
figure(1)
pcolor(conn_neg.time, conn_neg.freq, squeeze(conn_neg.wplispctrm))
shading interp
cb = colorbar; 
cb.Label.String = 'WPLI Coherence'; cb.FontSize = 30;
xlim([0 .1])
ylim([1.5 40])
xlabel('time (s)')
ylabel('frequency (Hz)')
title([cfg.channelcmb{1} '-' cfg.channelcmb{2} ', ' char(behav.FaceA(find(behav.CueA == 1,1)))])
caxis([0 1])
set(gca,'tickdir','out','fontsize',24,'linewidth',2,'box','off')
set(gcf,'color','w')

figure(2)
pcolor(conn_pos.time, conn_pos.freq, squeeze(conn_pos.wplispctrm))
shading interp
cb = colorbar; 
cb.Label.String = 'WPLI Coherence'; cb.FontSize = 30;
xlim([0 .1])
ylim([1.5 40])
xlabel('time (s)')
ylabel('frequency (Hz)')
title([cfg.channelcmb{1} '-' cfg.channelcmb{2} ', ' char(behav.FaceA(find(behav.CueA == 2,1)))])
caxis([0 1])
set(gca,'tickdir','out','fontsize',24,'linewidth',2,'box','off')
set(gcf,'color','w')
%% make the cfg's shitty lines a single function
%% make a loop to calculate and save into data the wpli data for every recording
%% maybe loop for plotting all of them in a single figure, in order to figure out the important frequency bands
%% after choosing the frequency band, use it to plot a line with wpli values in the y-axis
%% analyze behavior, separate trials between happy/sad faces
%% when the frequency band is chosen, warping could be interesting
%% but even more, plot the coherence in the z-axis and each row of the y-axis correspond to the evolution of coherence through time,
%% and plot every recording sorted by the variable time between the first and second face
behav = readtable('Josefa_bh.csv');
