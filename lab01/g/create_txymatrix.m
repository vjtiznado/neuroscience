%% This code creates the txy_matrix for all your recordings. This matrix corresponds to the tracking of the animal position on each frame of the recorded video. txy_matrix will be a n_framesx3 matrix:
% 		- The first column has the timestamps of each frame of the video in miliseconds
% 		- The second column has the position in the x dimension
%		- The third column has the position in the y dimension
%
% For further information about this process, type 'help mktxy' in the command window, which is the function used to create the matrix in this script
 
clear;clc;
if isunix
	basal_dir = '/media/labpf/3er_piso_Lab_PF/GVU/Gonzalo/'; % linux
elseif ispc
	basal_dir = 'E:\Gonzalo\'; % windows
end
if ~strcmp(basal_dir(end),'/') && ~strcmp(basal_dir(end),'\'), basal_dir = [basal_dir '/']; end

edir = dir([basal_dir 'Exp*']);
disp('creating txy matrices...')
for e = 1:size(edir,1)
	adir = dir([basal_dir edir(e).name '/GV*']);
	for a = 1:size(adir,1)
		rdir = dir([basal_dir edir(e).name '/' adir(a).name '/rec*']);
		for r = 1:size(rdir,1)
			cd([basal_dir edir(e).name '/' adir(a).name '/' rdir(r).name '/']);
			% loading data needed to compute the function
            if strcmp(rdir(r).name(8:10),'OPR') % OPR recording
                tsps = [dir('*S.tsp'); dir('*T.tsp')];
                trajs = [dir('traj*sample.mat'); dir('traj*test.mat')];
                meta_dir = [dir('*S.meta'); dir('*T.meta')];
                tags = {'S' 'T'};
                % elseif strcmp(rdir(r).name(8:10),'REM') % remapping recording
                % tsps = dir('*_R*.tsp');
                % trajs = dir('traj*R*.mat');
                % meta_dir = dir('*_R*.meta');
                % tags = {'RA1' 'RA2' 'RB1' 'RB2'};
            else
                continue
            end
			if ~exist('tsps','var')% || size(dir('txy_matrix*'),1) > 0
				continue
			end
			verts = dir('vertices*mat');
			for m = 1:size(tsps,1)
				meta = importdata(meta_dir(m).name,'\t'); % read the amplirec .meta file that contains the timestamp of the start of recording (computer clock - ms). This is important because the timestamps of the videoframes in the tsp file are respect to this initial timestamp, thus this number must be sustracted 
                tsp = importdata(tsps(m).name);
                if size(trajs,1) == 0 || all(strcmp(adir(a).name,'GV15') && strcmp(rdir(r).name,'rec_06_OPR10') && m==1)
                    load(verts(m).name);
                    txy = mktxy(meta,tsp,vertices);
                elseif size(trajs,1) ~= 0 || all(strcmp(adir(a).name,'GV15') && strcmp(rdir(r).name,'rec_06_OPR10') && m==2)
                    load(trajs(m).name,'trajectories');
                    txy = mktxy(meta,tsp,[],trajectories);
                end
                t_units = 'ms'; xy_units = 'pixels';
				save(['txy_matrix_' tags{m} '.mat'],'txy','t_units','xy_units')
				clear ts_ini tsp trajectories txy
			end
		       clear tsps maze_verts
		end
	end
end
cd(basal_dir)
clear;clc
disp('ready')
