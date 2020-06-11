function xy_nojumps = rmjumps(xy, dist_thres)
% xy_nojumps = rmjumps(xy, dist_thres)
%
% This function removes (set to NaNs) artefactual jumps in the animal tracking detection that occurr when another object is detected instead of the animal (cable, maze walls, objects, etc). The idea is to run an interpolation of the actual xy points after running this function to obtain a continuous trajectory.
%
% To do this, the function computes the distance traveled between all adjacent points in the xy file, and replace with NaNs all outliers distances (>5 scaled median absolute deviations). This function also takes into account the possibility that after a jump there could be more than 1 detection in the artefactual place. Thus, considering that after an artefactual jump it should also occur another jump to return to the correct trajectory, the code asumes that if the distance between 2 jumps is too short (dist_thres), all the point between them are also artefactual.

if nargin < 2
	dist_thres = 15;
end
dists = [0; arrayfun(@(t) pdist(xy(t:t+1,:)),1:size(xy,1)-1)']; % compute distance between consecutive frames (pixels/frame)
% dnorm = nan(size(dists));
% dnorm(~isnan(dists)) = zscore(dists(~isnan(dists)));
% jump_thres = 2;

torm = false(size(xy,1),1);
ath = find(isoutlier(dists,'movmedian',50,'thresholdfactor',5));
% ath = find(dnorm>jump_thres);
torm(ath) = true;

for a = 1:length(ath)-1
	if (ath(a+1)-ath(a))<dist_thres
		torm(ath(a):ath(a+1)) = true;
	end
end
xy_nojumps = xy;
xy_nojumps(torm,:) = nan;
% clc
% %% plots
% 
% % plot trajectories without changes
% figure(3564);clf;
% ax1 = subplot(2,3,1);
% plot(trajectories(:,1),trajectories(:,2),'-','linewidth',2,'color',[.6 .6 .6])
% axis square
% axis off
% xlim([0 960])
% ylim([0 720])
% 
% % plot txy_t without changes
% txy_raw = mktxy(tsp,[],trajectories);
% ax2 = subplot(2,3,4);
% plot(txy_raw(:,2),txy_raw(:,3),'-','linewidth',2,'color',[.6 .6 .6])
% axis square
% axis off
% xlim([0 960])
% ylim([0 720])
% 
% % plot trajectories applying 5SD distance threshold
% traj2 = trajectories;
% traj2(dnorm>5,:) = nan;
% ax3 = subplot(2,3,2);
% plot(traj2(:,1),traj2(:,2),'-','linewidth',2,'color',[.6 .6 .6])
% axis square
% axis off
% xlim([0 960])
% ylim([0 720])
% 
% % plot txy_t after applying 5SD distance threshold
% txy2 = mktxy(tsp,[],traj2);
% ax4 = subplot(2,3,5);
% plot(txy2(:,2),txy2(:,3),'-','linewidth',2,'color',[.6 .6 .6])
% axis square
% axis off
% xlim([0 960])
% ylim([0 720])
% 
% % plot trajectories applying 5SD threshold and distance threshold between >5SD points
% traj3 = trajectories;
% traj3(torm,:) = nan;
% ax5 = subplot(2,3,3);
% plot(traj3(:,1),traj3(:,2),'-','linewidth',2,'color',[.6 .6 .6])
% axis square
% axis off
% xlim([0 960])
% ylim([0 720])
% 
% % plot txy_t after applying 5SD threshold and distance threshold between >5SD points
% txy3 = mktxy(tsp,[],traj3);
% ax6 = subplot(2,3,6);
% plot(txy3(:,2),txy3(:,3),'-','linewidth',2,'color',[.6 .6 .6])
% axis square
% axis off
% xlim([0 960])
% ylim([0 720])
% 
% 
% linkaxes([ax1 ax2 ax3 ax4 ax5 ax6],'xy')
% 
% 
% %%
% figure(678);clf;
% plot(txy_raw(:,2),txy_raw(:,3),'-','linewidth',2)
% hold on
% plot(txy2(:,2),txy2(:,3),'-','linewidth',2)
% plot(txy3(:,2),txy3(:,3),'-','linewidth',2)
% %%
% figure(562);clf;
% plot(trajectories(:,1),trajectories(:,2),'-','linewidth',2)
% hold on
% plot(traj2(:,1),traj2(:,2),'-','linewidth',2)
% plot(traj3(:,1),traj3(:,2),'-','linewidth',2)
% 
% %% removing jumps, using tsp file
% clear;clc;
% tsp = importdata('GV16_OPR8S_15092018_S.tsp');
% load('vertices_S.mat')
% tsp(tsp == -1) = nan;
% 
% 
% jump_thres = 2;
% dist_thres = 14;
% 
% dists = [0; arrayfun(@(t) pdist(tsp(t:t+1,[6 7])),1:size(tsp,1)-1)']; % compute distance between consecutive frames (pixels/frame)
% dnorm = nan(size(dists));
% dnorm(~isnan(dists)) = zscore(dists(~isnan(dists)));
% 
% torm = false(size(tsp,1),1);
% ath = find(isoutlier(dists,'movmedian',50,'thresholdfactor',5));
% % ath = find(dnorm>jump_thres);
% torm(ath) = true;
% 
% for a = 1:length(ath)-1
% 	if (ath(a+1)-ath(a))<dist_thres
% 		torm(ath(a):ath(a+1)) = true;
% 	end
% end
% 
% clc
% %% plots
% 
% % plot trajectories without changes
% figure(3564);clf;
% ax1 = subplot(2,3,1);
% plot(tsp(:,6),tsp(:,7),'-','linewidth',2,'color',[.6 .6 .6])
% axis square
% axis off
% xlim([0 960])
% ylim([0 720])
% 
% % plot txy_t without changes
% txy_raw = mktxy(tsp,vertices);
% ax2 = subplot(2,3,4);
% plot(txy_raw(:,2),txy_raw(:,3),'-','linewidth',2,'color',[.6 .6 .6])
% axis square
% axis off
% xlim([0 960])
% ylim([0 720])
% 
% % plot trajectories applying 5SD distance threshold
% traj2 = tsp;
% traj2(dnorm>5,[6 7]) = nan;
% ax3 = subplot(2,3,2);
% plot(traj2(:,6),traj2(:,7),'-','linewidth',2,'color',[.6 .6 .6])
% axis square
% axis off
% xlim([0 960])
% ylim([0 720])
% 
% % plot txy_t after applying 5SD distance threshold
% txy2 = mktxy(traj2,vertices);
% ax4 = subplot(2,3,5);
% plot(txy2(:,2),txy2(:,3),'-','linewidth',2,'color',[.6 .6 .6])
% axis square
% axis off
% xlim([0 960])
% ylim([0 720])
% 
% % plot trajectories applying 5SD threshold and distance threshold between >5SD points
% traj3 = tsp;
% traj3(torm,:) = nan;
% ax5 = subplot(2,3,3);
% plot(traj3(:,6),traj3(:,7),'-','linewidth',2,'color',[.6 .6 .6])
% axis square
% axis off
% xlim([0 960])
% ylim([0 720])
% 
% % plot txy_t after applying 5SD threshold and distance threshold between >5SD points
% txy3 = mktxy(traj3,vertices);
% ax6 = subplot(2,3,6);
% plot(txy3(:,2),txy3(:,3),'-','linewidth',2,'color',[.6 .6 .6])
% axis square
% axis off
% xlim([0 960])
% ylim([0 720])
% 
% 
% linkaxes([ax1 ax2 ax3 ax4 ax5 ax6],'xy')
% 
% %%
% figure(678);clf;
% plot(txy_raw(:,2),txy_raw(:,3),'-','linewidth',2)
% hold on
% plot(txy2(:,2),txy2(:,3),'-','linewidth',2)
% plot(txy3(:,2),txy3(:,3),'-','linewidth',2)
% %%
% figure(562);clf;
% plot(tsp(:,6),tsp(:,7),'-','linewidth',2)
% hold on
% plot(traj2(:,6),traj2(:,7),'-','linewidth',2)
% plot(traj3(:,6),traj3(:,7),'-','linewidth',2)
% 
% 
% 
