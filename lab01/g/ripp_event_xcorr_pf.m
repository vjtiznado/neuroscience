%% RIPPLE RASTER PLOT

clc;
clear
data_dir = 'C:\Users\neuro\Dropbox\VT\LFP_data\';
data_dir_c = 'E:\LFP_data\';
results_dir = 'C:\Users\neuro\Dropbox\SB\RESULTADOS\RIPPLES\';

sd_n = 3;
bin = 300;

% load([results_dir 'ripples_data_raw_SD_' num2str(sd_n) '_c.mat'])
load([data_dir_c 'ripples_data_raw_SD_' num2str(sd_n) '_pf.mat'])
count = 0;
ripp_raster_c = struct('press',[],'stimo',[],'levre',[],'info',[]);
for r = 1:size(rat_ripples_c,2)
    display(rat_ripples_c(r).name)
    if ~isempty(rat_ripples_c(r).ripples_data)
        ses_dir = dir([data_dir rat_ripples_c(r).name '\session*']);
        for s = 1:size(ses_dir,1)
            display(ses_dir(s).name)
            load([data_dir rat_ripples_c(r).name '\' ses_dir(s).name '\TTL.mat'])
            load([data_dir rat_ripples_c(r).name '\' ses_dir(s).name '\LFP.mat'],'channels','tetrodes','srate')
            
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
            
            RT = rat_ripples_c(r).ripples_data{s,1};
            tw = 6000;
            for chs = 1:size(unique(RT.est(1,:)),2)
                count = count + 1;
                ripp_ts = RT.latency(RT.est(1,:) == chs);
                max_lag = 3000;
                
                ripp_raster_c.info{count,1} = rat_ripples_c(r).name;
                if channels(chs) < 10
                    ripp_raster_c.info{count,2} = [ses_dir(s).name '_tt' num2str(tetrodes(ceil(chs/4))) '_0' num2str(channels(chs))];
                else
                    ripp_raster_c.info{count,2} = [ses_dir(s).name '_tt' num2str(tetrodes(ceil(chs/4))) '_' num2str(channels(chs))];
                end
                ripp_raster_c.press{count,1} = rastermk(ripp_ts,TTL(:,2),TTL(:,1),tw);
                ripp_raster_c.stimo{count,1} = rastermk(ripp_ts,TTL(:,6),TTL(:,1),tw);
                ripp_raster_c.levre{count,1} = rastermk(ripp_ts,TTL(:,4),TTL(:,1),tw);
                %all
                [ripp_raster_c.press{count,3},~] = corr_cruz(TTL(:,2),RT.latency(RT.est(1,:) == chs),max_lag,bin);
                [ripp_raster_c.stimo{count,3},~] = corr_cruz(TTL(:,6),RT.latency(RT.est(1,:) == chs),max_lag,bin);
                [ripp_raster_c.levre{count,3},~] = corr_cruz(TTL(:,4),RT.latency(RT.est(1,:) == chs),max_lag,bin);
                %hit
                [ripp_raster_c.press{count,4},~] = corr_cruz(TTL(TTL(:,1)==11,2),RT.latency(RT.est(1,:) == chs),max_lag,bin);
                [ripp_raster_c.stimo{count,4},~] = corr_cruz(TTL(TTL(:,1)==11,6),RT.latency(RT.est(1,:) == chs),max_lag,bin);
                [ripp_raster_c.levre{count,4},~] = corr_cruz(TTL(TTL(:,1)==11,4),RT.latency(RT.est(1,:) == chs),max_lag,bin);
                
                %fa
                [ripp_raster_c.press{count,5},~] = corr_cruz(TTL(TTL(:,1)==22,2),RT.latency(RT.est(1,:) == chs),max_lag,bin);
                [ripp_raster_c.stimo{count,5},~] = corr_cruz(TTL(TTL(:,1)==22,6),RT.latency(RT.est(1,:) == chs),max_lag,bin);
                [ripp_raster_c.levre{count,5},~] = corr_cruz(TTL(TTL(:,1)==22,4),RT.latency(RT.est(1,:) == chs),max_lag,bin);
                
                %cr
                [ripp_raster_c.press{count,6},~] = corr_cruz(TTL(TTL(:,1)==23,2),RT.latency(RT.est(1,:) == chs),max_lag,bin);
                [ripp_raster_c.stimo{count,6},~] = corr_cruz(TTL(TTL(:,1)==23,6),RT.latency(RT.est(1,:) == chs),max_lag,bin);
                [ripp_raster_c.levre{count,6},eje] = corr_cruz(TTL(TTL(:,1)==23,4),RT.latency(RT.est(1,:) == chs),max_lag,bin);
                
                centros = (-tw/2:bin:tw/2);
                centros = centros+bin/2;
                centros = centros(1:end-1);
                ripp_raster_c.press{count,2} = nan(size(TTL(:,1),1),size(centros,2));
                ripp_raster_c.stimo{count,2} = nan(size(TTL(:,1),1),size(centros,2));
                ripp_raster_c.levre{count,2} = nan(size(TTL(:,1),1),size(centros,2));
                
                for i = 1:size(TTL(:,1),1)
                    
                    ripp_raster_c.press{count,2}(i,:) = (hist(ripp_raster_c.press{count,1}(1,ripp_raster_c.press{count,1}(2,:)==i)-tw/2,centros))/bin;
                    ripp_raster_c.stimo{count,2}(i,:) = (hist(ripp_raster_c.stimo{count,1}(1,ripp_raster_c.stimo{count,1}(2,:)==i)-tw/2,centros))/bin;
                    ripp_raster_c.levre{count,2}(i,:) = (hist(ripp_raster_c.levre{count,1}(1,ripp_raster_c.levre{count,1}(2,:)==i)-tw/2,centros))/bin;
                    
                end
            end
        end
    end
end
clearvars -except ripp_raster_c rat_ripples_c tw results_dir sd_n centros eje bin
time_window = tw;
tw_units = 'ms';
save([results_dir 'ripples_raster_SD_' num2str(sd_n) '_' num2str(bin) 'ms_pf.mat'],'ripp_raster_c','time_window','tw_units','centros','eje','-v7.3')


SD = 3;

load([results_dir 'ripples_raster_SD_' num2str(SD) '_' num2str(bin) 'ms_pf.mat'])

% %% mean cross correlation of all rats and each rat
xcors_press_all = nan(size(ripp_raster_c.press,1),size(ripp_raster_c.press{1,3},2));
xcors_stimo_all = nan(size(ripp_raster_c.stimo,1),size(ripp_raster_c.stimo{1,3},2));
xcors_levre_all = nan(size(ripp_raster_c.levre,1),size(ripp_raster_c.levre{1,3},2));

xcors_press_hit = nan(size(ripp_raster_c.press,1),size(ripp_raster_c.press{1,3},2));
xcors_stimo_hit = nan(size(ripp_raster_c.stimo,1),size(ripp_raster_c.stimo{1,3},2));
xcors_levre_hit = nan(size(ripp_raster_c.levre,1),size(ripp_raster_c.levre{1,3},2));

xcors_press_fa = nan(size(ripp_raster_c.press,1),size(ripp_raster_c.press{1,3},2));
xcors_stimo_fa = nan(size(ripp_raster_c.stimo,1),size(ripp_raster_c.stimo{1,3},2));
xcors_levre_fa = nan(size(ripp_raster_c.levre,1),size(ripp_raster_c.levre{1,3},2));

xcors_press_cr = nan(size(ripp_raster_c.press,1),size(ripp_raster_c.press{1,3},2));
xcors_stimo_cr = nan(size(ripp_raster_c.stimo,1),size(ripp_raster_c.stimo{1,3},2));
xcors_levre_cr = nan(size(ripp_raster_c.levre,1),size(ripp_raster_c.levre{1,3},2));

for i = 1:size(ripp_raster_c.press,1)
    xcors_press_all(i,:) = ripp_raster_c.press{i,3};
    xcors_stimo_all(i,:) = ripp_raster_c.stimo{i,3};
    xcors_levre_all(i,:) = ripp_raster_c.levre{i,3};
    xcors_press_hit(i,:) = ripp_raster_c.press{i,4};
    xcors_stimo_hit(i,:) = ripp_raster_c.stimo{i,4};
    xcors_levre_hit(i,:) = ripp_raster_c.levre{i,4};
    xcors_press_fa(i,:) = ripp_raster_c.press{i,5};
    xcors_stimo_fa(i,:) = ripp_raster_c.stimo{i,5};
    xcors_levre_fa(i,:) = ripp_raster_c.levre{i,5};
    xcors_press_cr(i,:) = ripp_raster_c.press{i,6};
    xcors_stimo_cr(i,:) = ripp_raster_c.stimo{i,6};
    xcors_levre_cr(i,:) = ripp_raster_c.levre{i,6};
      
end

rats = unique(ripp_raster_c.info(:,1));
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
    rvector = strcmp(ripp_raster_c.info(:,1),rats{r,1});
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
ripp_raster_c.mean_xcorr = rmean_xcorr;
save([results_dir 'ripples_raster_SD_' num2str(SD) '_' num2str(bin) 'ms_pf.mat'],'ripp_raster_c','time_window','tw_units','centros','eje','-v7.3')
display('mily')