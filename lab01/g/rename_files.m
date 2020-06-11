%% This code is to rename files in a folder by replacing a word that you do not want anymore in the file name (re) by another one (repl)
% It is useful if you want to preserve the same filenames' structure for all your recordings and there are some of them that were saved using another one
clear
recdir = 'E:\Gonzalo\Exp GV15 - GV16 Septiembre 2018\GV16\rec_06_OPR10\';
cd(recdir)
re = '_OPR10T_'; % the word in the file name that you want to replace
repl = '_OPR10_'; % the replacing word

files = dir(['*' re '*']); % get all the files in the folder containing the word you want to replace 
% Loop through each file containing the word you want to change 
for id = 1:length(files)
	    [~, f,ext] = fileparts(files(id).name); % f is the filename without the extension, ext is the extension
	    fspl = strsplit(f,'_'); % split the filename
        realone = strsplit(re,'_');
        realone = realone{cellfun(@(c) ~isempty(c),realone)};
	    findre = strcmp(fspl,realone); % find where in the filename the word you want to replace is
	    replalone = strsplit(repl,'_');
        replalone = replalone{cellfun(@(c) ~isempty(c),replalone)};
        fspl{findre} = replalone; % replace it in the same place with the replacing word
	    rename = strcat(strjoin(fspl,'_'),ext); % join the new filename
	    movefile(files(id).name, rename); % rename the file 
end
