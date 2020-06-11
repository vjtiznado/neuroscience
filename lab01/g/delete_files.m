%%
clear;clc;

recdir = '/media/labpf/3er_piso_Lab_PF/GVU/Gonzalo/Exp GV11 - GV12 Mayo 2018/GV12/rec_04_OPR3/rec_QM/';
cd(recdir)
% get the dir of all the files you want to delete, by using a regular expresion that ONLY them match
badspk = [dir('spk*S*mat');...
	  dir('spk*T.mat');...
	  dir('spk*circ*mat')];

arrayfun(@(x) delete(x.name),badspk);
disp('ready')
