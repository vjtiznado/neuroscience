%% This code is to obtain the pix-to-centimenters ratio from all your recording videos in order to compute distance measures in centimeters when running further analyses 
% 
clear;clc;
if isunix
	basal_dir = '/media/labpf/3er_piso_Lab_PF/GVU/Gonzalo/'; % linux
elseif ispc
	basal_dir = 'E:\Gonzalo\'; % windows
end
if ~strcmp(basal_dir(end),'/') && ~strcmp(basal_dir(end),'\'), basal_dir = [basal_dir '/']; end

maze_length_cm = 65;

edir = dir([basal_dir 'Exp*']);
disp('detecting maze vertices...')
for e = 1:size(edir,1)
	adir = dir([basal_dir edir(e).name '/GV*']);
	for a = 1:size(adir,1)
		rdir = dir([basal_dir edir(e).name '/' adir(a).name '/rec*']);
		for r = 1:size(rdir,1)
			cd([basal_dir edir(e).name '/' adir(a).name '/' rdir(r).name '/']);
			if strcmp(rdir(r).name(8:10),'OPR')
				videos = [dir('*_S.mpg'); dir('*_T.mpg')]; % videos only for sample and test recordings
			% elseif strcmp(rdir(r).name(8:10),'REM') % remapping recording
				% videos = dir('*_R*.mpg');
			end
			if ~exist('videos','var')
				continue
			end
			pix2cm(videos,maze_length_cm,size(videos,1));
			clear videos
		end
	end
end
disp('ready')

