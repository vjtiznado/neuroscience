%% 
clear;clc;
basal_dir = 'E:\Gonzalo\Exp GV11 - GV12 Mayo 2018\GV11\rec_02_OPR1/';
if ~strcmp(basal_dir(end),'/') && ~strcmp(basal_dir(end),'\'), basal_dir = [basal_dir '/']; end
taskname = strsplit(basal_dir,'/');
taskname = taskname{end-1};
cd(basal_dir)
if strcmp(taskname(8:10),'OPR') % OPR recording
	txys = [dir('txy*S.mat'); dir('txy*T.mat')];
	spks = [dir('spk*S_*mat');dir('spk*T_*mat')];
	pixcms = [dir('pix_per*S*mat'); dir('pix_per*T*mat')];
	tags = {'S' 'T'};
elseif strcmp(taskname(8:10),'REM') % remapping recording
	txys = dir('txy*_R*.mat');
	spks = dir('spk*R_*mat');
	pixcms = dir('pix_per*R*mat');
	tags = {'RA1' 'RA2' 'RB1' 'RB2'};
end

m = 1;
load(txys(m).name)
tagspks = dir(['spk*' tags{m} '_*']);

s = 1;
load(tagspks(s).name)
clc;

%%
clc;
ivel = [0; arrayfun(@(t) pdist(txy(t:t+1,[2 3])),1:size(txy,1)-1)']; % computing distance between consecutive frames (pixels/frame)
ivel = ivel/pix_per_cm; % from pixels to cm, distance is now in cm/frame
ivel = ivel*video_sr; % from frames to seconds, now instant velocity is in cm/s
figure(287)
set(gcf,'color','w')
time = (1:length(ivel))/14;
for t = 1:size(txy,1)
	subplot(2,1,1)
	plot(txy(1:t,2),txy(1:t,3),'k-','linewidth',3)
	xlim([min(txy(:,2))-10 max(txy(:,2))+10]);
	ylim([min(txy(:,3))-10 max(txy(:,3))+10]);
	axis square
	axis off

	subplot(2,1,2)
	plot(time(1:t),ivel(1:t),'k-','linewidth',3)
	hold on
	plot([0 length(ivel)],[5 5],'r-','linewidth',2)
	hold off
	set(gca,'fontsize',22,'box','off','linewidth',2)
	xlabel('time (s)','fontsize',22)
	ylabel('velocity (cm/s)','fontsize',24)
	xlim([time(t)-1 time(t)+.5])
	ylim([min(ivel(1:t)) max(ivel(1:t))+2])
	set(gcf,'color','w')

	pause(1/(14*2))
end


spikes_vel = interp1(txy(:,1),ivel, spikes);
