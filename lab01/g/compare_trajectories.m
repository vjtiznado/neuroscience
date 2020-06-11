%%
% go to the folder of the recording you want to compare
meta = importdata('GV16_OPR10_21092018_t.meta','\t'); % put here the name of the meta file you want to compare
tsp = importdata('GV16_OPR10_21092018_t.tsp'); % put here the name of the tsp file you want to compare
load('vertices_t.mat');

txy = mktxy(meta,tsp,vertices);
tsp(tsp==-1) = nan;

load('trajectories_SAMPLE.mat') % put here the name of the trajectories file you want to compare
txy_t = mktxy(meta,tsp,[],trajectories);

figure(4534);clf
subplot(2,2,1)
plot(tsp(:,6),tsp(:,7),'-','color',[.6 .6 .6],'linewidth',2)
title('raw tsp file','fontsize',20)
axis square

subplot(2,2,3)
plot(txy(:,2),txy(:,3),'-','color',[.6 .6 .6],'linewidth',2)
title('txy based on tsp file','fontsize',20)
axis square

subplot(2,2,2)
plot(trajectories(:,1),trajectories(:,2),'color',[.6 .6 .6],'linewidth',1)
title('raw idtracker file','fontsize',20)
axis square

subplot(2,2,4)
plot(txy_t(:,2),txy_t(:,3),'color',[.6 .6 .6],'linewidth',1)
title('txy based on idtracker file','fontsize',20)
axis square

set(gcf,'color','w')
