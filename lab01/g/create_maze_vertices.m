%% This code makes you define the vertices of the maze of all the recordings you have, by interactively clicking on each vertice of the plotted videoframe and then pressing enter when you are ready. For circular mazes, just click as much as you want to simulate a circle.
% This maze vertices will be used to discard incorrect animal tracking detections, and to then interpolate all the correctly detected points to end up with a continuous animal tracking vector
clear;clc;
if ismac
	basal_dir = '/Users/vjtiznado/Documents/labpf/GV/';
elseif isunix
	basal_dir = '/media/labpf/3er_piso_Lab_PF/GVU/Gonzalo/'; % linux
elseif ispc
	basal_dir = 'E:\Gonzalo\'; % windows
end
if ~strcmp(basal_dir(end),'/') && ~strcmp(basal_dir(end),'\'), basal_dir = [basal_dir '/']; end

edir = dir([basal_dir 'Exp*']);
disp('detecting maze vertices...')
for e = 3:size(edir,1)
	adir = dir([basal_dir edir(e).name '/GV*']);
	for a = 2:size(adir,1)
		rdir = dir([basal_dir edir(e).name '/' adir(a).name '/rec*']);
		for r = 1:size(rdir,1)
			cd([basal_dir edir(e).name '/' adir(a).name '/' rdir(r).name '/']);
			if strcmp(rdir(r).name(8:10),'OPR')
				videos = [dir('*_S.mpg'); dir('*_T.mpg')]; % videos only for sample and test recordings
			else
				videos = dir('*_R*.mpg'); % remapping recordings
			end
			% if size(dir('traj*mat'),1) > 0 || size(dir('maze_v*mat'),1) > 0, continue; end % do not run the function if the vertices were already created or if animal tracking was performed using idtracker, since running this would be redundant
			mkvert(videos,size(videos,1));
			clear videos
			cd(basal_dir)
		end
	end
end
disp('ready')

