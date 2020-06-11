%%

figure(1);clf;
plot(txy_matrix(:,2),txy_matrix(:,3),'-','color',[.6 .6 .6])
axis ij
colorbar
hold on
plot(spikes_xy(:,1),spikes_xy(:,2),'r.','markersize',10)    
title('raw plot','fontsize',20)
ylim([0 720]);xlim([0 960])

figure(2);clf;
imagesc(hist_xy{1},hist_xy{2},rot90(sfrmap))
colorbar
title('smoothed firing rate map','fontsize',20)
ylim([0 720]);xlim([0 960])

figure(3);clf;
imagesc(hist_xy{1},hist_xy{2},ocmap')
colorbar
title('occupancy map','fontsize',20)
ylim([0 720]);xlim([0 960])

figure(4);clf;
imagesc(hist_xy{1},hist_xy{2},rot90(fmap))
colorbar
title('raw firing rate map','fontsize',20)
ylim([0 720]);xlim([0 960])


%% using pcolor. looks better
load('vertices_S.mat')
load('spk_GV16_OPR8_tt1_S_1.mat')

%%
% raw plot
figure(10);clf;
plot(txy(:,2),txy(:,3),'-','color',[.6 .6 .6],'linewidth',2.5)
hold on
plot(spikes_xy(:,1),spikes_xy(:,2),'r.','markersize',15)    
plot(vertices.maze(:,1),vertices.maze(:,2),'-','color',[1 .5 .5],'linewidth',5)
plot(vertices.obj1(:,1),vertices.obj1(:,2),'-','color',[1 .5 .5],'linewidth',5)
plot(vertices.obj2(:,1),vertices.obj2(:,2),'-','color',[1 .5 .5],'linewidth',5)
axis ij
axis square
axis off
colorbar
axis square
title('raw plot','fontsize',20)
% xlim([0 960])
% ylim([0 720])
xlim([min(vertices.maze(:,1))-10 max(vertices.maze(:,1))+10]);
ylim([min(vertices.maze(:,2))-10 max(vertices.maze(:,2))+10]);
set(gcf,'color','w')

% smoothed firing rate map
figure(20);clf;
pcolor(hist_xy{1},hist_xy{2},sfrmap')
hold on
plot(vertices.maze(:,1),vertices.maze(:,2),'-','color',[1 .5 .5],'linewidth',5)
plot(vertices.obj1(:,1),vertices.obj1(:,2),'-','color',[1 .5 .5],'linewidth',5)
plot(vertices.obj2(:,1),vertices.obj2(:,2),'-','color',[1 .5 .5],'linewidth',5)
axis ij
axis square
axis off
shading flat
colorbar
title('smoothed firing rate map','fontsize',20)
% ylim([0 720]);xlim([0 960])
xlim([min(vertices.maze(:,1))-10 max(vertices.maze(:,1))+10]);
ylim([min(vertices.maze(:,2))-10 max(vertices.maze(:,2))+10]);
set(gcf,'color','w')

figure(30);clf;
pcolor(hist_xy{1},hist_xy{2},ocmap')
hold on
plot(vertices.maze(:,1),vertices.maze(:,2),'-','color',[1 .5 .5],'linewidth',5)
plot(vertices.obj1(:,1),vertices.obj1(:,2),'-','color',[1 .5 .5],'linewidth',5)
plot(vertices.obj2(:,1),vertices.obj2(:,2),'-','color',[1 .5 .5],'linewidth',5)
axis ij
axis square
axis off
shading flat
colorbar
title('occupancy map','fontsize',20)
% ylim([0 720]);xlim([0 960])
xlim([min(vertices.maze(:,1))-10 max(vertices.maze(:,1))+10]);
ylim([min(vertices.maze(:,2))-10 max(vertices.maze(:,2))+10]);
set(gcf,'color','w')


figure(40);clf;
pcolor(hist_xy{1},hist_xy{2},fmap')
hold on
plot(vertices.maze(:,1),vertices.maze(:,2),'-','color',[1 .5 .5],'linewidth',5)
plot(vertices.obj1(:,1),vertices.obj1(:,2),'-','color',[1 .5 .5],'linewidth',5)
plot(vertices.obj2(:,1),vertices.obj2(:,2),'-','color',[1 .5 .5],'linewidth',5)
axis ij
axis square
axis off
shading flat
colorbar
title('firing map','fontsize',20)
% ylim([0 720]);xlim([0 960])
xlim([min(vertices.maze(:,1))-10 max(vertices.maze(:,1))+10]);
ylim([min(vertices.maze(:,2))-10 max(vertices.maze(:,2))+10]);
set(gcf,'color','w')


figure(50);clf;
pcolor(hist_xy{1},hist_xy{2},frmap')
hold on
plot(vertices.maze(:,1),vertices.maze(:,2),'-','color',[1 .5 .5],'linewidth',5)
plot(vertices.obj1(:,1),vertices.obj1(:,2),'-','color',[1 .5 .5],'linewidth',5)
plot(vertices.obj2(:,1),vertices.obj2(:,2),'-','color',[1 .5 .5],'linewidth',5)
axis ij
axis off
axis square
shading flat
colorbar
title('raw firing rate map','fontsize',20)
% ylim([0 720]);xlim([0 960])
xlim([min(vertices.maze(:,1))-10 max(vertices.maze(:,1))+10]);
ylim([min(vertices.maze(:,2))-10 max(vertices.maze(:,2))+10]);
set(gcf,'color','w')

%%
clear
load('vertices_S.mat')
load('spk_GV15_OPR7_tt2_S_1.mat')


% raw plot
figure(6749);clf;
subplot(5,2,1);cla;
plot(txy(:,2),txy(:,3),'-','color',[.6 .6 .6],'linewidth',2.5)
hold on
colorbar
plot(spikes_xy(:,1),spikes_xy(:,2),'r.','markersize',15)    
% plot(vertices.maze(:,1),vertices.maze(:,2),'-','color',[1 .5 .5],'linewidth',3)
% plot(vertices.obj1(:,1),vertices.obj1(:,2),'-','color',[1 .5 .5],'linewidth',2)
% plot(vertices.obj2(:,1),vertices.obj2(:,2),'-','color',[1 .5 .5],'linewidth',2)
axis ij
axis square
axis off

axis square
title('raw plot','fontsize',10)
% xlim([0 960])
% ylim([0 720])
xlim([min(vertices.maze(:,1))-10 max(vertices.maze(:,1))+10]);
ylim([min(vertices.maze(:,2))-10 max(vertices.maze(:,2))+10]);
set(gcf,'color','w')

% smoothed firing rate map
subplot(5,2,3);cla;
pcolor(hist_xy{1},hist_xy{2},sfrmap')
colormap jet
colorbar
caxis([0 max(max(sfrmap))])
% caxis([0 4])
hold on
% plot(vertices.maze(:,1),vertices.maze(:,2),'-','color',[1 .5 .5],'linewidth',3)
% plot(vertices.obj1(:,1),vertices.obj1(:,2),'-','color',[1 .5 .5],'linewidth',2)
% plot(vertices.obj2(:,1),vertices.obj2(:,2),'-','color',[1 .5 .5],'linewidth',2)
axis ij
axis square
axis off
shading flat
title('smoothed firing rate map','fontsize',10)
% ylim([0 720]);xlim([0 960])
xlim([min(vertices.maze(:,1))-10 max(vertices.maze(:,1))+10]);
ylim([min(vertices.maze(:,2))-10 max(vertices.maze(:,2))+10]);
set(gcf,'color','w')

%%
%OCUPANCY MAP
subplot(5,2,5);cla;
pcolor(hist_xy{1},hist_xy{2},ocmap')
colormap jet
colorbar
caxis([0 max(max(ocmap))])
hold on
% plot(vertices.maze(:,1),vertices.maze(:,2),'-','color',[1 .5 .5],'linewidth',3)
% plot(vertices.obj1(:,1),vertices.obj1(:,2),'-','color',[1 .5 .5],'linewidth',2)
% plot(vertices.obj2(:,1),vertices.obj2(:,2),'-','color',[1 .5 .5],'linewidth',2)
axis ij
axis square
axis off
shading flat

title('occupancy map','fontsize',10)
% ylim([0 720]);xlim([0 960])
xlim([min(vertices.maze(:,1))-10 max(vertices.maze(:,1))+10]);
ylim([min(vertices.maze(:,2))-10 max(vertices.maze(:,2))+10]);
set(gcf,'color','w')

%FIRING MAP

subplot(5,2,7);cla;
pcolor(hist_xy{1},hist_xy{2},fmap')
colormap jet
colorbar
caxis([0 max(max(fmap))])
hold on
% plot(vertices.maze(:,1),vertices.maze(:,2),'-','color',[1 .5 .5],'linewidth',3)
% plot(vertices.obj1(:,1),vertices.obj1(:,2),'-','color',[1 .5 .5],'linewidth',2)
% plot(vertices.obj2(:,1),vertices.obj2(:,2),'-','color',[1 .5 .5],'linewidth',2)
axis ij
axis square
axis off
shading flat
title('firing map','fontsize',10)
% ylim([0 720]);xlim([0 960])
xlim([min(vertices.maze(:,1))-10 max(vertices.maze(:,1))+10]);
ylim([min(vertices.maze(:,2))-10 max(vertices.maze(:,2))+10]);
set(gcf,'color','w')

%RAW FIRING RATE MAP
subplot(5,2,9);cla;
pcolor(hist_xy{1},hist_xy{2},frmap')
colormap jet
colorbar
caxis([0 max(max(frmap))])
hold on
% plot(vertices.maze(:,1),vertices.maze(:,2),'-','color',[1 .5 .5],'linewidth',3)
% plot(vertices.obj1(:,1),vertices.obj1(:,2),'-','color',[1 .5 .5],'linewidth',2)
% plot(vertices.obj2(:,1),vertices.obj2(:,2),'-','color',[1 .5 .5],'linewidth',2)
axis ij
axis off
axis square
shading flat
title('raw firing rate map','fontsize',10)
% ylim([0 720]);xlim([0 960])
xlim([min(vertices.maze(:,1))-10 max(vertices.maze(:,1))+10]);
ylim([min(vertices.maze(:,2))-10 max(vertices.maze(:,2))+10]);
set(gcf,'color','w')

clear
load('vertices_T.mat')
load('spk_GV15_OPR6_tt8_T_8.mat')

% raw plot
% figure(6749);clf;
subplot(5,2,2);cla;
plot(txy(:,2),txy(:,3),'-','color',[.6 .6 .6],'linewidth',2.5)
hold on
plot(spikes_xy(:,1),spikes_xy(:,2),'r.','markersize',15)    
% plot(vertices.maze(:,1),vertices.maze(:,2),'-','color',[1 .5 .5],'linewidth',3)
% plot(vertices.obj1(:,1),vertices.obj1(:,2),'-','color',[1 .5 .5],'linewidth',2)
% plot(vertices.obj2(:,1),vertices.obj2(:,2),'-','color',[1 .5 .5],'linewidth',2)
axis ij
axis square
axis off

axis square
title('raw plot','fontsize',10)
% xlim([0 960])
% ylim([0 720])
xlim([min(vertices.maze(:,1))-10 max(vertices.maze(:,1))+10]);
ylim([min(vertices.maze(:,2))-10 max(vertices.maze(:,2))+10]);
set(gcf,'color','w')

% smoothed firing rate map
subplot(5,2,4);cla;
pcolor(hist_xy{1},hist_xy{2},sfrmap')
colormap jet
colorbar
caxis([0 max(max(sfrmap))])
% caxis([0 4])
hold on
% plot(vertices.maze(:,1),vertices.maze(:,2),'-','color',[1 .5 .5],'linewidth',3)
% plot(vertices.obj1(:,1),vertices.obj1(:,2),'-','color',[1 .5 .5],'linewidth',2)
% plot(vertices.obj2(:,1),vertices.obj2(:,2),'-','color',[1 .5 .5],'linewidth',2)
axis ij
axis square
axis off
shading flat
title('smoothed firing rate map','fontsize',10)
% ylim([0 720]);xlim([0 960])
xlim([min(vertices.maze(:,1))-10 max(vertices.maze(:,1))+10]);
ylim([min(vertices.maze(:,2))-10 max(vertices.maze(:,2))+10]);
set(gcf,'color','w')

%OCUPANCY MAP
subplot(5,2,6);cla;
pcolor(hist_xy{1},hist_xy{2},ocmap')
colormap jet
colorbar
caxis([0 max(max(ocmap))])
hold on
% plot(vertices.maze(:,1),vertices.maze(:,2),'-','color',[1 .5 .5],'linewidth',3)
% plot(vertices.obj1(:,1),vertices.obj1(:,2),'-','color',[1 .5 .5],'linewidth',2)
% plot(vertices.obj2(:,1),vertices.obj2(:,2),'-','color',[1 .5 .5],'linewidth',2)
axis ij
axis square
axis off
shading flat
title('occupancy map','fontsize',10)
% ylim([0 720]);xlim([0 960])
xlim([min(vertices.maze(:,1))-10 max(vertices.maze(:,1))+10]);
ylim([min(vertices.maze(:,2))-10 max(vertices.maze(:,2))+10]);
set(gcf,'color','w')

%FIRING MAP

subplot(5,2,8);cla;
pcolor(hist_xy{1},hist_xy{2},fmap')
colormap jet
colorbar
caxis([0 max(max(fmap))])
hold on
% plot(vertices.maze(:,1),vertices.maze(:,2),'-','color',[1 .5 .5],'linewidth',3)
% plot(vertices.obj1(:,1),vertices.obj1(:,2),'-','color',[1 .5 .5],'linewidth',2)
% plot(vertices.obj2(:,1),vertices.obj2(:,2),'-','color',[1 .5 .5],'linewidth',2)
axis ij
axis square
axis off
shading flat
title('firing map','fontsize',10)
% ylim([0 720]);xlim([0 960])
xlim([min(vertices.maze(:,1))-10 max(vertices.maze(:,1))+10]);
ylim([min(vertices.maze(:,2))-10 max(vertices.maze(:,2))+10]);
set(gcf,'color','w')

%RAW FIRING RATE MAP
subplot(5,2,10);cla;
pcolor(hist_xy{1},hist_xy{2},frmap')
colormap jet
colorbar
caxis([0 max(max(frmap))])
hold on
% plot(vertices.maze(:,1),vertices.maze(:,2),'-','color',[1 .5 .5],'linewidth',3)
% plot(vertices.obj1(:,1),vertices.obj1(:,2),'-','color',[1 .5 .5],'linewidth',2)
% plot(vertices.obj2(:,1),vertices.obj2(:,2),'-','color',[1 .5 .5],'linewidth',2)
axis ij
axis off
axis square
shading flat
title('raw firing rate map','fontsize',10)
% ylim([0 720]);xlim([0 960])
xlim([min(vertices.maze(:,1))-10 max(vertices.maze(:,1))+10]);
ylim([min(vertices.maze(:,2))-10 max(vertices.maze(:,2))+10]);
set(gcf,'color','w')
