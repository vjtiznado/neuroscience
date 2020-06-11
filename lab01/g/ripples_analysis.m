%% ripples' detection
basal_dir = 'E:\Gonzalo\Exp GV11 - GV12 Mayo 2018\GV12\rec_03_OPR2\rec_AM\';
lan_dir = dir([basal_dir '\LAN*ds*.mat']);
lan_for_plotting = 2;

load([basal_dir lan_dir(lan_for_plotting).name])

chans = [24];
sd_threshold = 5;

cfg.chan = chans;
cfg.freq = [100 250]; % set the ripples' frequency band
cfg.time = 30; % min ripple duration necessary to be detected
cfg.thr = [1 sd_threshold]; % detection threshold: 3.5 or 5 SD
cfg.method = 'logothetis';
cfg.norbin = 0;

LAN.RT = lan_detect_freq_event2(LAN,cfg);

save([basal_dir lan_dir(lan_for_plotting).name],'LAN','-v7.3')

%% LFP visualization using lan_master_gui

lan_master_gui(LAN)

%% LAN loading and filtering 

basal_dir = 'E:\Gonzalo\Exp GV11 - GV12 Mayo 2018\GV12\rec_03_OPR2\rec_AM\';
lan_dir = dir([basal_dir '\LAN*ds*.mat']);
lan_for_plotting = 2;

load([basal_dir lan_dir(lan_for_plotting).name])
chans = 24;

fLAN_ripples.data = lan_butter(LAN,100,250); % filtering

%% plotting the whole recording. visualize it and choose the your window of interest. 
% Set the interval in the variable 'win' of the next section
t = (1:size(LAN.data{1,1},2))/LAN.srate;
figure(66);clf;set(gcf,'color','w')
for ch = 1:length(chans)
    plot(t,LAN.data{1,1}(chans(ch),:)+2500*(ch-1),'k','color',[0 .0 .4])
    hold on
    plot(t,fLAN_ripples.data{1,1}(chans(ch),:)*5 +2000*(ch-1),'color',[0 .7 .2])
    
end
%
%% ripples' detection only during your window of interest
clearvars -except LAN
win = [4180 4210]; % choose your interval for ripple detection
win = win*LAN.srate;

sd_threshold = 3.5;
chans = 1:32;

LAN2.data{1,1} = LAN.data{1,1}(:,win(1):win(2));
LAN2.srate = LAN.srate;
LAN2 = lan_check(LAN2);

cfg.chan = chans;
cfg.freq = [100 250]; % set the ripples' frequency band
cfg.time = 40; % min ripple duration necessary to be detected
cfg.thr = [1 sd_threshold]; % detection threshold: 3.5 or 5 SD
cfg.method = 'logothetis';
cfg.norbin = 0;

LAN2.RT = lan_detect_freq_event2(LAN2,cfg);

lan_master_gui(LAN2)

%%
win = [4180 4210];
inwin = [14 20];
winwin = win(1) + inwin;

%loading the LAN at 20000Hz
basal_dir = 'E:\Gonzalo\Exp GV11 - GV12 Mayo 2018\GV12\rec_03_OPR2\rec_AM\';
lan_dir = dir([basal_dir '\LAN_GV*.mat']);
lan_for_plotting = 2;
load([basal_dir lan_dir(lan_for_plotting).name])

winwin = winwin*LAN.srate;
dataoi = LAN.data{1,1}(:,winwin(1):winwin(2));
t = (1:size(dataoi,2))/LAN.srate;
clear LAN

LAN3.data{1,1} = dataoi;
LAN3.srate = 20000;
LAN3 = lan_check(LAN3);
LAN4.data = lan_butter(LAN3,100,250);
LAN4.srate = 20000;
LAN4 = lan_check(LAN4);

%%
chans = 24;
clf
for ch = 1:length(chans)
    rippsoi = (LAN2.RT.latency(LAN2.RT.est==chans(ch))+LAN2.RT.OTHER.time_max(LAN2.RT.est==chans(ch)))/1000;
    rippsoi = rippsoi(rippsoi >= inwin(1));
    rippsoi = rippsoi - inwin(1);
    plot(t,detrend(dataoi(chans(ch),:))+2000*(ch-1),'k')
    hold on
    plot(t,LAN4.data{1,1}(chans(ch),:)*2 -1000 +2200*(ch-1),'color',[0 .7 0])
    plot(rippsoi,ones(1,length(rippsoi))*400 -1000 + 2200*(ch-1),'r*','markersize',10)
   
end
xlim([0 diff(inwin)])