
%% 
filename = 'Josefa_1.bdf';

%% DEFINE A
cfg = [];
cfg.dataset = filename
cfg.trialdef.eventtype  = 'STATUS';
cfg.trialdef.eventvalue = {1 2};  
cfg.trialdef.prestim    = 0;
cfg.trialdef.poststim   = 0.5;

cfg = ft_definetrial(cfg);
data_a = ft_preprocessing(cfg);


face_one = data_a.sampleinfo(:,1);

clearvars -except face_one data_a filename
%%
cfg = [];
cfg.dataset = filename
cfg.trialdef.eventtype  = 'STATUS';
cfg.trialdef.eventvalue = {3};  
cfg.trialdef.prestim    = 0;
cfg.trialdef.poststim   = 0.25;

cfg = ft_definetrial(cfg);
data_b = ft_preprocessing(cfg);


face_two_ini = data_b.sampleinfo(:,1);
face_two_end = data_b.sampleinfo(:,2);
save('C:\Datos\Josefa_04.mat','data_a','face_one','face_two_ini','face_two_end');

%% Visualiza los datos diferentes canales

cfg = [];
cfg.channel = {'A1', 'A2', 'A3'};
cfg.viewmode = 'vertical';
cfg.preproc.demean = 'yes';

ft_databrowser(cfg,data_a);

%% 

