%%
clear;clc;
basal_dir = '/home/labpf/Documents/VT/mountainlab/data/try2/';

T = readmda([basal_dir 'tt1_merged_wfirings2.mda']);
WV = readmda([basal_dir 'tt1_merged_wtemplates2.mda']);
load([basal_dir 'tt1_data_merged2.mat'],'data_all','rec_step');
zs = zeros(1,rec_step);
trial_ini = strfind(data_all(1,:),zs);
clear data_all
for c = unique(T(3,:))
    spikes = T(2,T(3,:)==c)';
    mean_spk = squeeze(WV(T(1,T(2,:)==spikes(1)),10:end,c));
    trial_of_spike = nan(size(spikes));
    for t = 1:length(trial_ini)
        if t == 1
            tspk = spikes >= 0 & spikes < trial_ini (t);
        else
            tspk = spikes >= trial_ini(t-1) & spikes < trial_ini (t);
        end
        trial_of_spike(find(isnan(trial_of_spike),1,'first'):find(isnan(trial_of_spike),1,'first')+sum(tspk)-1) = t;
    end
    save([basal_dir 'spk_ml_tt1_merged2_' num2str(c) '.mat'],'spikes','mean_spk','trial_of_spike','trial_ini');
    clear spikes mean_spk trial_of_spike
end
disp('*** ready ***')

%%
shank=true;
tetr=false;
sh=4;
tt=8;
clf;clc
clear WV1 WV2
basal_dir = '/home/labpf/Documents/VT/mountainlab/data/RL03_reg01_shank/';
if shank == true
    WV1 = readmda([basal_dir 'RL03_reg01_sh' num2str(sh) '_templates.mda']);
    try
        WV2 = readmda([basal_dir 'RL03_reg01_sh' num2str(sh) '_templates_curated.mda']);
    catch
    end
    
elseif tetr == true
    WV1 = readmda([basal_dir 'RL03_reg01_tt' num2str(tt) '_templates.mda']);
    try
        WV2 = readmda([basal_dir 'RL03_reg01_tt' num2str(tt) '_templates_curated.mda']);
    catch
    end
end
% WV=WV2;
% disp(num2str(size(WV,3)))
%% plotting deleted and curated clusters
%% tetrode
c = 1;
ymin = -250;
ymax = 70;
xmax = size(WV1,2);
if sum(tt==[1,3,5,7]) == 0
    pl = 4;
else
    pl = 0;
end
subplot(4,2,1+pl)
if exist('WV2','var') && size(WV2,3)>=c && sum(isnan(squeeze(WV2(1,10:end,c)))) == 0
    plot(squeeze(WV2(1,10:end,c)),'k','linewidth',3)
else
    plot(squeeze(WV1(1,10:end,c)),'color',[.6 .6 .6],'linewidth',3)
end
ylim([ymin ymax])
xlim([5 xmax])
axis off

subplot(4,2,2+pl)
if exist('WV2','var')&& size(WV2,3)>=c  && sum(isnan(squeeze(WV2(2,10:end,c)))) == 0
    plot(squeeze(WV2(2,10:end,c)),'k','linewidth',3)
else
    plot(squeeze(WV1(2,10:end,c)),'color',[.6 .6 .6],'linewidth',3)
end
ylim([ymin ymax])
xlim([5 xmax])
axis off

subplot(4,2,3+pl)
if exist('WV2','var') && size(WV2,3)>=c && sum(isnan(squeeze(WV2(3,10:end,c)))) == 0
    plot(squeeze(WV2(3,10:end,c)),'k','linewidth',3)
else
    plot(squeeze(WV1(3,10:end,c)),'color',[.6 .6 .6],'linewidth',3)
end
ylim([ymin ymax])
xlim([5 xmax])
axis off

subplot(4,2,4+pl)
if exist('WV2','var') && size(WV2,3)>=c && sum(isnan(squeeze(WV2(4,10:end,c)))) == 0
    plot(squeeze(WV2(4,10:end,c)),'k','linewidth',3)
else
    plot(squeeze(WV1(4,10:end,c)),'color',[.6 .6 .6],'linewidth',3)
end
ylim([ymin ymax])
xlim([5 xmax])
axis off

set(gcf,'color','w')

%% shank

c = 14;
ymin = -200;
ymax = 70;
xmax = size(WV1,2);

subplot(4,2,1)
if exist('WV2','var') && size(WV2,3)>=c && sum(isnan(squeeze(WV2(1,10:end,c)))) == 0
    plot(squeeze(WV2(1,10:end,c)),'k','linewidth',3)
else
    plot(squeeze(WV1(1,10:end,c)),'color',[.6 .6 .6],'linewidth',3)
end
ylim([ymin ymax])
xlim([5 xmax])
axis off

subplot(4,2,2)
if exist('WV2','var') && size(WV2,3)>=c && sum(isnan(squeeze(WV2(1,10:end,c)))) == 0
    plot(squeeze(WV2(2,10:end,c)),'k','linewidth',3)
else
    plot(squeeze(WV1(2,10:end,c)),'color',[.6 .6 .6],'linewidth',3)
end
ylim([ymin ymax])
xlim([5 xmax])
axis off

subplot(4,2,3)
if exist('WV2','var') && size(WV2,3)>=c && sum(isnan(squeeze(WV2(1,10:end,c)))) == 0
    plot(squeeze(WV2(3,10:end,c)),'k','linewidth',3)
else
    plot(squeeze(WV1(3,10:end,c)),'color',[.6 .6 .6],'linewidth',3)
end
ylim([ymin ymax])
xlim([5 xmax])
axis off

subplot(4,2,4)
if exist('WV2','var') && size(WV2,3)>=c && sum(isnan(squeeze(WV2(1,10:end,c)))) == 0
    plot(squeeze(WV2(4,10:end,c)),'k','linewidth',3)
else
    plot(squeeze(WV1(4,10:end,c)),'color',[.6 .6 .6],'linewidth',3)
end
ylim([ymin ymax])
xlim([5 xmax])
axis off

subplot(4,2,5)
if exist('WV2','var') && size(WV2,3)>=c && sum(isnan(squeeze(WV2(1,10:end,c)))) == 0
    plot(squeeze(WV2(5,10:end,c)),'k','linewidth',3)
else
    plot(squeeze(WV1(5,10:end,c)),'color',[.6 .6 .6],'linewidth',3)
end
ylim([ymin ymax])
xlim([5 xmax])
axis off

subplot(4,2,6)
if exist('WV2','var') && size(WV2,3)>=c && sum(isnan(squeeze(WV2(1,10:end,c)))) == 0
    plot(squeeze(WV2(6,10:end,c)),'k','linewidth',3)
else
    plot(squeeze(WV1(6,10:end,c)),'color',[.6 .6 .6],'linewidth',3)
end
ylim([ymin ymax])
xlim([5 xmax])
axis off

subplot(4,2,7)
if exist('WV2','var') && size(WV2,3)>=c && sum(isnan(squeeze(WV2(1,10:end,c)))) == 0
    plot(squeeze(WV2(7,10:end,c)),'k','linewidth',3)
else
    plot(squeeze(WV1(7,10:end,c)),'color',[.6 .6 .6],'linewidth',3)
end
ylim([ymin ymax])
xlim([5 xmax])
axis off

subplot(4,2,8)
if exist('WV2','var') && size(WV2,3)>=c && sum(isnan(squeeze(WV2(1,10:end,c)))) == 0
    plot(squeeze(WV2(8,10:end,c)),'k','linewidth',3)
else
    plot(squeeze(WV1(8,10:end,c)),'color',[.6 .6 .6],'linewidth',3)
end
ylim([ymin ymax])
xlim([5 xmax])
axis off

set(gcf,'color','w')

%% plotting only curated clusters
%% tetrodes
c = 4;
ymin = -250;
ymax = 70;
xmax = size(WV2,2);
if sum(tt==[1,3,5,7]) == 0
    pl = 4;
else
    pl = 0;
end
subplot(4,2,1+pl)
if exist('WV2','var') && sum(isnan(squeeze(WV2(1,10:end,c)))) == 0
    plot(squeeze(WV2(1,10:end,c)),'k','linewidth',3)

end
ylim([ymin ymax])
xlim([5 xmax])
axis off

subplot(4,2,2+pl)
if exist('WV2','var') && sum(isnan(squeeze(WV2(2,10:end,c)))) == 0
    plot(squeeze(WV2(2,10:end,c)),'k','linewidth',3)

end
ylim([ymin ymax])
xlim([5 xmax])
axis off

subplot(4,2,3+pl)
if exist('WV2','var') && sum(isnan(squeeze(WV2(3,10:end,c)))) == 0
    plot(squeeze(WV2(3,10:end,c)),'k','linewidth',3)
end
ylim([ymin ymax])
xlim([5 xmax])
axis off

subplot(4,2,4+pl)
if exist('WV2','var') && sum(isnan(squeeze(WV2(4,10:end,c)))) == 0
    plot(squeeze(WV2(4,10:end,c)),'k','linewidth',3)
end
ylim([ymin ymax])
xlim([5 xmax])
axis off

set(gcf,'color','w')
%%
load('/home/labpf/Documents/VT/mountainlab/data/try3/RL03_reg03_lan500.mat')

%%
choi = 44:63;
WV = nan(size(LAN.sRT.waveform{1,1},2),size(LAN.sRT.waveform{1,1},1),length(choi));
for c = 1:length(choi)
    WV(:,:,c) = LAN.sRT.waveform{choi(c)}';
end

%%

c = 20;
ymin = -250;
ymax = 70;
xmax = size(WV,2);

subplot(1,4,1)
plot(squeeze(WV(1,10:end,c)),'linewidth',3)
ylim([ymin ymax])
xlim([5 xmax])
axis off

subplot(1,4,2)
plot(squeeze(WV(2,10:end,c)),'linewidth',3)
ylim([ymin ymax])
xlim([5 xmax])
axis off

subplot(1,4,3)
plot(squeeze(WV(3,10:end,c)),'linewidth',3)
ylim([ymin ymax])
xlim([5 xmax])
axis off

subplot(1,4,4)
plot(squeeze(WV(4,10:end,c)),'linewidth',3)
ylim([ymin ymax])
xlim([5 xmax])
axis off

set(gcf,'color','w')


%%
clf
set(gcf,'color','w')

ymin = -250;
ymax = 70;
xmax = size(WV,2);
pmat = [1:size(WV,3);...
    size(WV,3)+1:size(WV,3)*2;...
    size(WV,3)*2+1:size(WV,3)*3;...
    size(WV,3)*3+1:size(WV,3)*4];

for c = 1:size(WV,3)
    for ch = 1:4
        subplot(4,size(WV,3),pmat(ch,c))
        plot(squeeze(WV(ch,10:end,c)),'linewidth',3)
        ylim([ymin ymax])
        xlim([5 xmax])
        axis off
    end
end
