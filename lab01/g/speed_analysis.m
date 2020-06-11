clear
cd('E:\Gonzalo')
exp = dir('Exp*');
count = 0;
fr_axis =15;
step_axis = 1/fr_axis;
t_max = 10;
t_axis = [step_axis:step_axis:t_max*60];
lim_speed = 2;
inter_hs_all = [];
lim_dur_mov = 1; % threshold for interval of movement
count2 = 0;
for e = 1:length(exp)
    cd(exp(e).name)
    archivos = dir('GV*');
    for k = 1:length(archivos) % CARPETAS CON DATOS A USAR (VER VARIALE FECHAS)
        cd(archivos(k).name)
        opr_files = dir('rec*OPR*');
        for d = 1:length(opr_files)
            cd(opr_files(d).name)
            count = count + 1;
            name_rec{count,1} = opr_files(d).name;
            load('txy_matrix_S.mat')
            load('pix_per_cm_S.mat')
            video_sr = dir('spk*S_1.mat*');
            load(video_sr(1).name,'video_sr');
            ivel_s = [0; arrayfun(@(t) pdist(txy(t:t+1,[2 3])),1:size(txy,1)-1)']; % compute distance between consecutive frames (pixels/frame)
            ivel_s = ivel_s/pix_per_cm; % from pixels to cm, distance is now cm/frame
            ivel_s = ivel_s*video_sr; % from frames to seconds, now instant velocity is cm/s
            ivel_s(ivel_s > 50) = NaN;
            median_vel_s(count,1) = nanmedian(ivel_s);
            high_speed_s = ivel_s > lim_speed;
            median_vel_mov_s(count,1) = nanmedian(ivel_s(high_speed_s));
            dummy = size(txy,1)/video_sr;
            if dummy > t_max*60
                time_s(count,1) = t_max*60;
            else
                time_s(count,1) = size(txy,1)/video_sr;
            end
            % norm veloc to t_axis
            x = [1:1:length(ivel_s)]/video_sr;
            ivel_s_array(count,:) = interp1(x,ivel_s,t_axis);
            load('txy_matrix_T.mat')
            load('pix_per_cm_T.mat')
            video_sr = dir('spk*T_1.mat*');
            load(video_sr(1).name,'video_sr');
            ivel_t = [0; arrayfun(@(t) pdist(txy(t:t+1,[2 3])),1:size(txy,1)-1)']; % compute distance between consecutive frames (pixels/frame)
            ivel_t = ivel_t/pix_per_cm; % from pixels to cm, distance is now cm/frame
            ivel_t = ivel_t*video_sr; % from frames to seconds, now instant velocity is cm/s
            ivel_t(ivel_t > 50) = NaN;
            median_vel_t(count,1) = nanmedian(ivel_t);
            high_speed_t = ivel_t > lim_speed;
            median_vel_mov_t(count,1) = nanmedian(ivel_t(high_speed_t));
            dummy = size(txy,1)/video_sr;
            if dummy > t_max*60
                time_t(count,1) = t_max*60;
            else
                time_t(count,1) = size(txy,1)/video_sr;
            end
            x = [1:1:length(ivel_t)]/video_sr;
            ivel_t_array(count,:) = interp1(x,ivel_t,t_axis);
            p_vel_mov_s_t(count,1) = ranksum(ivel_s(high_speed_s),ivel_t(high_speed_t));
            
            % correlation frate vs. speed over lim_speed
            spk_s_file = dir('spk_*_S_*');
            spk_t_file = dir('spk_*_T_*');
            
            h_speed_s_array = ivel_s_array(count,:) > lim_speed;
            h_speed_s_array = [0 diff(h_speed_s_array)];
            ini_s = find(h_speed_s_array == 1);
            fin_s = find(h_speed_s_array == -1);
            if ini_s(1) > fin_s(1)
                fin_s(1) = [];
            end
            length_ini_fin = min(length(ini_s),length(fin_s));
            ini_s = ini_s(1:length_ini_fin)/fr_axis;
            fin_s = fin_s(1:length_ini_fin)/fr_axis;
            inter_hs_s = fin_s - ini_s;
            
            h_speed_t_array = ivel_t_array(count,:) > lim_speed;
            h_speed_t_array = [0 diff(h_speed_t_array)];
            ini_t = find(h_speed_t_array == 1);
            fin_t = find(h_speed_t_array == -1);
            if ini_t(1) > fin_t(1)
                fin_t(1) = [];
            end
            length_ini_fin = min(length(ini_t),length(fin_t));
            ini_t = ini_t(1:length_ini_fin)/fr_axis;
            fin_t = fin_t(1:length_ini_fin)/fr_axis;
            inter_hs_t = fin_t - ini_t;
            inter_hs_all = [inter_hs_all inter_hs_s inter_hs_t];

            ini_s(inter_hs_s < lim_dur_mov) = [];
            fin_s(inter_hs_s < lim_dur_mov) = [];
            ini_t(inter_hs_t < lim_dur_mov) = [];
            fin_t(inter_hs_t < lim_dur_mov) = [];
            inter_hs_s(inter_hs_s < lim_dur_mov) = [];
            inter_hs_t(inter_hs_t < lim_dur_mov) = [];
            
            for n = 1:length(spk_s_file)
                count2 = count2 + 1;
                name_spk_hs_s_t{count2,1} = spk_s_file(n).name;
                load(name_spk_hs_s_t{count2,1},'spikes')
                if e == 1
                    spikes = spikes/10000;
                else
                    spikes = spikes/1000;
                end
                dummy = [];
                mean_vel_win = [];
                for j = 1:length(ini_s)
                    mean_vel_win = nanmean(ivel_s_array(count,round(fr_axis*ini_s(j)):round(fr_axis*fin_s(j))));
                    frate_win = sum(spikes >= ini_s(j) & spikes <= fin_s(j))/inter_hs_s(j);
                    dummy = [dummy; frate_win mean_vel_win];
                end
                fr_spk_hs_s_t{count2,1} = dummy;
                clear spikes
                name_spk_hs_s_t{count2,2} = spk_t_file(n).name;
                load(name_spk_hs_s_t{count2,2},'spikes')
                if e == 1
                    spikes = spikes/10000;
                else
                    spikes = spikes/1000;
                end
                dummy = [];
                mean_vel_win = [];
                for j = 1:length(ini_t)
                    mean_vel_win = nanmean(ivel_t_array(count,round(fr_axis*ini_t(j)):round(fr_axis*fin_t(j))));
                    frate_win = sum(spikes >= ini_t(j) & spikes <= fin_t(j))/inter_hs_t(j);
                    dummy = [dummy; frate_win mean_vel_win];
                end
                fr_spk_hs_s_t{count2,2} = dummy;
                clear spikes
            end
            
            cd ..
        end
        cd ..
    end
    cd ..
end
table_speed = table(name_rec,median_vel_s,median_vel_t);

%%
for k = 1:length(median_vel_s)
    plot(1,median_vel_s(k),'ko')
    hold on
    plot(2,median_vel_t(k),'ko')
    plot([1 2],[median_vel_s(k) median_vel_t(k)],'k','linewidth',0.5)
end
plot([0.75 1.25],[mean(median_vel_s) mean(median_vel_s)],'k','linewidth',4)
plot([1.75 2.25],[mean(median_vel_t) mean(median_vel_t)],'k','linewidth',4)
xlim([0.5 2.5])
set(gca,'xtick',[1 2],'xticklabel',{'Sample' 'Test'})
title('Median speed')
ylabel('cm/s')
[h,p] = ttest(median_vel_s,median_vel_t);
legend(['p = ' num2str(p)])
%%
% compare median speed in sample and test
[h,p] = kstest(zscore(median_vel_mov_s));
[h,p] = kstest(zscore(median_vel_mov_t));
[~,p_vel_mov_median_S_T] = ttest(median_vel_mov_s,median_vel_mov_t)

figure
plot(1,median_vel_mov_s,'ko')
hold on
plot(2,median_vel_mov_s,'ko')
plot([0.75 1.25],[mean(median_vel_mov_s) mean(median_vel_mov_s)],'k','linewidth',4)
plot([1.75 2.25],[mean(median_vel_mov_t) mean(median_vel_mov_t)],'k','linewidth',4)
xlim([0.5 2.5])
set(gca,'xtick',[1 2],'xticklabel',{'Sample' 'Test'})
ylabel('Mean Speed (cm/s)')
% [a,b] = hist(inter_hs_all,500);
ylim([0 15])
legend(['p = ' num2str(p_vel_mov_median_S_T)])
title('Under movement')
%% Figures
figure
plot(t_axis,smooth(nanmean(ivel_s_array,1),20))
hold on; plot(t_axis,smooth(nanmean(ivel_t_array,1),20),'r')
xlabel('Time s')
ylabel('Instantaneous speed cm/s')
legend({'Sample', 'Test'})
edge = 1:12;
ns = hist(median_vel_s,edge);
nt = hist(median_vel_t,edge);
figure
plot(edge,ns)
hold on
plot(edge,nt,'r')
xlabel('Median speed cm/s')
ylabel('N')
legend({'Sample', 'Test'})

%%
close all
edge_inst = 0.1:0.1:50;
clear hist_s hist_t
for k = 1:size(ivel_s_array,1)
    hist_s(k,:) = hist(ivel_s_array(k,:),edge_inst);
    hist_t(k,:) = hist(ivel_t_array(k,:),edge_inst);
    figure(k)
    semilogy(edge_inst,hist_s(k,:),'linewidth',2)
    hold on
    semilogy(edge_inst,hist_t(k,:),'r','linewidth',2)
    title(['animal ' num2str(k)])
    ylabel('N')
    xlabel('Instantaneous speed cm/s')
    pause
end

hist_all = hist([reshape(ivel_s_array,[size(ivel_s_array,1)*size(ivel_s_array,2) 1]); ...
    reshape(ivel_t_array,[size(ivel_t_array,1)*size(ivel_t_array,2) 1])],edge_inst);
figure
semilogy(edge_inst,hist_all,'k','linewidth',2)
title(['All population'])
ylabel('N')
xlabel('Instantaneous speed cm/s')
%% analisis de detenciones

for k = 1:size(ivel_s_array)
    stop_pc_s(k,1) = 100*(sum(ivel_s_array(k,:) <= lim_speed)/fr_axis)/time_s(k);
    stop_pc_t(k,1) = 100*(sum(ivel_t_array(k,:) <= lim_speed)/fr_axis)/time_t(k);
    mov_pc_s(k,1) = 100 - stop_pc_s(k,1);
    mov_pc_t(k,1) = 100 - stop_pc_t(k,1);
end

[~,p] = kstest(zscore(stop_pc_s));
[~,p] = kstest(zscore(stop_pc_t));
[~,p] = kstest(zscore(mov_pc_s));
[~,p] = kstest(zscore(mov_pc_t));

[~,p_stop] = ttest(stop_pc_s,stop_pc_t);
[~,p_mov] = ttest(mov_pc_s,mov_pc_t);

figure
plot(1,stop_pc_s,'ko')
hold on
plot(2,stop_pc_t,'ko')
plot([0.75 1.25],[mean(stop_pc_s) mean(stop_pc_s)],'k','linewidth',4)
plot([1.75 2.25],[mean(stop_pc_t) mean(stop_pc_t)],'k','linewidth',4)
xlim([0.5 2.5])
set(gca,'xtick',[1 2],'xticklabel',{'Sample' 'Test'})
ylabel('Stop time (%)')
% [a,b] = hist(inter_hs_all,500);
% ylim([0 15])
legend(['p = ' num2str(p_stop)])
title('Stop time')
ylim([0 50])
%% 

for k = 1:size(fr_spk_hs_s_t,1)
    non_zero_frate_s = fr_spk_hs_s_t{k,1}(:,1) > 0;
    non_zero_frate_t = fr_spk_hs_s_t{k,2}(:,1) > 0;
    if sum(non_zero_frate_s) > 0 & sum(non_zero_frate_t) > 0
        [r_s(k),p_s(k)] = corr(fr_spk_hs_s_t{k,1}(non_zero_frate_s,1),fr_spk_hs_s_t{k,1}(non_zero_frate_s,2));
        [r_t(k),p_t(k)] = corr(fr_spk_hs_s_t{k,2}(non_zero_frate_t,1),fr_spk_hs_s_t{k,2}(non_zero_frate_t,2));
    end
end
