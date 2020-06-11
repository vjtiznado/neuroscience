%% RIPPLE-TASK_EVENT CROSS-CORRELATION
clc;clear
data_dir = 'C:\Users\neuro\Dropbox\VT\LFP_data\';
results_dir = 'C:\Users\neuro\Dropbox\SB\RESULTADOS\RIPPLES\';
% load([results_dir 'ripples_data_raw_SD_3.mat'])
load([results_dir 'ripples_data_raw_SD_5.mat'])

%% RIPPLE RASTER PLOT

clc;
clear
data_dir = 'C:\Users\neuro\Dropbox\VT\LFP_data\';
results_dir = 'C:\Users\neuro\Dropbox\SB\RESULTADOS\RIPPLES\';

sd_n = 5;

load([results_dir 'ripples_data_raw_SD_' num2str(sd_n) '.mat'])
count = 0;
ripp_raster = struct('press',[],'stimo',[],'levre',[],'info',[]);
for r = 1:size(rat_ripples,2)
    display(rat_ripples(r).name)
    ses_dir = dir([data_dir rat_ripples(r).name '\session*']);
    for s = 1:size(ses_dir,1)
        display(ses_dir(s).name)
        load([data_dir rat_ripples(r).name '\' ses_dir(s).name '\TTL.mat'])
        load([data_dir rat_ripples(r).name '\' ses_dir(s).name '\LFP.mat'],'channels','tetrodes','srate')
        
        if r == 2 && s == 1
            ini = 300000;
            fin = 2850000;
            TTL(:,[2,3,4,6]) = TTL(:,[2,3,4,6]) - (ini/srate)*1000;
            TTL = TTL(TTL(:,2)>0 & TTL(:,2)<1000*(fin-ini)/srate,:);
        elseif r == 2 && s == 2
            ini = 1;
            fin = 2100000;
            TTL = TTL(TTL(:,2)>0 & TTL(:,2)<1000*(fin-ini)/srate,:);
        elseif r == 2 && s == 3
            ini = 1;
            fin = 2390000;
            TTL = TTL(TTL(:,2)>0 & TTL(:,2)<1000*(fin-ini)/srate,:);
        elseif r == 2 && s == 4
            ini = 1000000;
            fin = 2190000;
            TTL(:,[2,3,4,6]) = TTL(:,[2,3,4,6]) - (ini/srate)*1000;
            TTL = TTL(TTL(:,2)>0 & TTL(:,2)<1000*(fin-ini)/srate,:);
        elseif r == 2 && s == 6
            ini = 1;
            fin = 1850000;
            TTL = TTL(TTL(:,2)>0 & TTL(:,2)<1000*(fin-ini)/srate,:);
        elseif r == 4 && s == 1;
            ini = 1;
            fin = 1535800;
            TTL = TTL(TTL(:,2)>0 & TTL(:,2)<1000*(fin-ini)/srate,:);
        elseif r == 4 && s == 3;
            ini = 1;
            fin = 1568900;
            TTL = TTL(TTL(:,2)>0 & TTL(:,2)<1000*(fin-ini)/srate,:);
        elseif r == 4 && s == 4
            ini = 1430000;
            fin = 3653400;
            TTL(:,[2,3,4,6]) = TTL(:,[2,3,4,6]) - (ini/srate)*1000;
            TTL = TTL(TTL(:,2)>0 & TTL(:,2)<1000*(fin-ini)/srate,:);
        elseif r == 4 && s == 5
            ini = 1;
            fin = 2074300;
            TTL = TTL(TTL(:,2)>0 & TTL(:,2)<1000*(fin-ini)/srate,:);
        elseif r == 4 && s == 6
            ini = 1;
            fin = 2312200;
            TTL = TTL(TTL(:,2)>0 & TTL(:,2)<1000*(fin-ini)/srate,:);
        elseif r == 4 && s == 7
            ini = 1578300;
            fin = 2946600;
            TTL(:,[2,3,4,6]) = TTL(:,[2,3,4,6]) - (ini/srate)*1000;
            TTL = TTL(TTL(:,2)>0 & TTL(:,2)<1000*(fin-ini)/srate,:);
        elseif r == 4 && s == 8
            ini = 1;
            fin = 1129200;
            TTL = TTL(TTL(:,2)>0 & TTL(:,2)<1000*(fin-ini)/srate,:);
        elseif r == 4 && s == 9
            ini = 1000000;
            fin = 2010000;
            TTL(:,[2,3,4,6]) = TTL(:,[2,3,4,6]) - (ini/srate)*1000;
            TTL = TTL(TTL(:,2)>0 & TTL(:,2)<1000*(fin-ini)/srate,:);
        elseif r == 6 && s == 8;
            ini = 250000;
            fin = 1400000;
            TTL(:,[2,3,4,6]) = TTL(:,[2,3,4,6]) - (ini/srate)*1000;
            TTL = TTL(TTL(:,2)>0 & TTL(:,2)<1000*(fin-ini)/srate,:);
        elseif r == 6 && s == 3;
            ini = 1218824;
            fin = 2357648;
            TTL(:,[2,3,4,6]) = TTL(:,[2,3,4,6]) - (ini/srate)*1000;
            TTL = TTL(TTL(:,2)>0 & TTL(:,2)<1000*(fin-ini)/srate,:);
        end
        
        RT = rat_ripples(r).ripples_data{s,1};
        tw = 6000;
        for chs = 1:size(unique(RT.est(1,:)),2)
            count = count + 1;
            ripp_ts = RT.latency(RT.est(1,:) == chs);
            max_lag = 3000;
            bin = 300;
            
            ripp_raster.info{count,1} = rat_ripples(r).name;
            if channels(chs) < 10
                ripp_raster.info{count,2} = [ses_dir(s).name '_tt' num2str(tetrodes(ceil(chs/4))) '_0' num2str(channels(chs))];
            else
                ripp_raster.info{count,2} = [ses_dir(s).name '_tt' num2str(tetrodes(ceil(chs/4))) '_' num2str(channels(chs))];
            end
            ripp_raster.press{count,1} = rastermk(ripp_ts,TTL(:,2),TTL(:,1),tw);
            ripp_raster.stimo{count,1} = rastermk(ripp_ts,TTL(:,6),TTL(:,1),tw);
            ripp_raster.levre{count,1} = rastermk(ripp_ts,TTL(:,4),TTL(:,1),tw);
            %all
            [ripp_raster.press{count,3},~] = corr_cruz(TTL(:,2),RT.latency(RT.est(1,:) == chs),max_lag,bin);
            [ripp_raster.stimo{count,3},~] = corr_cruz(TTL(:,6),RT.latency(RT.est(1,:) == chs),max_lag,bin);
            [ripp_raster.levre{count,3},~] = corr_cruz(TTL(:,4),RT.latency(RT.est(1,:) == chs),max_lag,bin);
            %hit
            [ripp_raster.press{count,4},~] = corr_cruz(TTL(TTL(:,1)==11,2),RT.latency(RT.est(1,:) == chs),max_lag,bin);
            [ripp_raster.stimo{count,4},~] = corr_cruz(TTL(TTL(:,1)==11,6),RT.latency(RT.est(1,:) == chs),max_lag,bin);
            [ripp_raster.levre{count,4},~] = corr_cruz(TTL(TTL(:,1)==11,4),RT.latency(RT.est(1,:) == chs),max_lag,bin);
            
            %fa
            [ripp_raster.press{count,5},~] = corr_cruz(TTL(TTL(:,1)==22,2),RT.latency(RT.est(1,:) == chs),max_lag,bin);
            [ripp_raster.stimo{count,5},~] = corr_cruz(TTL(TTL(:,1)==22,6),RT.latency(RT.est(1,:) == chs),max_lag,bin);
            [ripp_raster.levre{count,5},~] = corr_cruz(TTL(TTL(:,1)==22,4),RT.latency(RT.est(1,:) == chs),max_lag,bin);
            
            %cr
            [ripp_raster.press{count,6},~] = corr_cruz(TTL(TTL(:,1)==23,2),RT.latency(RT.est(1,:) == chs),max_lag,bin);
            [ripp_raster.stimo{count,6},~] = corr_cruz(TTL(TTL(:,1)==23,6),RT.latency(RT.est(1,:) == chs),max_lag,bin);
            [ripp_raster.levre{count,6},eje] = corr_cruz(TTL(TTL(:,1)==23,4),RT.latency(RT.est(1,:) == chs),max_lag,bin);
            
            
            bin = 300; % bin (ms)
            centros = (-tw/2:bin:tw/2);
            centros = centros+bin/2;
            centros = centros(1:end-1);            
            ripp_raster.press{count,2} = nan(size(TTL(:,1),1),size(centros,2));
            ripp_raster.stimo{count,2} = nan(size(TTL(:,1),1),size(centros,2));
            ripp_raster.levre{count,2} = nan(size(TTL(:,1),1),size(centros,2));

            for i = 1:size(TTL(:,1),1)
                
                ripp_raster.press{count,2}(i,:) = (hist(ripp_raster.press{count,1}(1,ripp_raster.press{count,1}(2,:)==i)-tw/2,centros))/bin;
                ripp_raster.stimo{count,2}(i,:) = (hist(ripp_raster.stimo{count,1}(1,ripp_raster.stimo{count,1}(2,:)==i)-tw/2,centros))/bin;
                ripp_raster.levre{count,2}(i,:) = (hist(ripp_raster.levre{count,1}(1,ripp_raster.levre{count,1}(2,:)==i)-tw/2,centros))/bin;
                
            end
        end
    end    
end
clearvars -except ripp_raster rat_ripples tw results_dir sd_n centros eje
cd(results_dir)
time_window = tw;
tw_units = 'ms';
save(['ripples_raster_SD_' num2str(sd_n) '.mat'],'ripp_raster','time_window','tw_units','centros','eje','-v7.3')


SD = 5;

load(['C:\Users\neuro\Dropbox\SB\RESULTADOS\RIPPLES\ripples_raster_SD_' num2str(SD) '.mat'])

% %% mean cross correlation of all rats and each rat
xcors_press_all = nan(size(ripp_raster.press,1),size(ripp_raster.press{1,3},2));
xcors_stimo_all = nan(size(ripp_raster.stimo,1),size(ripp_raster.stimo{1,3},2));
xcors_levre_all = nan(size(ripp_raster.levre,1),size(ripp_raster.levre{1,3},2));

xcors_press_hit = nan(size(ripp_raster.press,1),size(ripp_raster.press{1,3},2));
xcors_stimo_hit = nan(size(ripp_raster.stimo,1),size(ripp_raster.stimo{1,3},2));
xcors_levre_hit = nan(size(ripp_raster.levre,1),size(ripp_raster.levre{1,3},2));

xcors_press_fa = nan(size(ripp_raster.press,1),size(ripp_raster.press{1,3},2));
xcors_stimo_fa = nan(size(ripp_raster.stimo,1),size(ripp_raster.stimo{1,3},2));
xcors_levre_fa = nan(size(ripp_raster.levre,1),size(ripp_raster.levre{1,3},2));

xcors_press_cr = nan(size(ripp_raster.press,1),size(ripp_raster.press{1,3},2));
xcors_stimo_cr = nan(size(ripp_raster.stimo,1),size(ripp_raster.stimo{1,3},2));
xcors_levre_cr = nan(size(ripp_raster.levre,1),size(ripp_raster.levre{1,3},2));

for i = 1:size(ripp_raster.press,1)
    xcors_press_all(i,:) = ripp_raster.press{i,3};
    xcors_stimo_all(i,:) = ripp_raster.stimo{i,3};
    xcors_levre_all(i,:) = ripp_raster.levre{i,3};
    xcors_press_hit(i,:) = ripp_raster.press{i,4};
    xcors_stimo_hit(i,:) = ripp_raster.stimo{i,4};
    xcors_levre_hit(i,:) = ripp_raster.levre{i,4};
    xcors_press_fa(i,:) = ripp_raster.press{i,5};
    xcors_stimo_fa(i,:) = ripp_raster.stimo{i,5};
    xcors_levre_fa(i,:) = ripp_raster.levre{i,5};
    xcors_press_cr(i,:) = ripp_raster.press{i,6};
    xcors_stimo_cr(i,:) = ripp_raster.stimo{i,6};
    xcors_levre_cr(i,:) = ripp_raster.levre{i,6};
      
end

rats = unique(ripp_raster.info(:,1));
rmean_xcorr(1:size(rats,1)+1) = struct('rat',[],'press',[],'stimo',[],'levre',[]);
rmean_xcorr(end).rat = 'ALL';
rmean_xcorr(end).press{1,1} = nanmean(xcors_press_all);
rmean_xcorr(end).press{1,2} = nanmean(xcors_press_hit);
rmean_xcorr(end).press{1,3} = nanmean(xcors_press_fa);
rmean_xcorr(end).press{1,4} = nanmean(xcors_press_cr);

rmean_xcorr(end).stimo{1,1} = nanmean(xcors_stimo_all);
rmean_xcorr(end).stimo{1,2} = nanmean(xcors_stimo_hit);
rmean_xcorr(end).stimo{1,3} = nanmean(xcors_stimo_fa);
rmean_xcorr(end).stimo{1,4} = nanmean(xcors_stimo_cr);

rmean_xcorr(end).levre{1,1} = nanmean(xcors_levre_all);
rmean_xcorr(end).levre{1,2} = nanmean(xcors_levre_hit);
rmean_xcorr(end).levre{1,3} = nanmean(xcors_levre_fa);
rmean_xcorr(end).levre{1,4} = nanmean(xcors_levre_cr);

for r = 1:size(rats,1)
    rvector = strcmp(ripp_raster.info(:,1),rats{r,1});
    rmean_xcorr(r).rat = rats{r,1};
    rmean_xcorr(r).press{1,1} = nanmean(xcors_press_all(rvector,:));
    rmean_xcorr(r).stimo{1,1} = nanmean(xcors_stimo_all(rvector,:));
    rmean_xcorr(r).levre{1,1} = nanmean(xcors_levre_all(rvector,:));
    rmean_xcorr(r).press{1,2} = nanmean(xcors_press_hit(rvector,:));
    rmean_xcorr(r).stimo{1,2} = nanmean(xcors_stimo_hit(rvector,:));
    rmean_xcorr(r).levre{1,2} = nanmean(xcors_levre_hit(rvector,:));
    rmean_xcorr(r).press{1,3} = nanmean(xcors_press_fa(rvector,:));
    rmean_xcorr(r).stimo{1,3} = nanmean(xcors_stimo_fa(rvector,:));
    rmean_xcorr(r).levre{1,3} = nanmean(xcors_levre_fa(rvector,:));
    rmean_xcorr(r).press{1,4} = nanmean(xcors_press_cr(rvector,:));
    rmean_xcorr(r).stimo{1,4} = nanmean(xcors_stimo_cr(rvector,:));
    rmean_xcorr(r).levre{1,4} = nanmean(xcors_levre_cr(rvector,:));
end
ripp_raster.mean_xcorr = rmean_xcorr;
save(['ripples_raster_SD_' num2str(SD) '.mat'],'ripp_raster','time_window','tw_units','centros','eje','-v7.3')
display('mily')

%%

clear;clc
SD = 5;

load(['C:\Users\neuro\Dropbox\SB\RESULTADOS\RIPPLES\ripples_raster_SD_' num2str(SD) '.mat'])


%%

for p = 1:size(ripp_raster.mean_xcorr,2)

figure(p)
subplot(3,2,1)
plot(eje/1000,ripp_raster.mean_xcorr(p).press{1,1},'k','linewidth',2)
title('Lever press','fontweight','demi')
ylim([0 max([max(ripp_raster.mean_xcorr(p).press{1,1}) ripp_raster.mean_xcorr(p).stimo{1,1} ripp_raster.mean_xcorr(p).levre{1,1}]) + 0.02])
xlim([-3 3])

subplot(3,2,3)
plot(eje/1000,ripp_raster.mean_xcorr(p).stimo{1,1},'k','linewidth',2)
title('Stimulus onset','fontweight','demi')
ylim([0 max([max(ripp_raster.mean_xcorr(p).press{1,1}) ripp_raster.mean_xcorr(p).stimo{1,1} ripp_raster.mean_xcorr(p).levre{1,1}]) + 0.02])
xlim([-3 3])

subplot(3,2,5)
plot(eje/1000,ripp_raster.mean_xcorr(p).levre{1,1},'k','linewidth',2)
set(gcf,'color','w')
title('Lever release','fontweight','demi')
ylim([0 max([max(ripp_raster.mean_xcorr(p).press{1,1}) ripp_raster.mean_xcorr(p).stimo{1,1} ripp_raster.mean_xcorr(p).levre{1,1}]) + 0.02])
xlim([-3 3])

% figure(2)
subplot(3,2,2)
plot(eje/1000,ripp_raster.mean_xcorr(p).press{1,2},'color',[0 .7 0],'linewidth',2)
hold on
plot(eje/1000,ripp_raster.mean_xcorr(p).press{1,3},'color',[.7 0 0],'linewidth',2)
plot(eje/1000,ripp_raster.mean_xcorr(p).press{1,4},'color',[0 0 .7],'linewidth',2)
hold off
title('Lever press','fontweight','demi')
ylim([0 max([max(ripp_raster.mean_xcorr(p).press{1,2}) max(ripp_raster.mean_xcorr(p).press{1,3}) max(ripp_raster.mean_xcorr(p).press{1,4}) ... 
    max(ripp_raster.mean_xcorr(p).stimo{1,2}) max(ripp_raster.mean_xcorr(p).stimo{1,3}) max(ripp_raster.mean_xcorr(p).stimo{1,4}) ...
    max(ripp_raster.mean_xcorr(p).levre{1,2}) max(ripp_raster.mean_xcorr(p).levre{1,3}) max(ripp_raster.mean_xcorr(p).levre{1,4})]) + 0.02])
xlim([-3 3])

subplot(3,2,4)
plot(eje/1000,ripp_raster.mean_xcorr(p).stimo{1,2},'color',[0 .7 0],'linewidth',2)
hold on
plot(eje/1000,ripp_raster.mean_xcorr(p).stimo{1,3},'color',[.7 0 0],'linewidth',2)
plot(eje/1000,ripp_raster.mean_xcorr(p).stimo{1,4},'color',[0 0 .7],'linewidth',2)
hold off
title('Lever press','fontweight','demi')
ylim([0 max([max(ripp_raster.mean_xcorr(p).press{1,2}) max(ripp_raster.mean_xcorr(p).press{1,3}) max(ripp_raster.mean_xcorr(p).press{1,4}) ... 
    max(ripp_raster.mean_xcorr(p).stimo{1,2}) max(ripp_raster.mean_xcorr(p).stimo{1,3}) max(ripp_raster.mean_xcorr(p).stimo{1,4}) ...
    max(ripp_raster.mean_xcorr(p).levre{1,2}) max(ripp_raster.mean_xcorr(p).levre{1,3}) max(ripp_raster.mean_xcorr(p).levre{1,4})]) + 0.02])
xlim([-3 3])

subplot(3,2,6)
plot(eje/1000,ripp_raster.mean_xcorr(p).levre{1,2},'color',[0 .7 0],'linewidth',2)
hold on
plot(eje/1000,ripp_raster.mean_xcorr(p).levre{1,3},'color',[.7 0 0],'linewidth',2)
plot(eje/1000,ripp_raster.mean_xcorr(p).levre{1,4},'color',[0 0 .7],'linewidth',2)
hold off
legend('HIT','FA','CR')
ylim([0 max([max(ripp_raster.mean_xcorr(p).press{1,2}) max(ripp_raster.mean_xcorr(p).press{1,3}) max(ripp_raster.mean_xcorr(p).press{1,4}) ... 
    max(ripp_raster.mean_xcorr(p).stimo{1,2}) max(ripp_raster.mean_xcorr(p).stimo{1,3}) max(ripp_raster.mean_xcorr(p).stimo{1,4}) ...
    max(ripp_raster.mean_xcorr(p).levre{1,2}) max(ripp_raster.mean_xcorr(p).levre{1,3}) max(ripp_raster.mean_xcorr(p).levre{1,4})]) + 0.02])
xlim([-3 3])
title('Lever release','fontweight','demi')
xlabel('Time (s)')
set(gcf,'color','w','Position',[100 70 840 680],'paperunits','points','PaperPosition',[100 70 840 680])
annotation('textbox', [0.45,0.9,0.1,0.1],'string',['   ' ripp_raster.mean_xcorr(p).rat]);

print(gcf,'-dtiff',['mean_xcorr_' ripp_raster.mean_xcorr(p).rat],'-r0')
close
end

%% PLOT ALL TRIALS
rat_str = cell(length(ripp_raster.info),1);
for i = 1:length(ripp_raster.info)
    rat_str{i,1} = ripp_raster.info{i,1}(11:14);
end
rv = strcmp(rat_str,'SB32');
rv = find(rv == 1);

%%
% ch = 1;
subplot(2,1,1)
for r = 1:size(rv,1)
plot((ripp_raster.press{rv(r),1}(1,:)-time_window/2)/1000,ripp_raster.press{rv(r),1}(2,:),'color','k','linestyle','none','marker','square','markerfacecolor',[0 0 0],'markersize',3);
hold on
end
title(ripp_raster.info{ch,2},'interpreter','none')
subplot(2,1,2)
plot(centros/1000,mean(ripp_raster.press{ch,2}),'k')
% plot(eje/1000,ripp_raster.press{ch,3},'k')
set(gcf,'color','w')
xlim([-3 3])
set(gcf,'color','w')
%%
for r = 1:size(rv,1)
    plot((ripp_raster.press{rv(r),1}(1,ripp_raster.press{rv(r),1}(3,:)==23)-time_window/2)/1000,(1:length(ripp_raster.press{rv(r),1}(1,ripp_raster.press{rv(r),1}(3,:)==23))),'color',[0 0 .8],'linestyle','none','marker','square','markerfacecolor',[0 0 .8],'markersize',3);
    hold on
    plot((ripp_raster.press{rv(r),1}(1,ripp_raster.press{rv(r),1}(3,:)==22)-time_window/2)/1000,(1:length(ripp_raster.press{rv(r),1}(1,ripp_raster.press{rv(r),1}(3,:)==22)))+length(ripp_raster.press{rv(r),1}(1,ripp_raster.press{rv(r),1}(3,:)==23))+1,'color',[.8 0 0],'linestyle','none','marker','square','markerfacecolor',[.8 0 0],'markersize',3);
    plot((ripp_raster.press{rv(r),1}(1,ripp_raster.press{rv(r),1}(3,:)==11)-time_window/2)/1000,(1:length(ripp_raster.press{rv(r),1}(1,ripp_raster.press{rv(r),1}(3,:)==11)))+length(ripp_raster.press{rv(r),1}(1,ripp_raster.press{rv(r),1}(3,:)==23))+length(ripp_raster.press{rv(r),1}(1,ripp_raster.press{rv(r),1}(3,:)==22))+1,'color',[0 .8 0],'linestyle','none','marker','square','markerfacecolor',[0 .8 0],'markersize',3);
end

%% PLOT HITS, FA AND CR
ch = 20;
subplot(2,1,1)
plot((ripp_raster.press{ch,1}(1,ripp_raster.press{ch,1}(3,:)==23)-time_window/2)/1000,(1:length(ripp_raster.press{ch,1}(1,ripp_raster.press{ch,1}(3,:)==23))),'color',[0 0 .8],'linestyle','none','marker','square','markerfacecolor',[0 0 .8],'markersize',3);
hold on
plot((ripp_raster.press{ch,1}(1,ripp_raster.press{ch,1}(3,:)==22)-time_window/2)/1000,(1:length(ripp_raster.press{ch,1}(1,ripp_raster.press{ch,1}(3,:)==22)))+length(ripp_raster.press{ch,1}(1,ripp_raster.press{ch,1}(3,:)==23))+1,'color',[.8 0 0],'linestyle','none','marker','square','markerfacecolor',[.8 0 0],'markersize',3);
plot((ripp_raster.press{ch,1}(1,ripp_raster.press{ch,1}(3,:)==11)-time_window/2)/1000,(1:length(ripp_raster.press{ch,1}(1,ripp_raster.press{ch,1}(3,:)==11)))+length(ripp_raster.press{ch,1}(1,ripp_raster.press{ch,1}(3,:)==23))+length(ripp_raster.press{ch,1}(1,ripp_raster.press{ch,1}(3,:)==22))+1,'color',[0 .8 0],'linestyle','none','marker','square','markerfacecolor',[0 .8 0],'markersize',3);

title(ripp_raster.info{ch,1},'interpreter','none')
hold off
xlim([-3 3])
set(gca,'ycolor','w','xcolor','w')

%%
subplot(2,1,2)
plot(centros,mean(ripp_raster.press{ch,2}),'k')
set(gcf,'color','w')
% set(gca,'ycolor','w','xcolor','w')

%%
for ws = 1:length(list)

% %%  %%%%%%%%%%%%%%%%% PLOT RASTER + PSTH ALL TRIALS %%%%%%%%%%%%%%%%%

dotsize = 2;

TTLarea_x = ((TTLline_press(1,:)/srate)-time_window/2);
TTLarea_y = vector;
TTLarea_press = cat(1,[TTLarea_x; TTLarea_y]', flipud([TTLarea_x+0.5; TTLarea_y]'));
clear TTLarea_x TTLarea_y

f = figure(ws);
sp(1) = subplot(2,3,1);
p(1) = plot((ripp_raster.press(1,:)/srate)-time_window/2,ripp_raster.press(2,:),'color','k','linestyle','none','marker','square','markerfacecolor',[0 0 0],'markersize',dotsize);
hold on
fi(1) = fill(TTLarea_press(:,1),TTLarea_press(:,2),[0 0 .8],'linestyle','none');
p(2) = plot((levreline_press(1,:)/srate)-time_window/2,vector,'color',[.5 0 .5],'linewidth',1);
p(3) = plot([(tw_pts/(2*srate))-time_window/2 (tw_pts/(2*srate))-time_window/2],[0 length(TTL(1,:))],'color',[.5 0 .5],'linewidth',2);
hold off
uistack(p(1), 'bottom',3)
ylim([1 length(TTL(1,:))])
title('centered in lever press','fontweight','normal','fontsize',14)
ylabel('\color[rgb]{0 0 0}Trial #','fontweight','demi','fontsize',16)

TTLarea_x = zeros(1,length(TTL(1,:)));
TTLarea_y = vector;
TTLarea_ttl = cat(1,[TTLarea_x; TTLarea_y]', flipud([TTLarea_x+0.5; TTLarea_y]'));
clear TTLarea_x TTLarea_y

sp(2) = subplot(2,3,2);
plot((ripp_raster.ttl(1,:)/srate)-time_window/2,ripp_raster.ttl(2,:),'color',[0 0 0],'linestyle','none','marker','s','markerfacecolor',[0 0 0],'markersize',dotsize)
hold on
plot((PRESSline_ttl(1,:)/srate)-time_window/2,vector,'color',[.5 0 .5],'linewidth',2)
plot((levreline_ttl(1,:)/srate)-time_window/2,vector,'color',[.5 0 .5],'linewidth',1)
fi(2) = fill(TTLarea_ttl(:,1),TTLarea_ttl(:,2),[0 0 .8],'linestyle','none');
plot([(tw_pts/(2*srate))-time_window/2 (tw_pts/(2*srate))-time_window/2],[0 length(TTL(1,:))],'color',[0 0 .8],'linewidth',2)
hold off
ylim([1 length(TTL(1,:))])
title('centered in stimulus onset','fontweight','normal','fontsize',14)

TTLarea_x = ((TTLline_levre(1,:)/srate)-time_window/2);
TTLarea_y = vector;
TTLarea_levre = cat(1,[TTLarea_x; TTLarea_y]', flipud([TTLarea_x+0.5; TTLarea_y]'));
clear TTLarea_x TTLarea_y

sp(3) = subplot(2,3,3);
plot((ripp_raster.levre(1,:)/srate)-time_window/2,ripp_raster.levre(2,:),'color',[0 0 0],'linestyle','none','marker','square','markerfacecolor',[0 0 0],'markersize',dotsize)
hold on
fi(3) = fill(TTLarea_levre(:,1),TTLarea_levre(:,2),[0 0 .8],'linestyle','none');
plot((PRESSline_levre(1,:)/srate)-time_window/2,vector,'color',[.5 0 .5],'linewidth',2)
plot([(tw_pts/(2*srate))-time_window/2 (tw_pts/(2*srate))-time_window/2],[0 length(TTL(1,:))],'color',[.5 0 .5],'linewidth',2)
hold off
ylim([1 length(TTL(1,:))])
title('centered in lever levre','fontweight','normal','fontsize',14)

% TTLarea_x = ((TTLline_rxnt(1,:)/srate)-time_window/2);
% TTLarea_y = vector;
% TTLarea_rxnt = cat(1,[TTLarea_x; TTLarea_y]', flipud([TTLarea_x+0.5; TTLarea_y]'));
% clear TTLarea_x TTLarea_y

% sp(4) = subplot(2,4,4);
% plot((ripp_raster.rxnt(1,:)/srate)-time_window/2,ripp_raster.rxnt(2,:),'color',[0 0 0],'linestyle','none','marker','square','markerfacecolor',[0 0 0],'markersize',dotsize)
% hold on
% fi(4) = fill(TTLarea_rxnt(:,1),TTLarea_rxnt(:,2),[0 0 .8],'linestyle','none');
% plot((PRESSline_rxnt(1,:)/srate)-time_window/2,vector,'color',[.5 0 .5],'linewidth',2)
% plot((levreline_rxnt(1,:)/srate)-time_window/2,vector,'color',[.5 0 .5],'linewidth',1)
% plot([(tw_pts/(2*srate))-time_window/2 (tw_pts/(2*srate))-time_window/2],[0 length(TTL(1,:))],'color',[.9 .9 0],'linewidth',2)
% hold off
% xlim([-3 1])
% ylim([1 length(TTL(1,:))])
% title('"centered" in reaction time','fontsize',14,'fontweight','normal')
set(sp(1:3),'box', 'off','fontweight','demi','ycolor','w','xcolor','w')

sp(4) = subplot(2,3,4);
plot(centros,smooth(mean(all_hist_press)),'color',[0 0 0],'linewidth',2)
hold on
% sin smooth
% fi(4) = fill([centros';flipud(centros')],[(mean(all_hist_press)' - ((std(all_hist_press,1))/(sqrt(length(all_hist_press(:,1)))))');flipud((mean(all_hist_press)' + ((std(all_hist_press,1))/sqrt(length(all_hist_press(:,1))))'))],[0 0 0],'linestyle','none');
% con smooth
fi(4) = fill([centros';flipud(centros')],[(smooth(mean(all_hist_press)) - (smooth(std(all_hist_press,1))/(sqrt(length(all_hist_press(:,1))))));flipud((smooth(mean(all_hist_press)) + (smooth(std(all_hist_press,1))/sqrt(length(all_hist_press(:,1))))))],[0 0 0],'linestyle','none');
plot([(tw_pts/(2*srate))-time_window/2 (tw_pts/(2*srate))-time_window/2],[0 max([max(mean(all_hist_ttl)),max(mean(all_hist_press)),max(mean(all_hist_press))])+3],'color',[.5 0 .5],'linewidth',2)
hold off
ylim([0 max([max(mean(all_hist_ttl(:,11:50))),max(mean(all_hist_press(:,11:50))),max(mean(levre(:,11:50)))])])
xlabel('time from lever press (s)','fontsize',14,'fontweight','normal')
ylabel(['firing rate (spikes/s)_{' num2str(bin*1000) 'ms bin}'],'fontsize',16,'fontweight','normal')

sp(5) = subplot(2,3,5);
plot(centros,smooth(mean(all_hist_ttl)),'color',[0 0 0],'linewidth',2)
hold on
% sin smooth
% fi(5) = fill([centros';flipud(centros')],[(mean(all_hist_ttl)' - ((std(all_hist_ttl,1))/(sqrt(length(all_hist_ttl(:,1)))))');flipud((mean(all_hist_ttl)' + ((std(all_hist_ttl,1))/sqrt(length(all_hist_ttl(:,1))))'))],[0 0 0],'linestyle','none');
% con smooth
fi(5) = fill([centros';flipud(centros')],[(smooth(mean(all_hist_ttl)) - (smooth(std(all_hist_ttl,1))/(sqrt(length(all_hist_ttl(:,1))))));flipud((smooth(mean(all_hist_ttl)) + (smooth(std(all_hist_ttl,1))/sqrt(length(all_hist_ttl(:,1))))))],[0 0 0],'linestyle','none');
plot([(tw_pts/(2*srate))-time_window/2 (tw_pts/(2*srate))-time_window/2],[0 max([max(mean(all_hist_ttl(:,11:50))),max(mean(all_hist_press(:,11:50))),max(mean(levre(:,11:50)))])+3],'color',[0 0 .8],'linewidth',2)
plot([(tw_pts/(2*srate))-time_window/2+0.5 (tw_pts/(2*srate))-time_window/2+0.5],[0 max([max(mean(all_hist_ttl(:,11:50))),max(mean(all_hist_press(:,11:50))),max(mean(levre(:,11:50)))])+3],'color',[0 0 .8],'linewidth',2)
hold off
ylim([0 max([max(mean(all_hist_ttl(:,11:50))),max(mean(all_hist_press(:,11:50))),max(mean(levre(:,11:50)))])])
xlabel('time from stimulus (s)','fontsize',14,'fontweight','normal')

sp(6) = subplot(2,3,6);
plot(centros,smooth(mean(levre)),'color',[0 0 0],'linewidth',2)
hold on
% sin smooth
% fi(6) = fill([centros';flipud(centros')],[(mean(all_hist_levre)' - ((std(all_hist_levre,1))/(sqrt(length(all_hist_levre(:,1)))))');flipud((mean(all_hist_levre)' + ((std(all_hist_levre,1))/sqrt(length(all_hist_levre(:,1))))'))],[0 0 0],'linestyle','none');
% con smooth
fi(6) = fill([centros';flipud(centros')],[(smooth(mean(levre)) - (smooth(std(levre,1))/(sqrt(length(levre(:,1))))));flipud((smooth(mean(levre)) + (smooth(std(levre,1))/sqrt(length(levre(:,1))))))],[0 0 0],'linestyle','none');
plot([(tw_pts/(2*srate))-time_window/2 (tw_pts/(2*srate))-time_window/2],[0 max([max(mean(all_hist_ttl(:,11:50))),max(mean(all_hist_press(:,11:50))),max(mean(levre(:,11:50)))])+3],'color',[.5 0 .5],'linewidth',2)
hold off
ylim([0 max([max(mean(all_hist_ttl(:,11:50))),max(mean(all_hist_press(:,11:50))),max(mean(levre(:,11:50)))])])
xlabel('time from lever levre (s)','fontsize',14,'fontweight','normal')
linkaxes(sp,'x') %linkaxes(sp([1,2,3,5,6,7]),'x')
xlim([-2 2])
set(sp([4,5,6]),'xtick',-2:1:2) %set(sp([5,6,7]),'xtick',-2:1:2)

% sp(8) = subplot(2,4,8);
% plot(centros,smooth(mean(all_hist_rxnt)),'color',[.6 0 0],'linewidth',2)
% hold on
% % sin smooth
% % fi(24) = fill([centros';flipud(centros')],[(mean(all_hist_rxnt)' - ((std(all_hist_rxnt,1))/(sqrt(length(all_hist_rxnt(:,1)))))');flipud((mean(all_hist_rxnt)' + ((std(all_hist_rxnt,1))/sqrt(length(all_hist_rxnt(:,1))))'))],[.6 0 0],'linestyle','none');
% % con smooth
% fi(24) = fill([centros';flipud(centros')],[(smooth(mean(all_hist_rxnt)) - (smooth(std(all_hist_rxnt,1))/(sqrt(length(all_hist_rxnt(:,1))))));flipud((smooth(mean(all_hist_rxnt)) + (smooth(std(all_hist_rxnt,1))/sqrt(length(all_hist_rxnt(:,1))))))],[.6 0 0],'linestyle','none');
% plot([(tw_pts/(2*srate))-time_window/2 (tw_pts/(2*srate))-time_window/2],[0 max([max(mean(all_hist_ttl(:,11:50))),max(mean(all_hist_press(:,11:50))),max(mean(all_hist_levre(:,11:50)))])+3],'color',[.9 .9 0],'linewidth',2)
% hold off
% xlim([-3 1])
% set(sp(8),'xtick',-3:1:1)
% ylim([0 max([max(mean(all_hist_ttl(:,11:50))),max(mean(all_hist_press(:,11:50))),max(mean(all_hist_levre(:,11:50)))])])
% xlabel('time from reaction time (s)','fontsize',14,'fontweight','normal')
hleg = legend(['ALL TRIALS (n = ' num2str(length(TTL(1,:))) ')']);
set(hleg,'box','off','position',[.85,.45,.1,.03],'fontsize',12,'fontweight','demi')

set(sp(5:6),'ycolor','w')
set(sp(4:6),'box','off','fontsize',18,'fontweight','normal')
linkaxes(sp([4,5,6]),'y') %linkaxes(sp([5,6,7,8]),'y')
alpha(fi,.3)
set(gcf,'color','w','Position', [0 50 2040 940],'paperunits','points','PaperPosition', [0 50 2040 940])

uistack(p(1), 'bottom',3)

fname = ['centros3_' list(ws).name(11:end-4) 'trials_dotsize_' num2str(dotsize) '_smooth'];
base_dir = ['C:\Users\pflab\Dropbox\VT\figuras_raster&PSTH_vt_dotsize_2_smooth\' db_dir{region,1}(38:end)];    % dirección base de la carpeta donde están todos los experimentos
cd(base_dir);  
print(f,'-dtiff',fname,'-r0')
close
cd(db_dir{region,1})

end


%%
%%    %%%%%%%%%%% GOs, NOGOf Y NOGOs SEPARADOS %%%%%%%%%%%%%
clc
clear
db_dir{1,1} = 'C:\Users\pflab\Dropbox\VT\WORKSPACES\CA1';
db_dir{2,1} = 'C:\Users\pflab\Dropbox\VT\WORKSPACES\CA3';
db_dir{3,1} = 'C:\Users\pflab\Dropbox\VT\WORKSPACES\CX';
db_dir{4,1} = 'C:\Users\pflab\Dropbox\VT\WORKSPACES\DG';
for region = 1:size(db_dir,1)
    cd(db_dir{region,1})
    list = dir('workspace*');
% ws = 42;
for ws = 12:length(list)

%   %%%%%%%%%%%%%%%% PSTH %%%%%%%%%%%%%%%%%

bin = 0.1; % bin (en segundos)
centros = (-time_window/2:bin:time_window/2);
centros = centros+bin/2;
centros = centros(1:end-1);

% NOGOs

NOGOs_hist_press = nan(length(trials_NOGOs),size(centros,2));
NOGOs_hist_ttl = nan(length(trials_NOGOs),size(centros,2));
NOGOs_hist_levre = nan(length(trials_NOGOs),size(centros,2));
NOGOs_hist_rxnt = nan(length(trials_NOGOs),size(centros,2));
for i = 1:length(trials_NOGOs)
    
    NOGOs_hist_press(i,:) = hist((ripp_raster.press_NOGOs(1,ripp_raster.press_NOGOs(2,:)==i)/srate)-time_window/2,centros);
    NOGOs_hist_ttl(i,:) = hist((ripp_raster.ttl_NOGOs(1,ripp_raster.ttl_NOGOs(2,:)==i)/srate)-time_window/2,centros);
    NOGOs_hist_levre(i,:) = hist((ripp_raster.levre_NOGOs(1,ripp_raster.levre_NOGOs(2,:)==i)/srate)-time_window/2,centros);
    NOGOs_hist_rxnt(i,:) = hist((ripp_raster.rxnt_NOGOs(1,ripp_raster.rxnt_NOGOs(2,:)==i)/srate)-time_window/2,centros);

end

% NOGOf

NOGOf_hist_press = nan(length(trials_NOGOf),size(centros,2));
NOGOf_hist_ttl = nan(length(trials_NOGOf),size(centros,2));
NOGOf_hist_levre = nan(length(trials_NOGOf),size(centros,2));
NOGOf_hist_rxnt = nan(length(trials_NOGOf),size(centros,2));
for i = 1:length(trials_NOGOf)
    
    NOGOf_hist_press(i,:) = hist(((ripp_raster.press_NOGOf(1,ripp_raster.press_NOGOf(2,:)==i+length(trials_NOGOs)+6))/srate)-time_window/2,centros);
    NOGOf_hist_ttl(i,:) = hist(((ripp_raster.ttl_NOGOf(1,ripp_raster.ttl_NOGOf(2,:)==i+length(trials_NOGOs)+6))/srate)-time_window/2,centros);
    NOGOf_hist_levre(i,:) = hist(((ripp_raster.levre_NOGOf(1,ripp_raster.levre_NOGOf(2,:)==i+length(trials_NOGOs)+6))/srate)-time_window/2,centros);
    NOGOf_hist_rxnt(i,:) = hist(((ripp_raster.rxnt_NOGOf(1,ripp_raster.rxnt_NOGOf(2,:)==i+length(trials_NOGOs)+6))/srate)-time_window/2,centros);

end

% GOs

GOs_hist_press = nan(length(trials_GOs),size(centros,2));
GOs_hist_ttl = nan(length(trials_GOs),size(centros,2));
GOs_hist_levre = nan(length(trials_GOs),size(centros,2));
GOs_hist_rxnt = nan(length(trials_GOs),size(centros,2));
for i = 1:length(trials_GOs)
    
    GOs_hist_press(i,:) = hist(((ripp_raster.press_GOs(1,ripp_raster.press_GOs(2,:)==i+length(trials_NOGOf)+length(trials_NOGOs)+6))/srate)-time_window/2,centros);
    GOs_hist_ttl(i,:) = hist(((ripp_raster.ttl_GOs(1,ripp_raster.ttl_GOs(2,:)==i+length(trials_NOGOf)+length(trials_NOGOs)+6))/srate)-time_window/2,centros);
    GOs_hist_levre(i,:) = hist(((ripp_raster.levre_GOs(1,ripp_raster.levre_GOs(2,:)==i+length(trials_NOGOf)+length(trials_NOGOs)+6))/srate)-time_window/2,centros);
    GOs_hist_rxnt(i,:) = hist(((ripp_raster.rxnt_GOs(1,ripp_raster.rxnt_GOs(2,:)==i+length(trials_NOGOf)+length(trials_NOGOs)+6))/srate)-time_window/2,centros);
    
end

%  %%%%%%%%%%%%%%%%% plot raster + linea PSTH GOs+NOGOf+NOGOs %%%%%%%%%%%%%%%%%

dotsize = 2;

TTLarea_x = ((ripp_raster.press_GOs(3,:)/srate)-time_window/2);
TTLarea_y = ripp_raster.press_GOs(2,:);
[ind1,ind,~] = unique(ripp_raster.press_GOs(2,:));
ind = ind(1:length(nonzeros(~isnan(ind1))));
TTLarea_press_GOs = cat(1,[TTLarea_x(ind); TTLarea_y(ind)]', flipud([TTLarea_x(ind)+0.5; TTLarea_y(ind)]'));

TTLarea_x = ((ripp_raster.press_NOGOf(3,:)/srate)-time_window/2);
TTLarea_y = ripp_raster.press_NOGOf(2,:);
[ind1,ind,~] = unique(ripp_raster.press_NOGOf(2,:));
ind = ind(1:length(nonzeros(~isnan(ind1))));
TTLarea_press_NOGOf = cat(1,[TTLarea_x(ind); TTLarea_y(ind)]', flipud([TTLarea_x(ind)+0.5; TTLarea_y(ind)]'));

TTLarea_x = ((ripp_raster.press_NOGOs(3,:)/srate)-time_window/2);
TTLarea_y = ripp_raster.press_NOGOs(2,:);
[ind1,ind,~] = unique(ripp_raster.press_NOGOs(2,:));
ind = ind(1:length(nonzeros(~isnan(ind1))));
TTLarea_press_NOGOs = cat(1,[TTLarea_x(ind); TTLarea_y(ind)]', flipud([TTLarea_x(ind)+0.5; TTLarea_y(ind)]'));
clear TTLarea_x TTLarea_y

f = figure(ws);
sp(1) = subplot(2,3,1);
p(1) = plot((ripp_raster.press_GOs(1,:)/srate)-time_window/2,ripp_raster.press_GOs(2,:),'color',[0 .5 0],'linestyle','none','marker','square','markerfacecolor',[0 .5 0],'markersize',dotsize);
hold on
p(2) = plot((ripp_raster.press_NOGOf(1,:)/srate)-time_window/2,ripp_raster.press_NOGOf(2,:),'color',[.9 0 0],'linestyle','none','marker','square','markerfacecolor',[.9 0 0],'markersize',dotsize);
p(3) = plot((ripp_raster.press_NOGOs(1,:)/srate)-time_window/2,ripp_raster.press_NOGOs(2,:),'color',[.6 0 0],'linestyle','none','marker','square','markerfacecolor',[.5 0 0],'markersize',dotsize);
fi(1) = fill(TTLarea_press_GOs(:,1),TTLarea_press_GOs(:,2),[0 0 .8],'linestyle','none');
p(5) = plot((ripp_raster.press_GOs(4,:)/srate)-time_window/2,ripp_raster.press_GOs(2,:),'color',[.5 0 .5],'linewidth',1);
p(6) = plot((ripp_raster.press_GOs(5,:)/srate)-time_window/2,ripp_raster.press_GOs(2,:),'color',[0 0 0],'linewidth',1);
fi(2) = fill(TTLarea_press_NOGOf(:,1),TTLarea_press_NOGOf(:,2),[0 0 .8],'linestyle','none');
p(8) = plot((ripp_raster.press_NOGOf(4,:)/srate)-time_window/2,ripp_raster.press_NOGOf(2,:),'color',[.5 0 .5],'linewidth',1);
p(9) = plot((ripp_raster.press_NOGOf(5,:)/srate)-time_window/2,ripp_raster.press_NOGOf(2,:),'color',[0 0 0],'linewidth',1);
fi(3) = fill(TTLarea_press_NOGOs(:,1),TTLarea_press_NOGOs(:,2),[0 0 .8],'linestyle','none');
p(11) = plot((ripp_raster.press_NOGOs(4,:)/srate)-time_window/2,ripp_raster.press_NOGOs(2,:),'color',[.5 0 .5],'linewidth',1);
p(12) = plot([(tw_pts/(2*srate))-time_window/2 (tw_pts/(2*srate))-time_window/2],[0 (length(trials_GOs)+length(trials_NOGOs)+length(trials_NOGOf))],'color',[.5 0 .5],'linewidth',2);
% % p(13) = plot((ripp_raster.press_GOs(7,:)/srate)-time_window/2,ripp_raster.press_GOs(2,:),'color',[0 0 0],'linewidth',1);
% p(14) = plot((ripp_raster.press_NOGOf(7,:)/srate)-time_window/2,ripp_raster.press_NOGOf(2,:),'color',[0 0 0],'linewidth',1);
% p(15) = plot((ripp_raster.press_NOGOs(7,:)/srate)-time_window/2,ripp_raster.press_NOGOs(2,:),'color',[0 0 0],'linewidth',1);
hold off
ylim([1 (length(trials_GOs)+length(trials_NOGOs)+length(trials_NOGOf))])
title('centered in lever press','fontweight','normal','fontsize',14)
ylabel(' \color[rgb]{.6 0 0}CR             \color[rgb]{.9 0 0}FA                     \color[rgb]{0 .5 0}HIT     ','fontweight','demi','fontsize',10)

TTLarea_x = zeros(1,length(trials_GOs));
TTLarea_y = unique(ripp_raster.press_GOs(2,:));
TTLarea_ttl_GOs = cat(1,[TTLarea_x; TTLarea_y]', flipud([TTLarea_x+0.5; TTLarea_y]'));

TTLarea_x = zeros(1,length(trials_NOGOf));
TTLarea_y = unique(ripp_raster.press_NOGOf(2,:));
TTLarea_ttl_NOGOf = cat(1,[TTLarea_x; TTLarea_y]', flipud([TTLarea_x+0.5; TTLarea_y]'));

TTLarea_x = zeros(1,length(trials_NOGOs));
TTLarea_y = unique(ripp_raster.press_NOGOs(2,:));
TTLarea_ttl_NOGOs = cat(1,[TTLarea_x; TTLarea_y]', flipud([TTLarea_x+0.5; TTLarea_y]'));
clear TTLarea_x TTLarea_y

sp(2) = subplot(2,3,2);
plot((ripp_raster.ttl_GOs(1,:)/srate)-time_window/2,ripp_raster.ttl_GOs(2,:),'color',[0 .5 0],'linestyle','none','marker','s','markerfacecolor',[0 .5 0],'markersize',dotsize)
hold on
plot((ripp_raster.ttl_NOGOf(1,:)/srate)-time_window/2,ripp_raster.ttl_NOGOf(2,:),'color',[.9 0 0],'linestyle','none','marker','s','markerfacecolor',[.9 0 0],'markersize',dotsize)
plot((ripp_raster.ttl_NOGOs(1,:)/srate)-time_window/2,ripp_raster.ttl_NOGOs(2,:),'color',[.6 0 0],'linestyle','none','marker','s','markerfacecolor',[.5 0 0],'markersize',dotsize)
plot((ripp_raster.ttl_GOs(3,:)/srate)-time_window/2,ripp_raster.ttl_GOs(2,:),'color',[.5 0 .5],'linewidth',2)
plot((ripp_raster.ttl_GOs(4,:)/srate)-time_window/2,ripp_raster.ttl_GOs(2,:),'color',[.5 0 .5],'linewidth',1)
plot((ripp_raster.ttl_GOs(5,:)/srate)-time_window/2,ripp_raster.ttl_GOs(2,:),'color',[0 0 0],'linewidth',1)
plot((ripp_raster.ttl_NOGOf(3,:)/srate)-time_window/2,ripp_raster.ttl_NOGOf(2,:),'color',[.5 0 .5],'linewidth',2)
plot((ripp_raster.ttl_NOGOf(4,:)/srate)-time_window/2,ripp_raster.ttl_NOGOf(2,:),'color',[.5 0 .5],'linewidth',1)
plot((ripp_raster.ttl_NOGOf(5,:)/srate)-time_window/2,ripp_raster.ttl_NOGOf(2,:),'color',[0 0 0],'linewidth',1)
plot((ripp_raster.ttl_NOGOs(3,:)/srate)-time_window/2,ripp_raster.ttl_NOGOs(2,:),'color',[.5 0 .5],'linewidth',2)
plot((ripp_raster.ttl_NOGOs(4,:)/srate)-time_window/2,ripp_raster.ttl_NOGOs(2,:),'color',[.5 0 .5],'linewidth',1)
fi(4) = fill(TTLarea_ttl_GOs(:,1),TTLarea_ttl_GOs(:,2),[0 0 .8],'linestyle','none');
fi(5) = fill(TTLarea_ttl_NOGOf(:,1),TTLarea_ttl_NOGOf(:,2),[0 0 .8],'linestyle','none');
fi(6) = fill(TTLarea_ttl_NOGOs(:,1),TTLarea_ttl_NOGOs(:,2),[0 0 .8],'linestyle','none');
plot((ripp_raster.ttl_GOs(7,:)/srate)-time_window/2,ripp_raster.ttl_GOs(2,:),'color',[0 0 0],'linewidth',1);
plot((ripp_raster.ttl_NOGOf(7,:)/srate)-time_window/2,ripp_raster.ttl_NOGOf(2,:),'color',[0 0 0],'linewidth',1);
plot((ripp_raster.ttl_NOGOs(7,:)/srate)-time_window/2,ripp_raster.ttl_NOGOs(2,:),'color',[0 0 0],'linewidth',1);
plot([(tw_pts/(2*srate))-time_window/2 (tw_pts/(2*srate))-time_window/2],[0 max(ripp_raster.press_GOs(2,:))],'color',[0 0 .8],'linewidth',2)
hold off
ylim([1 (length(trials_GOs)+length(trials_NOGOs)+length(trials_NOGOf))])
title('centered in TTL','fontweight','normal','fontsize',14)

TTLarea_x = ((ripp_raster.levre_GOs(3,:)/srate)-time_window/2);
TTLarea_y = ripp_raster.levre_GOs(2,:);
[ind1,ind,~] = unique(ripp_raster.levre_GOs(2,:));
ind = ind(1:length(nonzeros(~isnan(ind1))));
TTLarea_levre_GOs = cat(1,[TTLarea_x(ind); TTLarea_y(ind)]', flipud([TTLarea_x(ind)+0.5; TTLarea_y(ind)]'));

TTLarea_x = ((ripp_raster.levre_NOGOf(3,:)/srate)-time_window/2);
TTLarea_y = ripp_raster.levre_NOGOf(2,:);
[ind1,ind,~] = unique(ripp_raster.levre_NOGOf(2,:));
ind = ind(1:length(nonzeros(~isnan(ind1))));
TTLarea_levre_NOGOf = cat(1,[TTLarea_x(ind); TTLarea_y(ind)]', flipud([TTLarea_x(ind)+0.5; TTLarea_y(ind)]'));

TTLarea_x = ((ripp_raster.levre_NOGOs(3,:)/srate)-time_window/2);
TTLarea_y = ripp_raster.levre_NOGOs(2,:);
[ind1,ind,~] = unique(ripp_raster.levre_NOGOs(2,:));
ind = ind(1:length(nonzeros(~isnan(ind1))));
TTLarea_levre_NOGOs = cat(1,[TTLarea_x(ind); TTLarea_y(ind)]', flipud([TTLarea_x(ind)+0.5; TTLarea_y(ind)]'));
clear TTLarea_x TTLarea_y

sp(3) = subplot(2,3,3);
plot((ripp_raster.levre_GOs(1,:)/srate)-time_window/2,ripp_raster.levre_GOs(2,:),'color',[0 .5 0],'linestyle','none','marker','square','markerfacecolor',[0 .5 0],'markersize',dotsize)
hold on
plot((ripp_raster.levre_NOGOf(1,:)/srate)-time_window/2,ripp_raster.levre_NOGOf(2,:),'color',[.9 0 0],'linestyle','none','marker','square','markerfacecolor',[.9 0 0],'markersize',dotsize)
plot((ripp_raster.levre_NOGOs(1,:)/srate)-time_window/2,ripp_raster.levre_NOGOs(2,:),'color',[.6 0 0],'linestyle','none','marker','square','markerfacecolor',[.5 0 0],'markersize',dotsize)
fi(7) = fill(TTLarea_levre_GOs(:,1),TTLarea_levre_GOs(:,2),[0 0 .8],'linestyle','none');
plot((ripp_raster.levre_GOs(4,:)/srate)-time_window/2,ripp_raster.levre_GOs(2,:),'color',[.5 0 .5],'linewidth',1)
fi(8) = fill(TTLarea_levre_NOGOf(:,1),TTLarea_levre_NOGOf(:,2),[0 0 .8],'linestyle','none');
plot((ripp_raster.levre_NOGOf(4,:)/srate)-time_window/2,ripp_raster.levre_NOGOf(2,:),'color',[.5 0 .5],'linewidth',1)
fi(9) = fill(TTLarea_levre_NOGOs(:,1),TTLarea_levre_NOGOs(:,2),[0 0 .8],'linestyle','none');
plot((ripp_raster.levre_GOs(7,:)/srate)-time_window/2,ripp_raster.levre_GOs(2,:),'color',[0 0 0],'linewidth',1);
plot((ripp_raster.levre_NOGOf(7,:)/srate)-time_window/2,ripp_raster.levre_NOGOf(2,:),'color',[0 0 0],'linewidth',1);
plot((ripp_raster.levre_NOGOs(7,:)/srate)-time_window/2,ripp_raster.levre_NOGOs(2,:),'color',[0 0 0],'linewidth',1);
plot((ripp_raster.levre_NOGOs(4,:)/srate)-time_window/2,ripp_raster.levre_NOGOs(2,:),'color',[.5 0 .5],'linewidth',1)
plot([(tw_pts/(2*srate))-time_window/2 (tw_pts/(2*srate))-time_window/2],[0 (length(trials_GOs)+length(trials_NOGOs)+length(trials_NOGOf))],'color',[.5 0 .5],'linewidth',2)
hold off
ylim([1 (length(trials_GOs)+length(trials_NOGOs)+length(trials_NOGOf))])
title('centered in lever levre','fontweight','normal','fontsize',14)

TTLarea_x = ((ripp_raster.rxnt_GOs(3,:)/srate)-time_window/2);
TTLarea_y = ripp_raster.rxnt_GOs(2,:);
[ind1,ind,~] = unique(ripp_raster.rxnt_GOs(2,:));
ind = ind(1:length(nonzeros(~isnan(ind1))));
TTLarea_rxnt_GOs = cat(1,[TTLarea_x(ind); TTLarea_y(ind)]', flipud([TTLarea_x(ind)+0.5; TTLarea_y(ind)]'));

TTLarea_x = ((ripp_raster.rxnt_NOGOf(3,:)/srate)-time_window/2);
TTLarea_y = ripp_raster.rxnt_NOGOf(2,:);
[ind1,ind,~] = unique(ripp_raster.rxnt_NOGOf(2,:));
ind = ind(1:length(nonzeros(~isnan(ind1))));
TTLarea_rxnt_NOGOf = cat(1,[TTLarea_x(ind); TTLarea_y(ind)]', flipud([TTLarea_x(ind)+0.5; TTLarea_y(ind)]'));

TTLarea_x = ((ripp_raster.rxnt_NOGOs(3,:)/srate)-time_window/2);
TTLarea_y = ripp_raster.rxnt_NOGOs(2,:);
[ind1,ind,~] = unique(ripp_raster.rxnt_NOGOs(2,:));
ind = ind(1:length(nonzeros(~isnan(ind1))));
TTLarea_rxnt_NOGOs = cat(1,[TTLarea_x(ind); TTLarea_y(ind)]', flipud([TTLarea_x(ind)+0.5; TTLarea_y(ind)]'));
clear TTLarea_x TTLarea_y

% sp(4) = subplot(2,4,4);
% plot((ripp_raster.rxnt_GOs(1,:)/srate)-time_window/2,ripp_raster.rxnt_GOs(2,:),'color',[0 .5 0],'linestyle','none','marker','square','markerfacecolor',[0 .5 0],'markersize',dotsize)
% hold on
% plot((ripp_raster.rxnt_NOGOf(1,:)/srate)-time_window/2,ripp_raster.rxnt_NOGOf(2,:),'color',[.9 0 0],'linestyle','none','marker','square','markerfacecolor',[.9 0 0],'markersize',dotsize)
% plot((ripp_raster.rxnt_NOGOs(1,:)/srate)-time_window/2,ripp_raster.rxnt_NOGOs(2,:),'color',[.6 0 0],'linestyle','none','marker','square','markerfacecolor',[.5 0 0],'markersize',dotsize)
% fi(10) = fill(TTLarea_rxnt_GOs(:,1),TTLarea_rxnt_GOs(:,2),[0 0 .8],'linestyle','none');
% plot((ripp_raster.rxnt_GOs(4,:)/srate)-time_window/2,ripp_raster.rxnt_GOs(2,:),'color',[.5 0 .5],'linewidth',2)
% plot((ripp_raster.rxnt_GOs(5,:)/srate)-time_window/2,ripp_raster.rxnt_GOs(2,:),'color',[.5 0 .5],'linewidth',1)
% fi(11) = fill(TTLarea_rxnt_NOGOf(:,1),TTLarea_rxnt_NOGOf(:,2),[0 0 .8],'linestyle','none');
% plot((ripp_raster.rxnt_NOGOf(4,:)/srate)-time_window/2,ripp_raster.rxnt_NOGOf(2,:),'color',[.5 0 .5],'linewidth',2)
% plot((ripp_raster.rxnt_NOGOf(5,:)/srate)-time_window/2,ripp_raster.rxnt_NOGOf(2,:),'color',[.5 0 .5],'linewidth',1)
% fi(12) = fill(TTLarea_rxnt_NOGOs(:,1),TTLarea_rxnt_NOGOs(:,2),[0 0 .8],'linestyle','none');
% plot((ripp_raster.rxnt_NOGOs(4,:)/srate)-time_window/2,ripp_raster.rxnt_NOGOs(2,:),'color',[.5 0 .5],'linewidth',2)
% plot((ripp_raster.rxnt_NOGOs(5,:)/srate)-time_window/2,ripp_raster.rxnt_NOGOs(2,:),'color',[.5 0 .5],'linewidth',1)
% plot((ripp_raster.rxnt_GOs(7,:)/srate)-time_window/2,ripp_raster.rxnt_GOs(2,:),'color',[0 0 0],'linewidth',1);
% plot((ripp_raster.rxnt_NOGOf(7,:)/srate)-time_window/2,ripp_raster.rxnt_NOGOf(2,:),'color',[0 0 0],'linewidth',1);
% plot((ripp_raster.rxnt_NOGOs(7,:)/srate)-time_window/2,ripp_raster.rxnt_NOGOs(2,:),'color',[0 0 0],'linewidth',1);
% plot([(tw_pts/(2*srate))-time_window/2 (tw_pts/(2*srate))-time_window/2],[0 (length(trials_GOs)+length(trials_NOGOs)+length(trials_NOGOf))],'color',[.9 .9 0],'linewidth',2)
% hold off
% xlim([-3 1])
% ylim([1 (length(trials_GOs)+length(trials_NOGOs)+length(trials_NOGOf))])
% title('"centered" in reaction time','fontsize',14,'fontweight','normal')

set(sp(1:3),'box', 'off','fontweight','demi','ycolor','w','xcolor','w')

sp(4) = subplot(2,3,4);
plot(centros,smooth(mean(GOs_hist_press)/bin),'color',[0 .5 0],'linewidth',2)
hold on
plot(centros,smooth(mean(NOGOf_hist_press)/bin),'color',[.9 0 0],'linewidth',2)
plot(centros,smooth(mean(NOGOs_hist_press)/bin),'color',[.6 0 0],'linewidth',2)
% % sin smooth
% fi(13) = fill([centros';flipud(centros')],[(mean(GOs_hist_press)'/bin - ((std(GOs_hist_press,1)/bin)/(sqrt(length(GOs_hist_press(:,1)))))');flipud((mean(GOs_hist_press)'/bin + ((std(GOs_hist_press,1)/bin)/sqrt(length(GOs_hist_press(:,1))))'))],[0 .5 0],'linestyle','none');
% fi(14) = fill([centros';flipud(centros')],[(mean(NOGOf_hist_press)'/bin - ((std(NOGOf_hist_press,1)/bin)/(sqrt(length(NOGOf_hist_press(:,1)))))');flipud((mean(NOGOf_hist_press)'/bin + ((std(NOGOf_hist_press,1))/bin/sqrt(length(NOGOf_hist_press(:,1))))'))],[.9 0 0],'linestyle','none');
% fi(15) = fill([centros';flipud(centros')],[(mean(NOGOs_hist_press)'/bin - ((std(NOGOs_hist_press,1)/bin)/(sqrt(length(NOGOs_hist_press(:,1)))))');flipud((mean(NOGOs_hist_press)'/bin + ((std(NOGOs_hist_press,1))/bin/sqrt(length(NOGOs_hist_press(:,1))))'))],[.6 0 0],'linestyle','none');
% % con smooth
try
fi(10) = fill([centros';flipud(centros')],[(smooth(mean(GOs_hist_press)/bin) - (smooth(std(GOs_hist_press,1)/bin)/(sqrt(length(GOs_hist_press(:,1))))));flipud((smooth(mean(GOs_hist_press)/bin) + (smooth(std(GOs_hist_press,1)/bin)/sqrt(length(GOs_hist_press(:,1))))))],[0 .5 0],'linestyle','none');
end
try
fi(11) = fill([centros';flipud(centros')],[(smooth(mean(NOGOf_hist_press)/bin) - (smooth(std(NOGOf_hist_press,1)/bin)/(sqrt(length(NOGOf_hist_press(:,1))))));flipud((smooth(mean(NOGOf_hist_press)/bin) + (smooth(std(NOGOf_hist_press,1)/bin)/sqrt(length(NOGOf_hist_press(:,1))))))],[.9 0 0],'linestyle','none');
end
try
fi(12) = fill([centros';flipud(centros')],[(smooth(mean(NOGOs_hist_press)/bin) - (smooth(std(NOGOs_hist_press,1)/bin)/(sqrt(length(NOGOs_hist_press(:,1))))));flipud((smooth(mean(NOGOs_hist_press)/bin) + (smooth(std(NOGOs_hist_press,1)/bin)/sqrt(length(NOGOs_hist_press(:,1))))))],[.6 0 0],'linestyle','none');
end
plot([(tw_pts/(2*srate))-time_window/2 (tw_pts/(2*srate))-time_window/2],[0 max([max(mean(GOs_hist_ttl)/bin),max(mean(NOGOs_hist_ttl)/bin),max(mean(NOGOf_hist_ttl)/bin),max(mean(GOs_hist_press)/bin),max(mean(NOGOs_hist_press)/bin),max(mean(NOGOf_hist_press)/bin),max(mean(GOs_hist_press)/bin),max(mean(NOGOs_hist_press)/bin),max(mean(NOGOf_hist_press)/bin)])+3],'color',[.5 0 .5],'linewidth',2)
hold off
ylim([0 max([max(mean(GOs_hist_ttl(:,11:50))/bin),max(mean(NOGOs_hist_ttl(:,11:50))/bin),max(mean(NOGOf_hist_ttl(:,11:50))/bin),max(mean(GOs_hist_press(:,11:50))/bin),max(mean(NOGOs_hist_press(:,11:50))/bin),max(mean(NOGOf_hist_press(:,11:50))/bin),max(mean(GOs_hist_levre(:,11:50))/bin),max(mean(NOGOs_hist_levre(:,11:50))/bin),max(mean(NOGOf_hist_levre(:,11:50))/bin)])])
xlabel('time from lever press (s)','fontsize',14,'fontweight','normal')
ylabel(['firing rate (spikes/s)_{' num2str(bin*1000) 'ms bin}'],'fontsize',16,'fontweight','normal')

sp(5) = subplot(2,3,5);
plot(centros,smooth(mean(GOs_hist_ttl)/bin),'color',[0 .5 0],'linewidth',2)
hold on
plot(centros,smooth(mean(NOGOf_hist_ttl)/bin),'color',[.9 0 0],'linewidth',2)
plot(centros,smooth(mean(NOGOs_hist_ttl)/bin),'color',[.6 0 0],'linewidth',2)
% % sin smooth
% % fi(16) = fill([centros';flipud(centros')],[(mean(GOs_hist_ttl)'/bin - ((std(GOs_hist_ttl,1)/bin)/(sqrt(length(GOs_hist_ttl(:,1)))))');flipud((mean(GOs_hist_ttl)'/bin + ((std(GOs_hist_ttl,1)/bin)/sqrt(length(GOs_hist_ttl(:,1))))'))],[0 .5 0],'linestyle','none');
% % fi(17) = fill([centros';flipud(centros')],[(mean(NOGOf_hist_ttl)'/bin - ((std(NOGOf_hist_ttl,1)/bin)/(sqrt(length(NOGOf_hist_ttl(:,1)))))');flipud((mean(NOGOf_hist_ttl)'/bin + ((std(NOGOf_hist_ttl,1)/bin)/sqrt(length(NOGOf_hist_ttl(:,1))))'))],[.9 0 0],'linestyle','none');
% % fi(18) = fill([centros';flipud(centros')],[(mean(NOGOs_hist_ttl)'/bin - ((std(NOGOs_hist_ttl,1)/bin)/(sqrt(length(NOGOs_hist_ttl(:,1)))))');flipud((mean(NOGOs_hist_ttl)'/bin + ((std(NOGOs_hist_ttl,1)/bin)/sqrt(length(NOGOs_hist_ttl(:,1))))'))],[.6 0 0],'linestyle','none');
% % con smooth
try
fi(13) = fill([centros';flipud(centros')],[(smooth(mean(GOs_hist_ttl)/bin) - (smooth(std(GOs_hist_ttl,1)/bin)/(sqrt(length(GOs_hist_ttl(:,1))))));flipud((smooth(mean(GOs_hist_ttl)/bin) + (smooth(std(GOs_hist_ttl,1)/bin)/sqrt(length(GOs_hist_ttl(:,1))))))],[0 .5 0],'linestyle','none');
end
try
fi(14) = fill([centros';flipud(centros')],[(smooth(mean(NOGOf_hist_ttl)/bin) - (smooth(std(NOGOf_hist_ttl,1)/bin)/(sqrt(length(NOGOf_hist_ttl(:,1))))));flipud((smooth(mean(NOGOf_hist_ttl)/bin) + (smooth(std(NOGOf_hist_ttl,1)/bin)/sqrt(length(NOGOf_hist_ttl(:,1))))))],[.9 0 0],'linestyle','none');
end
try
fi(15) = fill([centros';flipud(centros')],[(smooth(mean(NOGOs_hist_ttl)/bin) - (smooth(std(NOGOs_hist_ttl,1)/bin)/(sqrt(length(NOGOs_hist_ttl(:,1))))));flipud((smooth(mean(NOGOs_hist_ttl)/bin) + (smooth(std(NOGOs_hist_ttl,1)/bin)/sqrt(length(NOGOs_hist_ttl(:,1))))))],[.6 0 0],'linestyle','none');
end
plot([(tw_pts/(2*srate))-time_window/2 (tw_pts/(2*srate))-time_window/2],[0 max([max(mean(GOs_hist_ttl)/bin),max(mean(NOGOs_hist_ttl)/bin),max(mean(NOGOf_hist_ttl)/bin),max(mean(GOs_hist_press)/bin),max(mean(NOGOs_hist_press)/bin),max(mean(NOGOf_hist_press)/bin)])+3],'color',[0 0 .8],'linewidth',2)
plot([(tw_pts/(2*srate))-time_window/2+0.5 (tw_pts/(2*srate))-time_window/2+0.5],[0 max([max(mean(GOs_hist_ttl)/bin),max(mean(NOGOs_hist_ttl)/bin),max(mean(NOGOf_hist_ttl)/bin),max(mean(GOs_hist_press)/bin),max(mean(NOGOs_hist_press)/bin),max(mean(NOGOf_hist_press)/bin)])+3],'color',[0 0 .8],'linewidth',2)
hold off
ylim([0 max([max(mean(GOs_hist_ttl(:,11:50))/bin),max(mean(NOGOs_hist_ttl(:,11:50))/bin),max(mean(NOGOf_hist_ttl(:,11:50))/bin),max(mean(GOs_hist_press(:,11:50))/bin),max(mean(NOGOs_hist_press(:,11:50))/bin),max(mean(NOGOf_hist_press(:,11:50))/bin),max(mean(GOs_hist_levre(:,11:50))/bin),max(mean(NOGOs_hist_levre(:,11:50))/bin),max(mean(NOGOf_hist_levre(:,11:50))/bin)])])
xlabel('time from stimulus (s)','fontsize',14,'fontweight','normal')

sp(6) = subplot(2,3,6);
plot(centros,smooth(mean(GOs_hist_levre)/bin),'color',[0 .5 0],'linewidth',2)
hold on
plot(centros,smooth(mean(NOGOf_hist_levre)/bin),'color',[.9 0 0],'linewidth',2)
plot(centros,smooth(mean(NOGOs_hist_levre)/bin),'color',[.6 0 0],'linewidth',2)
% % sin smooth
% % fi(19) = fill([centros';flipud(centros')],[(mean(GOs_hist_levre)'/bin - ((std(GOs_hist_levre,1)/bin)/(sqrt(length(GOs_hist_levre(:,1)))))');flipud((mean(GOs_hist_levre)'/bin + ((std(GOs_hist_levre,1)/bin)/sqrt(length(GOs_hist_levre(:,1))))'))],[0 .5 0],'linestyle','none');
% % fi(20) = fill([centros';flipud(centros')],[(mean(NOGOf_hist_levre)'/bin - ((std(NOGOf_hist_levre,1)/bin)/(sqrt(length(NOGOf_hist_levre(:,1)))))');flipud((mean(NOGOf_hist_levre)'/bin + ((std(NOGOf_hist_levre,1)/bin)/sqrt(length(NOGOf_hist_levre(:,1))))'))],[.9 0 0],'linestyle','none');
% % fi(21) = fill([centros';flipud(centros')],[(mean(NOGOs_hist_levre)'/bin - ((std(NOGOs_hist_levre,1)/bin)/(sqrt(length(NOGOs_hist_levre(:,1)))))');flipud((mean(NOGOs_hist_levre)'/bin + ((std(NOGOs_hist_levre,1)/bin)/sqrt(length(NOGOs_hist_levre(:,1))))'))],[.6 0 0],'linestyle','none');
% % con smooth
try
fi(16) = fill([centros';flipud(centros')],[(smooth(mean(GOs_hist_levre)/bin) - (smooth(std(GOs_hist_levre,1)/bin)/(sqrt(length(GOs_hist_levre(:,1))))));flipud((smooth(mean(GOs_hist_levre)/bin) + (smooth(std(GOs_hist_levre,1)/bin)/sqrt(length(GOs_hist_levre(:,1))))))],[0 .5 0],'linestyle','none');
end
try
fi(17) = fill([centros';flipud(centros')],[(smooth(mean(NOGOf_hist_levre)/bin) - (smooth(std(NOGOf_hist_levre,1)/bin)/(sqrt(length(NOGOf_hist_levre(:,1))))));flipud((smooth(mean(NOGOf_hist_levre)/bin) + (smooth(std(NOGOf_hist_levre,1)/bin)/sqrt(length(NOGOf_hist_levre(:,1))))))],[.9 0 0],'linestyle','none');
end
try
fi(18) = fill([centros';flipud(centros')],[(smooth(mean(NOGOs_hist_levre)/bin) - (smooth(std(NOGOs_hist_levre,1)/bin)/(sqrt(length(NOGOs_hist_levre(:,1))))));flipud((smooth(mean(NOGOs_hist_levre)/bin) + (smooth(std(NOGOs_hist_levre,1)/bin)/sqrt(length(NOGOs_hist_levre(:,1))))))],[.6 0 0],'linestyle','none');
end
plot([(tw_pts/(2*srate))-time_window/2 (tw_pts/(2*srate))-time_window/2],[0 max([max(mean(GOs_hist_ttl)/bin),max(mean(NOGOs_hist_ttl)/bin),max(mean(NOGOf_hist_ttl)/bin),max(mean(GOs_hist_press)/bin),max(mean(NOGOs_hist_press)/bin),max(mean(NOGOf_hist_press)/bin),max(mean(GOs_hist_levre)/bin),max(mean(NOGOs_hist_levre)/bin),max(mean(NOGOf_hist_levre)/bin),max(mean(GOs_hist_rxnt)/bin),max(mean(NOGOs_hist_rxnt)/bin),max(mean(NOGOf_hist_rxnt)/bin)])+3],'color',[.5 0 .5],'linewidth',2)
hold off
ylim([0 max([max(mean(GOs_hist_ttl(:,11:50))/bin),max(mean(NOGOs_hist_ttl(:,11:50))/bin),max(mean(NOGOf_hist_ttl(:,11:50))/bin),max(mean(GOs_hist_press(:,11:50))/bin),max(mean(NOGOs_hist_press(:,11:50))/bin),max(mean(NOGOf_hist_press(:,11:50))/bin),max(mean(GOs_hist_levre(:,11:50))/bin),max(mean(NOGOs_hist_levre(:,11:50))/bin),max(mean(NOGOf_hist_levre(:,11:50))/bin)])])
xlabel('time from lever levre (s)','fontsize',14,'fontweight','normal')
linkaxes(sp,'x') %linkaxes(sp([1,2,3,5,6,7]),'x')
xlim([-2 2])
set(sp([4,5,6]),'xtick',-2:1:2) %set(sp([5,6,7]),'xtick',-2:1:2)

% sp(8) = subplot(2,4,8);
% plot(centros,smooth(mean(GOs_hist_rxnt)/bin),'color',[0 .5 0],'linewidth',2)
% hold on
% plot(centros,smooth(mean(NOGOf_hist_rxnt)/bin),'color',[.9 0 0],'linewidth',2)
% plot(centros,smooth(mean(NOGOs_hist_rxnt)/bin),'color',[.6 0 0],'linewidth',2)
% % sin smooth
% % fi(22) = fill([centros';flipud(centros')],[(mean(GOs_hist_rxnt)'/bin - ((std(GOs_hist_rxnt,1)/bin)/(sqrt(length(GOs_hist_rxnt(:,1)))))');flipud((mean(GOs_hist_rxnt)'/bin + ((std(GOs_hist_rxnt,1)/bin)/sqrt(length(GOs_hist_rxnt(:,1))))'))],[0 .5 0],'linestyle','none');
% % fi(23) = fill([centros';flipud(centros')],[(mean(NOGOf_hist_rxnt)'/bin - ((std(NOGOf_hist_rxnt,1)/bin)/(sqrt(length(NOGOf_hist_rxntl(:,1)))))');flipud((mean(NOGOf_hist_rxnt)'/bin + ((std(NOGOf_hist_rxnt,1)/bin)/sqrt(length(NOGOf_hist_rxnt(:,1))))'))],[.9 0 0],'linestyle','none');
% % fi(24) = fill([centros';flipud(centros')],[(mean(NOGOs_hist_rxnt)'/bin - ((std(NOGOs_hist_rxnt,1)/bin)/(sqrt(length(NOGOs_hist_rxnt(:,1)))))');flipud((mean(NOGOs_hist_rxnt)'/bin + ((std(NOGOs_hist_rxnt,1)/bin)/sqrt(length(NOGOs_hist_rxnt(:,1))))'))],[.6 0 0],'linestyle','none');
% % con smooth
% fi(22) = fill([centros';flipud(centros')],[(smooth(mean(GOs_hist_rxnt)/bin) - (smooth(std(GOs_hist_rxnt,1)/bin)/(sqrt(length(GOs_hist_rxnt(:,1))))));flipud((smooth(mean(GOs_hist_rxnt)/bin) + (smooth(std(GOs_hist_rxnt,1)/bin)/sqrt(length(GOs_hist_rxnt(:,1))))))],[0 .5 0],'linestyle','none');
% fi(23) = fill([centros';flipud(centros')],[(smooth(mean(NOGOf_hist_rxnt)/bin) - (smooth(std(NOGOf_hist_rxnt,1)/bin)/(sqrt(length(NOGOf_hist_rxnt(:,1))))));flipud((smooth(mean(NOGOf_hist_rxnt)/bin) + (smooth(std(NOGOf_hist_rxnt,1)/bin)/sqrt(length(NOGOf_hist_rxnt(:,1))))))],[.9 0 0],'linestyle','none');
% fi(24) = fill([centros';flipud(centros')],[(smooth(mean(NOGOs_hist_rxnt)/bin) - (smooth(std(NOGOs_hist_rxnt,1)/bin)/(sqrt(length(NOGOs_hist_rxnt(:,1))))));flipud((smooth(mean(NOGOs_hist_rxnt)/bin) + (smooth(std(NOGOs_hist_rxnt,1)/bin)/sqrt(length(NOGOs_hist_rxnt(:,1))))))],[.6 0 0],'linestyle','none');
% plot([(tw_pts/(2*srate))-time_window/2 (tw_pts/(2*srate))-time_window/2],[0 max([max(mean(GOs_hist_ttl)/bin),max(mean(NOGOs_hist_ttl)/bin),max(mean(NOGOf_hist_ttl)/bin),max(mean(GOs_hist_press)/bin),max(mean(NOGOs_hist_press)/bin),max(mean(NOGOf_hist_press)/bin)])+3],'color',[.9 .9 0],'linewidth',2)
% hold off
% xlim([-3 1])
% set(sp(8),'xtick',-3:1:1)

ylim([0 max([max(mean(GOs_hist_ttl(:,11:50))/bin),max(mean(NOGOs_hist_ttl(:,11:50))/bin),max(mean(NOGOf_hist_ttl(:,11:50))/bin),max(mean(GOs_hist_press(:,11:50))/bin),max(mean(NOGOs_hist_press(:,11:50))/bin),max(mean(NOGOf_hist_press(:,11:50))/bin),max(mean(GOs_hist_levre(:,11:50))/bin),max(mean(NOGOs_hist_levre(:,11:50))/bin),max(mean(NOGOf_hist_levre(:,11:50))/bin),max(mean(GOs_hist_rxnt(:,1:40))/bin),max(mean(NOGOs_hist_rxnt(:,1:40))/bin),max(mean(NOGOf_hist_rxnt(:,1:40))/bin)])])
xlabel('time from reaction time (s)','fontsize',14,'fontweight','normal')
hleg = legend(['\color[rgb]{0 .5 0}HIT (n = ' num2str(length(trials_GOs)) ')'],['\color[rgb]{.9 0 0}FALSE ALARM (n = ' num2str(length(trials_NOGOf)) ')'],['\color[rgb]{.6 0 0}CORRECT REJECTION (n = ' num2str(length(trials_NOGOs)) ')']);
set(hleg,'box','off','position',[.85,.45,.1,.03],'fontsize',12,'fontweight','demi')

ntrials = [size(unique(TTLarea_press_GOs(:,2)'),2),size(unique(TTLarea_press_NOGOs(:,2)'),2),size(unique(TTLarea_press_NOGOf(:,2)'),2),...
           size(unique(TTLarea_ttl_GOs(:,2)'),2),size(unique(TTLarea_ttl_NOGOs(:,2)'),2),size(unique(TTLarea_ttl_NOGOf(:,2)'),2),...
           size(unique(TTLarea_levre_GOs(:,2)'),2),size(unique(TTLarea_levre_NOGOs(:,2)'),2),size(unique(TTLarea_levre_NOGOf(:,2)'),2),...
           size(trials_GOs,2),size(trials_NOGOs,2),size(trials_NOGOf,2),...
           size(trials_GOs,2),size(trials_NOGOs,2),size(trials_NOGOf,2),...
           size(trials_GOs,2),size(trials_NOGOs,2),size(trials_NOGOf,2)];
i_nt = ntrials>1;

set(sp(5:6),'ycolor','w')
set(sp(4:6),'box','off','fontsize',18,'fontweight','normal')
linkaxes(sp([4,5,6]),'y') %linkaxes(sp([5,6,7,8]),'y')
alpha(fi(i_nt),.3)
set(gcf,'color','w','Position', [0 50 1640 780],'paperunits','points','PaperPosition', [0 50 1640 780])

fname = ['centros3_' list(ws).name(11:end-4) '_HvFAvCJ_dotsize_' num2str(dotsize) '_smooth'];
% base_dir = ['C:\Users\pflab\Desktop\análisis_SB32_SB33\copia_spks_HIPP\Stim2\sin SB12\figuras_centros_vt_dotsize_' num2str(dotsize) '_smooth'];    % dirección base de la carpeta donde están todos los experimentos
% base_dir = 'C:\Users\pflab\Dropbox\VT\WS_SB35\figuras';
base_dir = ['C:\Users\pflab\Dropbox\VT\figuras_raster&PSTH_vt_dotsize_2_smooth\' db_dir{region,1}(38:end)];
cd(base_dir);  
print(f,'-dtiff',fname,'-r0')
close
% cd ..
cd(db_dir{region,1})
end
end