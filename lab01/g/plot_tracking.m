%%
clear
% cd('F:\TSP\')
rec = 'GV01_02_09_COPR_T.tsp';
tsp = importdata(rec);

%%
clc
tsp(tsp(:,6) == -1,[6 7]) = nan;
% tsp(tsp(:,6) > 500,[6 7]) = nan;
figure(2)
clf
plot(tsp(:,6),tsp(:,7),'color',[.6 .6 .6])
xlim([100 700])
ylim([0 600])

disp(' ')
disp(rec)
disp(['number of samples = ' num2str(size(tsp,1))])
disp(['discarded detections = ' num2str(sum(isnan(tsp(:,6)))*100/size(tsp,1)) '%'])
disp(' ')

%%
clear;clc
all_tsp = dir('*.tsp');
all_tsp = {all_tsp.name}';
tsps = arrayfun(@(t) importdata(all_tsp{t,1}),1:size(all_tsp,1),'uniformoutput',false)';

clf
if size(tsps,1)==1
    tsp(tsp(:,6) == -1,[6 7]) = nan;
    % tsp(tsp(:,6) > 500,[6 7]) = nan;
    plot(tsp(end-25000:end,6),tsp(end-25000:end,7),'color',[.6 .6 .6])
    xlim([100 700])
    ylim([0 600])
    
    disp(' ')
    disp(rec)
    disp(['number of samples = ' num2str(size(tsp,1))])
    disp(['discarded detections = ' num2str(sum(isnan(tsp(:,6)))*100/size(tsp,1)) '%'])
else
    for j = 1:size(tsps,1)
        disp(' ')
        disp(all_tsp{j,1})
        subplot(2,3,j)
        tsps{j,1}(tsps{j,1}(:,6) == -1,[6 7]) = nan;
        % tsp(tsp(:,6) > 500,[6 7]) = nan;
        plot(tsps{j,1}(:,6),tsps{j,1}(:,7),'color',[.6 .6 .6])
        xlim([100 700])
        ylim([0 600])
        title(all_tsp{j,1},'interpreter','none')
        
        disp(['number of samples = ' num2str(size(tsps{j,1},1))])
        disp(['discarded detections = ' num2str(sum(isnan(tsps{j,1}(:,6)))*100/size(tsps{j,1},1)) '%'])
        hold on
        set(gcf,'color','w')
    end
end
%%
%%

% cd('F:\TSP\')
rec = 'GV01_02_07_R2_2.tsp';
tsp = load(rec);
figure(2)
plot(tsp(1,6),tsp(1,7),'color',[.6 .6 .6])
xlim([100 700])
ylim([0 600])
for t = 1:size(tsp,1)
    figure(2)
    plot(tsp(1:t,6),tsp(1:t,7),'color',[.6 .6 .6])
    hold on
    plot(tsp(t,6),tsp(t,7),'ko','markersize',12,'markerfacecolor','k')
    hold off
    xlim([100 700])
    ylim([0 600])
    pause(.05)
end



%%
cd('C:\Users\neuro\Desktop\GV01\GV01_02_04\')
tsp = load('GV01_02_04_T.tsp');
% tsp(tsp(:,6) == -1,[6 7]) = nan;

figure(1)
set(gcf,'color','w')
clf
plot(tsp(1,6),tsp(1,7),'color',[.4 .4 .4],'linewidth',2)
xlim([1 700])
ylim([0 500])

for t = 1:size(tsp,1)
    plot(tsp(1:t,6),tsp(1:t,7),'color',[.4 .4 .4],'linewidth',2)
    xlim([1 700])
    ylim([0 500])
    pause(.1)
end

%% cleaning the first recording, GV01_02_04
clc
cd('C:\Users\neuro\Desktop\GV01\GV01_02_04\')
rec = 'GV01_02_05_A.tsp';
% detecting incorrect detections associated with the objects
% tsp = load(rec);
tsp = tsp_or;
tsp(tsp(:,6) == -1,[6 7]) = 0;
tsp(tsp(:,6) > 500,[6 7]) = 0;
obj_int1 = find(tsp(:,6)>350 & tsp(:,6) < 440);
diff_x1 = nan(size(obj_int1,1),1);
diff_y1 = nan(size(obj_int1,1),1);
diff_x2 = nan(size(obj_int1,1),1);
diff_y2 = nan(size(obj_int1,1),1);
diff_log1 = nan(size(obj_int1,1),1);

diff_lim = 50;
for i = 1:(size(obj_int1,1)-1)
    diff_x1(i,1) = abs(tsp(obj_int1(i),6) - tsp(obj_int1(i)-1,6));
    diff_y1(i,1) = abs(tsp(obj_int1(i),7) - tsp(obj_int1(i)-1,7));
    diff_x2(i,1) = abs(tsp(obj_int1(i)+1,6) - tsp(obj_int1(i),6));
    diff_y2(i,1) = abs(tsp(obj_int1(i)+1,7) - tsp(obj_int1(i),7));
    if diff_x1(i) > diff_lim || diff_y1(i) > diff_lim || diff_x2(i) > diff_lim || diff_y2(i) > diff_lim
        diff_log1(i,1) = 1;
    else
        diff_log1(i,1) = 0;
    end
end
diff_log1(end) = 1;
diff_log1 = logical(diff_log1);


% detecting random incorrect detections
tsp = tsp_or;
% tsp = load(rec);
tsp(tsp(:,6) == -1,[6 7]) = 0;
tsp(tsp(:,6) > 500,[6 7]) = 0;
obj_int2 = 1:size(tsp,1);
obj_int2 = obj_int2';
diff_x1 = nan(size(obj_int2,1),1);
diff_y1 = nan(size(obj_int2,1),1);
diff_x2 = nan(size(obj_int2,1),1);
diff_y2 = nan(size(obj_int2,1),1);
diff_log2 = nan(size(obj_int2,1),1);

diff_lim = 50;
for i = 1:(size(obj_int2,1)-1)
    if i >1
    diff_x1(i,1) = abs(tsp(obj_int2(i),6) - tsp(obj_int2(i)-1,6));
    diff_y1(i,1) = abs(tsp(obj_int2(i),7) - tsp(obj_int2(i)-1,7));
    else
    end
    diff_x2(i,1) = abs(tsp(obj_int2(i)+1,6) - tsp(obj_int2(i),6));
    diff_y2(i,1) = abs(tsp(obj_int2(i)+1,7) - tsp(obj_int2(i),7));
    if diff_x1(i) > diff_lim || diff_y1(i) > diff_lim || diff_x2(i) > diff_lim || diff_y2(i) > diff_lim
        diff_log2(i,1) = 1;
    else
        diff_log2(i,1) = 0;
    end
end
diff_log2(end) = 1;
diff_log2 = logical(diff_log2);


% discarding all the incorrect detections
% tsp = load(rec);
tsp = tsp_or;
tsp(tsp(:,6) == -1,[6 7]) = nan;
tsp(tsp(:,6) > 500,[6 7]) = nan;
tsp(obj_int1(diff_log1),[6 7]) = nan;
tsp(obj_int2(diff_log2),[6 7]) = nan;

disp(rec)
disp(['number of samples = ' num2str(size(tsp,1))])
disp(['discarded detections = ' num2str(sum(isnan(tsp(:,6)))*100/size(tsp,1)) '%'])

figure(2)
clf
set(gcf,'color','w')
% subplot(1,2,1)
% plot(tsp(:,6),tsp(:,7),'color',[.6 .6 .6])
% xlim([0 700])
% ylim([0 500])
% 
% figure(2)
% subplot(1,2,2)
plot(tsp(1,6),tsp(1,7),'color',[.6 .6 .6])
xlim([0 700])
ylim([0 500])
for t = 1:size(tsp,1)
    plot(tsp(1:t,6),tsp(1:t,7),'color',[.6 .6 .6])
    hold on
    plot(tsp(t,6),tsp(t,7),'ko','markersize',12,'markerfacecolor','k')
    hold off
    xlim([1 700])
    ylim([0 500])
    pause(.05)
end
