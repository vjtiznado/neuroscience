%% This code is to remove the folder rec_AM from your dataset as it became useless. The code will copy all the files of this folder into the previous folder and then it will delete rec_AM folder

clear;clc;
basal_dir = '/media/labpf/3er_piso_Lab_PF/GVU/Gonzalo/'; % linux
% basal_dir = 'E:\Gonzalo\'; % windows

edir = dir([basal_dir 'Exp*']);

disp('removing rec_AM folders...')
for e = 1:size(edir,1)
	adir = dir([basal_dir edir(e).name '/GV*']);
	for a = 1:size(adir,1)
		rdir = dir([basal_dir edir(e).name '/' adir(a).name '/rec*']);
		for r = 1:size(rdir,1)
			apdir = dir([basal_dir edir(e).name '/' adir(a).name '/' rdir(r).name '/rec*']);
			if size(apdir,1) == 1
				cd([basal_dir edir(e).name '/' adir(a).name '/' rdir(r).name '/' apdir(1).name]);
				allfiles = dir;
				if strcmp(allfiles(1).name,'.') && strcmp(allfiles(2).name,'..')
					arrayfun(@(x) movefile(x.name,[basal_dir edir(e).name '/' adir(a).name '/' rdir(r).name]),allfiles(3:end))
					cd([basal_dir edir(e).name '/' adir(a).name '/' rdir(r).name]);
					rmdir(apdir(1).name)
				end
			end
		end
	end
end
cd(basal_dir)
clear;clc;
disp('ready')
