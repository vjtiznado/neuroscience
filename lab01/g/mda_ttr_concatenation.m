%% Concatenation of the different '.mda' files of each tetrode before clustering. 
% This concatenation occurrs only in the folders having more than one '.mda' file per tetrode
% After concatenating the .mda files, you should run the authomatic spike sorting for this files.
clear; clc;
tic

basal_path = 'E:\Gonzalo\mda files\'; % set the path where the folders of your different rats are located
n_tetrodes = 8; % set the number of tetrodes you have
if ~strcmp(basal_path(end),'/') && ~strcmp(basal_path(end),'\'), basal_path = [basal_path '/']; end

edir = dir([basal_path 'GV*']); % get the folder's name of all your rats
for e = 1:size(edir,1) % animal loop
    rdir = dir([basal_path edir(e).name '\rec*']); % get the folder's name of all the recording days of this rat
    for r = 1:size(rdir,1) % session loop
        disp(rdir(r).name)
        apdir = dir([basal_path edir(e).name '\' rdir(r).name '\rec_*M']);
        for ap = 1:size(apdir,1) % am/pm loop
            disp(apdir(ap).name)
            cd([basal_path edir(e).name '\' rdir(r).name '\' apdir(ap).name])
            ttrs_dir_test = dir('*tt1_raw.mda'); % detect all the '.mda' files of one tetrode. If there is more than one .mda file for a tetrode, it means that the code has to concatenate them
            ttrmerg_dir = dir('*merged*.mda'); % if the '_merged.mda' files already exist, the code will skip this folder
            if size(ttrs_dir_test,1) > 1 && size(ttrmerg_dir,1) == 0 % "if there is more than one .mda file per tetrode, and no merged.mda files..."
                % concatenation of the '.mda' file of each tetrode
                rec_beg = nan(size(ttrs_dir_test,1),1); % we go to save the timestamp of the beggining of each recording in the concatenated matrix
                rec_beg(1,1) = 1;
                mda_conc_order = {ttrs_dir_test.name}';
                mda_conc_order = arrayfun(@(f) mda_conc_order{f,1}(1:end-12),1:size(ttrs_dir_test,1),'uniformoutput',false)';
                for n_tt = 1:n_tetrodes % loop for each tetrode
                    disp(['concatenating TT' num2str(n_tt) ' .mda files...'])
                    ttrs_dir = dir(['*tt*' num2str(n_tt) '*.mda']); % detect all the .ttr files of the tetrode 'n_tt'
                    cd([basal_path edir(e).name '\' rdir(r).name '\' apdir(ap).name])
                    data = arrayfun(@(x) readmda(x.name), ttrs_dir,'uniformoutput',false); % import the data of all the .mda files of this tetrode (n_tt)
                    
                    % the spacer is what will be added between your different recordings during concantenation.
                    spacer = [1,0,1,0,1,0,1];
                    spacer = repmat(spacer,size(data{1,1},1),1); % make a 4-rowed spacer matrix
                    
                    reclengths = cell2mat(arrayfun(@(j) size(data{j,1},2),1:size(data,1),'uniformoutput',false)); % again?
                    lenghtsums = sum(reclengths); % sum of the length of every recording, for future memory preallocation
                    total_length = lenghtsums + size(spacer,2)*(size(data,1)-1); % total length of the concatenated data, considering every time the spacer is added (n_mda_files - 1). For future memory preallocation
                    datam = nan(size(data{1,1},1),total_length); % memory preallocation
                    
                    datam(:,1:size(data{1,1},2)) = data{1,1}; % add the first recording
                    for ttr = 2:size(data,1) % for the next ones, the spacer should be added before
                        datam(:,sum(~isnan(datam(1,:)))+1:sum(~isnan(datam(1,:)))+size(spacer,2)) = spacer;
                        if n_tt == 1, rec_beg(ttr,1) = sum(~isnan(datam(1,:)))+1; end
                        datam(:,sum(~isnan(datam(1,:)))+1:sum(reclengths(1:ttr))+size(spacer,2)*(ttr-1)) = data{ttr,1};
                    end
                    clear data
                    disp(['saving concatenated TT' num2str(n_tt) ' .ttr file...']);
                    ttrname = strsplit(ttrs_dir(1).name,'_');
                    writemda16i(datam,[strjoin(ttrname(1,2:4),'_') '_tt' num2str(n_tt) '_merged_raw.mda']); % save the .ttr file of this tetrode
                    
                    disp(['TT' num2str(n_tt) ' file ready']);
                    disp(' ')
                    clear datam
                end
                mda_conc_lengths = reclengths';
                save([basal_path edir(e).name '\' rdir(r).name '\' apdir(ap).name '\mda_conc_info.mat'],'mda_conc_order','mda_conc_lengths','spacer','rec_beg','-v7.3')
            elseif size(ttrs_dir_test,1) > 1 && size(ttrmerg_dir,1) > 0
                disp('this recording session has its .mda files already concatenated')
                disp(' ')
            elseif size(ttrs_dir_test,1) == 1
                disp('this recording session does not need to concatenate .mda files because there is only one per tetrode')
                disp(' ')
            elseif size(ttrs_dir_test,1) == 0
                disp('this recording has no .mda files')
                disp(' ')
            end
        end
    end
end
disp(' ***   ready   *** ')
msgbox_icon = imread('bien.jpg');
msgbox('YOUR DATA IS READY','Enhorabuena','custom',msgbox_icon)
toc