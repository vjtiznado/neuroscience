
clear;clc;
if isunix
    basal_dir = '/media/labpf/3er_piso_Lab_PF/GVU/Gonzalo/'; % linux
elseif ispc
    basal_dir = 'E:\Gonzalo\'; % windows
end
if ~strcmp(basal_dir(end),'/') && ~strcmp(basal_dir(end),'\'), basal_dir = [basal_dir '/']; end
cd(basal_dir)
edir = dir('Exp*');
count = 0;
for e = 1:size(edir,1)
    adir = dir([basal_dir edir(e).name '/GV*']);
    for a = 1:size(adir,1)
        rdir = dir([basal_dir edir(e).name '/' adir(a).name '/rec*']);
        for r = 1:size(rdir,1)
            cd([basal_dir edir(e).name '/' adir(a).name '/' rdir(r).name '/']);
            n_cells_s = dir('spk_*_S_*');
            n_cells_t = dir('spk_*_T_*');
            for k = 1:length(n_cells_s)
                count = count + 1;
                name_cell_s{count,1} = n_cells_s(k).name;
                name_cell_t{count,1} = n_cells_t(k).name;
                % load sample values
                load(n_cells_s(k).name,'sfrmap','socmap');
                sfrmap_s = sfrmap;
                clear sfrmap
                socmap_s = socmap;
                clear socmap
                load(n_cells_t(k).name,'sfrmap','socmap');
                sfrmap_t = sfrmap;
                clear sfrmap
                socmap_t = socmap;
                clear socmap
                Spat_R(count,1) = spatial_corr(sfrmap_s,sfrmap_t,socmap_s,socmap_t,0);
                plot(sfrmap_s,sfrmap_t,'o')
                legend(['R = ' num2str(Spat_R(count,1))])
                title([n_cells_s(k).name ' vs. ' n_cells_t(k).name])
                pause
            end
            cd ..
        end
    end
end
spat_corr_table = table(name_cell_s,name_cell_t,Spat_R);