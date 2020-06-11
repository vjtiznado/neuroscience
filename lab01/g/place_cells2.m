%% 1. Create maze_vertices matrix for every recording
clear;clc

create_maze_vertices % if you want to change some parameters, open the script in the matlab editor

%% 2. Split spk files to get the spikes on each stage (sample,sleep,test,etc)
clear;clc;

split_spk % if you want to change some parameters, open the script in the matlab editor

%% 3. Create txy_matrix for all recordings
clear;clc;

create_txymatrix % if you want to change some parameters, open the script in the matlab editor

%% 4. Determine the pixels/cm ratio in the video of each recording
clear;clc

compute_pix2cm % if you want to change some parameters, open the script in the matlab editor

%% 5. Create a firing rate map for all neurons
clear;clc;
if isunix
    basal_dir = '/media/labpf/3er_piso_Lab_PF/GVU/Gonzalo/'; % linux
elseif ispc
    basal_dir = 'E:\Gonzalo\'; % windows
end
if ~strcmp(basal_dir(end),'/') && ~strcmp(basal_dir(end),'\'), basal_dir = [basal_dir '/']; end
cd(basal_dir)

ivel_threshold = 5;
interv_det = 5;
edir = dir('Exp*');
disp('creating firing rate maps...')
for e = 1:size(edir,1)
    adir = dir([basal_dir edir(e).name '/GV*']);
    for a = 1:size(adir,1)
        rdir = dir([basal_dir edir(e).name '/' adir(a).name '/rec*']);
        for r = 1:size(rdir,1)
            cd([basal_dir edir(e).name '/' adir(a).name '/' rdir(r).name '/']);
            % loading data to compute firing rate maps
            if strcmp(rdir(r).name(8:10),'OPR') % OPR recording
                txys = [dir('txy*S.mat'); dir('txy*T.mat')];
                pixcms = [dir('pix_per*S.mat'); dir('pix_per*T.mat')];
                tags = {'S' 'T'};
                lans = [dir('LAN*ds*S.mat'); dir('LAN*ds*T.mat')];
                % 			elseif strcmp(rdir(r).name(8:10),'REM') % remapping recording
                % 				txys = dir('txy*_R*.mat');
                % 				pixcms = dir('pix_per*R*mat');
                % 				tags = {'RA1' 'RA2' 'RB1' 'RB2'};
                % 				lans = dir('LAN*ds*R*mat');
            end
            verts = dir('vertices*mat');
            for m = 1:size(txys,1)
                load(verts(m).name);
                load(txys(m).name);
                load(pixcms(m).name)
                load(lans(m).name);
                if isfield(LAN,'RT')
                    RT = LAN.RT;
                end
                clear LAN
                tagspks = dir(['spk*' tags{m} '_*']);
                %                 if size(tagspks,1)==0
                %                     continue
                %                 end
                for s = 1:size(tagspks,1)
                    load(tagspks(s).name,'spikes')
                    if ~exist('video_sr','var')
                        % carga la freq de muestreo video
                        cd ..
                        conducta = dir('conducta*');
                        cd(conducta.name)
                        if strcmp(lans(m).name(end - 4),'S')
                            fold_fr = dir(['*', rdir(r).name(end - 3:end),'_SAMPLE*']);
                            cd(fold_fr.name)
                            load('resultados','nframes','t_rec');
%                             video_sr = nframes/t_rec;
                            cd ..
                            cd ..
                            cd([basal_dir edir(e).name '/' adir(a).name '/' rdir(r).name '/']);
                            groom_file = dir('Grooming*_S*');
                            load(groom_file.name,'grooming');
                        elseif strcmp(lans(m).name(end - 4),'T')
                            fold_fr = dir(['*', rdir(r).name(end - 3:end),'_TEST*']);
                            cd(fold_fr.name)
                            load('resultados','nframes','t_rec');
%                             video_sr = nframes/t_rec;
                            cd ..
                            cd ..
                            cd([basal_dir edir(e).name '/' adir(a).name '/' rdir(r).name '/']);
                            groom_file = dir('Grooming*_T*');
                            load(groom_file.name,'grooming');
                        end
                    end
                    video_sr = nframes/t_rec;
                    spikes_or = spikes;
                    txy_or = txy;
                    % 					spikes = spikes(spikes<600000); % spikes only during first ten minutes of recording
                    % remove spikes and occupance under a previously defined instant velocity threshold
                    [spikes,txy] = rmspkvel(spikes, txy, pix_per_cm, video_sr, ivel_threshold);
                    %remove spikes during grooming intervals
                    [spikes,txy] = rmspkgroom(spikes, txy, grooming, video_sr, nframes, interv_det);

                    % remove spikes during ripples
                    if exist('RT','var')
                        spikes = rmspkripp(spikes, RT);
                    end
                    [spikes_xy, socmap, sfmap, hist_xy]  =  mkfrmap2(spikes, txy, vertices.maze_centroid, video_sr, pix_per_cm,3);
                    [~, ocmap, fmap, frmap, sfrmap] =  mkfrmap(spikes, txy, vertices.maze_centroid, video_sr, pix_per_cm,3);
                    % spikes per quadrants
                    if m == 1 % Sample
                        [spk_q1,spk_q2,spk_q3,spk_q4,theta_obj,theta_q,t_quad] = spk_quad_S(spikes,vertices,txy,video_sr);
                    elseif m == 2 % Test
                        [spk_q1,spk_q2,spk_q3,spk_q4,theta_obj,t_quad] = spk_quad_T(spikes,vertices,txy,theta_q,video_sr);
                    end

                    ips = getips(ocmap, frmap);
                    spars = getspars(ocmap, frmap);
                    smips = getsmips(ocmap, sfrmap);
                    smspars = getsmspars(socmap, sfrmap);
                    spk_high_speed = spikes;
                    spikes = spikes_or;
                    txy_high_speed = txy;
                    txy = txy_or;
                    Mean_Frate = size(spikes,1)/(size(txy,1)/video_sr); 
                    peakFR = getpeakFR(sfrmap);
                    [spat_cohe, spat_coheR,n_pfields] = spatial_cohe(sfrmap,socmap,3,1);
                    
                    save(tagspks(s).name,'spikes','spikes_xy','txy','ocmap','socmap','fmap','frmap','sfrmap','ips', ...
                        'smips','smspars','hist_xy','spars','video_sr','Mean_Frate','spk_high_speed','txy_high_speed', ...
                        'peakFR','spat_cohe','spat_coheR','n_pfields','spk_q1','spk_q2','spk_q3','spk_q4','theta_obj','theta_q','t_quad')%,spikes_xyQ...etc)
                    clear('spikes','spikes_xy','ocmap','socmap','fmap','frmap','sfrmap','ips','smips','smspars', ...
                        'hist_xy','spars','Mean_Frate','spk_high_speed','txy_high_speed','peakFR','spat_cohe', ...
                        'spat_coheR','n_pfields','spk_q1','spk_q2','spk_q3','spk_q4','theta_obj','t_quad')
                end
                clear txy pix_per_cm tagspks video_sr
            end
        end
        clear theta_q
    end
end
clc
disp('ready.')
