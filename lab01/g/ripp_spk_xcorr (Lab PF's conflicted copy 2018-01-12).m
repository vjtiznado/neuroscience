%% RIPPLE-SPIKE CROSS-CORRELATION

clc;
clear
spk_dir = 'C:\Users\neuro\Dropbox\SB\RESULTADOS\SPIKES\NEURONS\Protocolo 2\';
results_dir = 'C:\Users\neuro\Dropbox\SB\RESULTADOS\RIPPLES\';

sd_n = 3;

load([results_dir 'ripples_data_raw_SD_' num2str(sd_n) '_ina.mat'])
load([spk_dir 'list_workspace.mat'])
% rat_ripples = rat_ripples_c;
count = 0;
bin = 1;
maxlag = 300;
spkripp_xcorr = struct('data',[],'info',[],'logical_ripp_firing',zeros(size(ws_list,1),1),'logical_xcorr',zeros(size(ws_list,1),1),'bin_ms',bin,'time_window',maxlag);
spkripp_xcorr.data = nan(size(ws_list,1),maxlag*2+1);
spkripp_xcorr.info = cell(size(ws_list,1),1);
for r = 1:size(rat_ripples,1)
    display('  ')
    display(rat_ripples.name(r))
    if ~isempty(rat_ripples.ripples_data{r,1})
        ses_dir = rat_ripples.ripples_data{r,1}(:,2);
        for s = 1:size(ses_dir,1)            
            display(ses_dir{s,1})
            RT = rat_ripples.ripples_data{r,1}{s,1};
            spk_sess = dir([spk_dir 'workspace_' ses_dir{s,1}(11:end) '*']); % take workspace files from that sessions
            tts = arrayfun(@(sp) str2double(sp.name(end-6)),spk_sess)';
            tts = unique(tts);
            for spk = 1:size(spk_sess,1)
                spk_pos = find(strcmp(ws_list,spk_sess(spk).name)==1); % take the position of that workspace in the list of workspaces
                count = count +1;
                load([spk_dir spk_sess(spk).name])
                spikes = V_f{1,1}.spikes;
                lfp_srate = 2000;
                spk_srate = 20000;
                spikes = spikes*1000/spk_srate;
                x = regexp(spk_sess(spk).name,'_','split');
                
                if r == 2 && s == 1
                    ini = 300000;
                    fin = 2850000;
                    spikes = spikes - (ini/lfp_srate)*1000;
                    spikes = spikes(spikes>0 & spikes<1000*(fin-ini)/lfp_srate);
                elseif r == 2 && s == 2
                    ini = 1;
                    fin = 2100000;
                    spikes = spikes(spikes>0 & spikes<1000*(fin-ini)/lfp_srate);
                elseif r == 2 && s == 3
                    ini = 1;
                    fin = 2390000;
                    spikes = spikes(spikes>0 & spikes<1000*(fin-ini)/lfp_srate);
                elseif r == 2 && s == 4
                    ini = 1000000;
                    fin = 2190000;
                    spikes = spikes - (ini/lfp_srate)*1000;
                    spikes = spikes(spikes>0 & spikes<1000*(fin-ini)/lfp_srate);
                elseif r == 2 && s == 6
                    ini = 1;
                    fin = 1850000;
                    spikes = spikes(spikes>0 & spikes<1000*(fin-ini)/lfp_srate);
                elseif r == 4 && s == 1;
                    ini = 1;
                    fin = 1535800;
                    spikes = spikes(spikes>0 & spikes<1000*(fin-ini)/lfp_srate);
                elseif r == 4 && s == 3;
                    ini = 1;
                    fin = 1568900;
                    spikes = spikes(spikes>0 & spikes<1000*(fin-ini)/lfp_srate);
                elseif r == 4 && s == 4
                    ini = 1430000;
                    fin = 3653400;
                    spikes = spikes - (ini/lfp_srate)*1000;
                    spikes = spikes(spikes>0 & spikes<1000*(fin-ini)/lfp_srate);
                elseif r == 4 && s == 5
                    ini = 1;
                    fin = 2074300;
                    spikes = spikes(spikes>0 & spikes<1000*(fin-ini)/lfp_srate);
                elseif r == 4 && s == 6
                    ini = 1;
                    fin = 2312200;
                    spikes = spikes(spikes>0 & spikes<1000*(fin-ini)/lfp_srate);
                elseif r == 4 && s == 7
                    ini = 1578300;
                    fin = 2946600;
                    spikes = spikes - (ini/lfp_srate)*1000;
                    spikes = spikes(spikes>0 & spikes<1000*(fin-ini)/lfp_srate,:);
                elseif r == 4 && s == 8
                    ini = 1;
                    fin = 1129200;
                    spikes = spikes(spikes>0 & spikes<1000*(fin-ini)/lfp_srate,:);
                elseif r == 4 && s == 9
                    ini = 1000000;
                    fin = 2010000;
                    spikes = spikes - (ini/lfp_srate)*1000;
                    spikes = spikes(spikes>0 & spikes<1000*(fin-ini)/lfp_srate,:);
                elseif r == 6 && s == 8;
                    ini = 250000;
                    fin = 1400000;
                    spikes = spikes - (ini/lfp_srate)*1000;
                    spikes = spikes(spikes>0 & spikes<1000*(fin-ini)/lfp_srate,:);
                elseif r == 6 && s == 3;
                    ini = 1218824;
                    fin = 2357648;
                    spikes = spikes - (ini/lfp_srate)*1000;
                    spikes = spikes(spikes>0 & spikes<1000*(fin-ini)/lfp_srate,:);
                end
                tt_ripps = RT.latency(RT.est(3,:)==str2double(spk_sess(spk).name(end-6)));
                [spkripp_xcorr.data(spk_pos,:),eje] = corr_cruz(tt_ripps,spikes,maxlag,bin);
                spkripp_xcorr.info{strcmp(ws_list,spk_sess(spk).name),1} = spk_sess(spk).name;
                if ~isnan(max(spkripp_xcorr.data(spk_pos,:))) && find(spkripp_xcorr.data(spk_pos,:) == max(spkripp_xcorr.data(spk_pos,:)),1)>300 && find(spkripp_xcorr.data(spk_pos,:) == max(spkripp_xcorr.data(spk_pos,:)),1) < 480
                    spkripp_xcorr.logical_ripp_firing(spk_pos,1) = 1;
                else
                    spkripp_xcorr.logical_ripp_firing(spk_pos,1) = 0;
                end
                spkripp_xcorr.logical_xcorr(spk_pos,1) = 1;
            end
        end
    end
end

spkripp_xcorr.logical_ripp_firing = logical(spkripp_xcorr.logical_ripp_firing);
spkripp_xcorr.logical_xcorr = logical(spkripp_xcorr.logical_xcorr);
save([results_dir 'spkripp_xcorr_SD_' num2str(sd_n) '_ina.mat'],'spkripp_xcorr','eje','-v7.3')
clearvars -except spkripp_xcorr eje
display('mily')

%% to plot spike-ripple cross-correlation of neurons that discharge during ripples
% spk_dir = 'C:\Users\neuro\Dropbox\SB\RESULTADOS\SPIKES\NEURONS\Protocolo 2\';
ripp_dir = 'C:\Users\neuro\Dropbox\SB\RESULTADOS\RIPPLES\';
load([ripp_dir 'spkripp_xcorr_SD_5.mat'])
figure
plot(eje,nanmean(spkripp_xcorr.data(spkripp_xcorr.logical,:)),'k')
hold on
plot(eje,nanmean(spkripp_xcorr.data(~spkripp_xcorr.logical,:)),'color',[0 0 .8])
% title('neurons that discharge during ripples')
% text(200,.07,['n = ' num2str(sum(spkripp_xcorr.logical))])
xlabel('Time (ms)','fontsize',13)
ylabel('Correlation','fontsize',13)
ylim([0 .08])
set(gca,'fontsize',13)
set(gcf,'color','w')
legend(['neurons that fire during ripples  (n = ' num2str(sum(spkripp_xcorr.logical)) ')'],['\color[rgb]{0 0 .8}neurons that don´t fire during ripples  (n = ' num2str(sum(~spkripp_xcorr.logical)) ')']);

%% to plot spike-ripple cross-correlation of anticipatory neurons that discharge during ripples
spk_dir = 'C:\Users\neuro\Dropbox\SB\RESULTADOS\SPIKES\NEURONS\Protocolo 2\';
ripp_dir = 'C:\Users\neuro\Dropbox\SB\RESULTADOS\RIPPLES\';
load([ripp_dir 'spkripp_xcorr_SD_5.mat'])
load([spk_dir 'logic_anticipatory.mat'])

figure
plot(eje,nanmean(spkripp_xcorr.data(spkripp_xcorr.logical,:)),'k')
hold on
plot(eje,nanmean(spkripp_xcorr.data(spkripp_xcorr.logical & logic_anticipatory(52:end),:)),'color',[0 .7 0])
plot(eje,nanmean(spkripp_xcorr.data(spkripp_xcorr.logical & ~logic_anticipatory(52:end),:)),'color',[.7 0 0])
title('Neurons that fire during ripples','fontsize',14)
% text(200,.07,['n = ' num2str(sum(spkripp_xcorr.logical & logic_anticipatory(52:end)))])
xlabel('Time (ms)','fontsize',13)
ylabel('Correlation','fontsize',13)
ylim([0 .08])
set(gcf,'color','w')
set(gca,'fontsize',13)
legend(['all  (n = ' num2str(sum(spkripp_xcorr.logical)) ')'],['\color[rgb]{0 .7 0}anticipatory (n = ' num2str(sum(spkripp_xcorr.logical & logic_anticipatory(52:end))) ')'],['\color[rgb]{.7 0 0}non-anticipatory (n = ' num2str(sum(spkripp_xcorr.logical & ~logic_anticipatory(52:end))) ')']);

%% to plot spike-ripple cross-correlation of all anticipatory neurons
spk_dir = 'C:\Users\neuro\Dropbox\SB\RESULTADOS\SPIKES\NEURONS\Protocolo 2\';
load([spk_dir 'logic_anticipatory.mat'])
figure
plot(eje,nanmean(spkripp_xcorr.data(logic_anticipatory(52:end),:)),'k')
title('all anticipatory neurons')
text(200,.07,['n = ' num2str(sum(logic_anticipatory(52:end)))])
xlabel('Time (ms)')
ylim([0 .08])
set(gcf,'color','w')

%%
clear
clc
spk_dir = 'C:\Users\neuro\Dropbox\SB\RESULTADOS\SPIKES\NEURONS\Protocolo 2\';
ripples_dir = 'C:\Users\neuro\Dropbox\SB\RESULTADOS\RIPPLES\';
load([spk_dir 'logic_anticipatory.mat'])
load([ripples_dir 'spkripp_xcorr_SD_5.mat'])
eje_spk_ripp = eje; clear eje
load([ripples_dir 'ripples_raster_SD_5.mat'])
eje_rippraster = eje; clear eje

logic_ant_ripp = spkripp_xcorr.logical & logic_anticipatory(52:end);
% sum(ant_ripp)

% comparar las neuronas que dirparan durante los ripples con el el vector de las anticipatorias 
ripp_raster_info = cellfun(@(x) x(11:end-3),aspkripp_raster.info(:,2),'UniformOutput',false);
spkripp_xcorr_info = cellfun(@(x) x(11:end-6),spkripp_xcorr.info(:,1),'UniformOutput',false);
for ant_ripp_spk = 1:sum(logic_ant_ripp)
    
    %** hacer calzar la info del raster con la de la espiga en spkripp_xcorr
    aspkripp_raster.info{ant_ripp_spk,2}(11:end-3)
    spkripp_xcorr.info{ant_ripp_spk,1}(11:end-6)
    figure
    plot((aspkripp_raster.press{ant_ripp_spk,1}(1,aspkripp_raster.press{ant_ripp_spk,1}(3,:)==23)-time_window/2)/1000,(1:length(aspkripp_raster.press{ant_ripp_spk,1}(1,aspkripp_raster.press{ant_ripp_spk,1}(3,:)==23))),'color',[0 0 .8],'linestyle','none','marker','square','markerfacecolor',[0 0 .8],'markersize',3);
    hold on
    plot((aspkripp_raster.press{ant_ripp_spk,1}(1,aspkripp_raster.press{ant_ripp_spk,1}(3,:)==22)-time_window/2)/1000,(1:length(aspkripp_raster.press{ant_ripp_spk,1}(1,aspkripp_raster.press{ant_ripp_spk,1}(3,:)==22)))+length(aspkripp_raster.press{ant_ripp_spk,1}(1,aspkripp_raster.press{ant_ripp_spk,1}(3,:)==23))+1,'color',[.8 0 0],'linestyle','none','marker','square','markerfacecolor',[.8 0 0],'markersize',3);
    plot((aspkripp_raster.press{ant_ripp_spk,1}(1,aspkripp_raster.press{ant_ripp_spk,1}(3,:)==11)-time_window/2)/1000,(1:length(aspkripp_raster.press{ant_ripp_spk,1}(1,aspkripp_raster.press{ant_ripp_spk,1}(3,:)==11)))+length(aspkripp_raster.press{ant_ripp_spk,1}(1,aspkripp_raster.press{ant_ripp_spk,1}(3,:)==23))+length(aspkripp_raster.press{ant_ripp_spk,1}(1,aspkripp_raster.press{ant_ripp_spk,1}(3,:)==22))+1,'color',[0 .8 0],'linestyle','none','marker','square','markerfacecolor',[0 .8 0],'markersize',3);
    
    title(aspkripp_raster.info{ant_ripp_spk,1},'interpreter','none')
    hold off
    xlim([-3 3])
    set(gca,'ycolor','w','xcolor','w')
end

%%
deira = aspkripp_raster.info(:,2);
strss = cellfun(@(x) x(11:24),deira,'UniformOutput',false);
% ripp_raster_info = cellfun(@(x) x(11:end-3),ripp_raster.info(:,2),'UniformOutput',false);
% strcmp(strss,)

%%

%%
clear
clc
spk_dir = 'C:\Users\neuro\Dropbox\SB\RESULTADOS\SPIKES\NEURONS\Protocolo 2\';
ripples_dir = 'C:\Users\neuro\Dropbox\SB\RESULTADOS\RIPPLES\';
load([spk_dir 'logic_anticipatory.mat'])
load([ripples_dir 'spkripp_xcorr_SD_5.mat'])
load([ripples_dir 'ripples_data_raw_SD_5.mat'])
spk_list = dir([spk_dir 'workspace*']);
spk_list = spk_list(52:end);
spk_list = cellfun(@(x) x(1:end),{spk_list.name},'UniformOutput',false)';
logic_ant_ripp = spkripp_xcorr.logical & logic_anticipatory(52:end);clear spkripp_xcorr eje
pos_ant_ripp = find(logic_ant_ripp)';

% comparar las neuronas que dirparan durante los ripples con el el vector de las anticipatorias 
% ripp_raster_info = cellfun(@(x) x(11:end-3),ripp_raster.info(:,2),'UniformOutput',false);
% spkripp_xcorr_info = cellfun(@(x) x(11:end-6),spkripp_xcorr.info(:,1),'UniformOutput',false);
for r = 1:size(rat_ripples,2)
    display(rat_ripples(r).name)
    ses_dir = unique(rat_ripples(r).sessions(:,1));
    for s = 1:size(ses_dir,1)
        display(ses_dir{s})
        spk_sess = dir([spk_dir 'workspace_' ses_dir{s}(11:end) '*']);
        spk_sess = cellfun(@(x) x(1:end),{spk_sess.name},'UniformOutput',false)';        
        RT = rat_ripples(r).ripples_data{s,1};        
        tts = cellfun(@(sp) str2double(sp(end-6)),spk_sess,'UniformOutput',false)';
        tts = unique(cell2mat(tts));
        for spk = 1:size(spk_sess,1)
            if sum(strcmp(spk_list(logic_ant_ripp),spk_sess(spk))) == 1
                load([spk_dir char(spk_sess{spk})])
                spikes = V_f{1,1}.spikes;
                lfp_srate = 2000;
                spk_srate = V_f{1,1}.spikes_srate;
                spikes = spikes*1000/spk_srate; % spikes in miliseconds
                x = regexp(spk_sess(spk),'_','split');
                
                if r == 2 && s == 1
                    ini = 300000;
                    fin = 2850000;
                    spikes = spikes - (ini/lfp_srate)*1000;
                    spikes = spikes(spikes>0 & spikes<1000*(fin-ini)/lfp_srate);
                elseif r == 2 && s == 2
                    ini = 1;
                    fin = 2100000;
                    spikes = spikes(spikes>0 & spikes<1000*(fin-ini)/lfp_srate);
                elseif r == 2 && s == 3
                    ini = 1;
                    fin = 2390000;
                    spikes = spikes(spikes>0 & spikes<1000*(fin-ini)/lfp_srate);
                elseif r == 2 && s == 4
                    ini = 1000000;
                    fin = 2190000;
                    spikes = spikes - (ini/lfp_srate)*1000;
                    spikes = spikes(spikes>0 & spikes<1000*(fin-ini)/lfp_srate);
                elseif r == 2 && s == 6
                    ini = 1;
                    fin = 1850000;
                    spikes = spikes(spikes>0 & spikes<1000*(fin-ini)/lfp_srate);
                elseif r == 4 && s == 1;
                    ini = 1;
                    fin = 1535800;
                    spikes = spikes(spikes>0 & spikes<1000*(fin-ini)/lfp_srate);
                elseif r == 4 && s == 3;
                    ini = 1;
                    fin = 1568900;
                    spikes = spikes(spikes>0 & spikes<1000*(fin-ini)/lfp_srate);
                elseif r == 4 && s == 4
                    ini = 1430000;
                    fin = 3653400;
                    spikes = spikes - (ini/lfp_srate)*1000;
                    spikes = spikes(spikes>0 & spikes<1000*(fin-ini)/lfp_srate);
                elseif r == 4 && s == 5
                    ini = 1;
                    fin = 2074300;
                    spikes = spikes(spikes>0 & spikes<1000*(fin-ini)/lfp_srate);
                elseif r == 4 && s == 6
                    ini = 1;
                    fin = 2312200;
                    spikes = spikes(spikes>0 & spikes<1000*(fin-ini)/lfp_srate);
                elseif r == 4 && s == 7
                    ini = 1578300;
                    fin = 2946600;
                    spikes = spikes - (ini/lfp_srate)*1000;
                    spikes = spikes(spikes>0 & spikes<1000*(fin-ini)/lfp_srate,:);
                elseif r == 4 && s == 8
                    ini = 1;
                    fin = 1129200;
                    spikes = spikes(spikes>0 & spikes<1000*(fin-ini)/lfp_srate,:);
                elseif r == 4 && s == 9
                    ini = 1000000;
                    fin = 2010000;
                    spikes = spikes - (ini/lfp_srate)*1000;
                    spikes = spikes(spikes>0 & spikes<1000*(fin-ini)/lfp_srate,:);
                elseif r == 6 && s == 8;
                    ini = 250000;
                    fin = 1400000;
                    spikes = spikes - (ini/lfp_srate)*1000;
                    spikes = spikes(spikes>0 & spikes<1000*(fin-ini)/lfp_srate,:);
                elseif r == 6 && s == 3;
                    ini = 1218824;
                    fin = 2357648;
                    spikes = spikes - (ini/lfp_srate)*1000;
                    spikes = spikes(spikes>0 & spikes<1000*(fin-ini)/lfp_srate,:);
                end
                spikes_durripp = nan(size(spikes));                
                tt_ripps = RT.latency(RT.est(3,:)==str2double(spk_sess{spk}(end-6)));
                tt_ripps_dur = RT.rt(RT.est(3,:)==str2double(spk_sess{spk}(end-6)));
                
                for spik = 1:size(spikes,1)
                    if sum(spikes(spik) >= tt_ripps(1,:) & spikes(spik) <= tt_ripps(1,:)+tt_ripps_dur(1,:)) ==1
%                         display('yes')
                        spikes_durripp(sum(~isnan(spikes_durripp(:,1)))+1) = spikes(spik);
                    else
%                         display('no')
%                     aux = spikes(spikes(:,1) > tt_ripps(1,spik) & spikes < (tt_ripps(1,spik)+tt_ripps_dur(spik)),1);
%                     spikes_durripp(sum(~isnan(spikes_durripp(:,1)))+1:sum(~isnan(spikes_durripp(:,1)))+size(aux,1)) = aux;
                    end
                end
                spikes_durripp = spikes_durripp(1:sum(~isnan(spikes_durripp(:,1))));
                spikes_durripp = (spikes_durripp*spk_srate)/1000;
                V_f{1,1}.spikes_durripp = spikes_durripp;
                save([spk_dir char(spk_sess{spk})],'V_f','-v7.3')
            else
            end
        end       
    end
end

% spkripp_xcorr.logical = logical(spkripp_xcorr.logical);
% save([results_dir 'spkripp_xcorr_SD_' num2str(sd_n) '.mat'],'spkripp_xcorr','eje','-v7.3')
% clearvars -except spkripp_xcorr eje
msgbox_icon = imread('bien.jpg');
msgbox('ANALYSIS READY','Enhorabuena','custom',msgbox_icon)
display('mily')

%%

clear
clc
spk_dir = 'C:\Users\neuro\Dropbox\SB\RESULTADOS\SPIKES\NEURONS\Protocolo 2\';
ripples_dir = 'C:\Users\neuro\Dropbox\SB\RESULTADOS\RIPPLES\';
load([spk_dir 'logic_anticipatory.mat'])
load([ripples_dir 'spkripp_xcorr_SD_5.mat'])
spk_list = dir([spk_dir 'workspace*']);
spk_list = spk_list(52:end);
% spk_list = cellfun(@(x) x(1:end),{spk_list.name},'UniformOutput',false)';
logic_ant_ripp = spkripp_xcorr.logical & logic_anticipatory(52:end);clear spkripp_xcorr eje
pos_ant_ripp = find(logic_ant_ripp)';
spk_list = spk_list(logic_ant_ripp);
count = 0;
aspkripp = struct('press',[],'stimo',[],'levre',[]);
for sar = 1:size(spk_list,1)
    count = count + 1;
    load([spk_dir spk_list(sar).name])
    spikes_durripp = V_f{1,1}.spikes_durripp;
    spikes_durripp = spikes_durripp*1000/V_f{1,1}.spikes_srate;
    TTL = V_f{1,1}.TTLaux;
    tw = 6000;
    
    aspkripp_raster.press{count,1} = rastermk(spikes_durripp,TTL(:,6)-TTL(:,2),TTL(:,1),tw);
    aspkripp_raster.stimo{count,1} = rastermk(spikes_durripp,TTL(:,6),TTL(:,1),tw);
    aspkripp_raster.levre{count,1} = rastermk(spikes_durripp,TTL(:,6)+TTL(:,4),TTL(:,1),tw);
    aspkripp_raster.info{count,1} = spk_list(sar).name;
    
    
end

beep
pause(.5)
beep

%%

% figure
n = 47;
plot(aspkripp_raster.press{n,1}(1,:)-tw/2,aspkripp_raster.press{n,1}(2,:),'color','k','linestyle','none','marker','square','markerfacecolor',[0 0 0],'markersize',3)
title(aspkripp_raster.info{n,1},'interpreter','none')
xlim([-3000 3000])




