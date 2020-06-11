%% renaming files

main_path = '/Users/vjtiznado/Google Drive/lab_bmi/schizophrenia/data';
cd(main_path)
subjs = dir([main_path filesep 'splinter*']); subjs = {subjs.name}';
s = 4;
cd([main_path filesep subjs{s}])
filenames = dir('splinter_4*'); filenames = {filenames.name}';
arrayfun(@(x) movefile(filenames{x},['splinter_04' filenames{x}(end-6:end)]),1:length(filenames))
	

	



