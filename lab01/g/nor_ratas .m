clear % limpia las variables
matfiles = dir('*trajectories.mat');
load(matfiles.name);
avifiles = dir('*prueba.avi');
mov = VideoReader(avifiles.name);
frame = read(mov,1);
ok = 1;
while ~isempty(ok)
    imshow(frame)
    hold on
    n_obj = 2;
    title(['N objetos = ' num2str(n_obj)])
    objetos = ginput(n_obj);
    for k = 1:length(objetos)
        plot(objetos(k,1),objetos(k,2),'ro','linewidth',10)
    end
    ok = input('terminar? = ');
    clf
end
close all
save(matfiles.name, 'probtrajectories','trajectories','objetos');

%%
clear % limpia las variables
matfiles = dir('trajectories*.mat');
load(matfiles.name);
trajectories2 = squeeze(trajectories);
% indica el frame de inicio y final de interes
frame_ini = 10;
frame_fin = 14235;
trajectories2 = trajectories2(frame_ini:frame_fin,:);
% PRIMERA INTERPOLACION
lim_interp = 5;
% busca saltos para luego reemplazarlos por NaN
saltos = find(abs(diff(trajectories2(:,1))) > lim_interp);
trajectories2(saltos,1) = NaN;
saltos = find(abs(diff(trajectories2(:,2))) > lim_interp);
trajectories2(saltos,2) = NaN;
trajectories2(:,1) = naninterp(trajectories2(:,1));
trajectories2(:,2) = naninterp(trajectories2(:,2));

% SEGUNDA INTERPOLACION
% busca saltos para luego reemplazarlos por NaN
% saltos = find(abs(diff(trajectories2(:,1))) > lim_interp);
% trajectories2(saltos,1) = NaN;
% saltos = find(abs(diff(trajectories2(:,2))) > lim_interp);
% trajectories2(saltos,2) = NaN;
% trajectories2(:,1) = naninterp(trajectories2(:,1));
% trajectories2(:,2) = naninterp(trajectories2(:,2));
save(matfiles.name, 'probtrajectories','trajectories2','trajectories',...
    'lim_interp','frame_ini','frame_fin');

%%
clear
avifiles = dir('*.avi');
mov = VideoReader(avifiles.name);
frame_rate = mov.NumberOfFrames/mov.Duration;
matfiles = dir('*.mat');
load(matfiles.name);
trajectories2 = squeeze(trajectories);
load(matfiles.name);
% valores x e y en torno al objeto
% win_obj(4,:) = [15 15]; % obj 1
% win_obj(3,:) = [15 15]; % obj 2
win_obj(2,:) = [19 19]; % obj 2
win_obj(1,:) = [10 20]; % obj 1
figure
plot(trajectories2(:,1),trajectories2(:,2))
hold on
for k = 1:size(objetos,1)
    plot(objetos(k,1),objetos(k,2),'ok','markersize',30)
%     axis([100 230 0 150])
%     hold on
%     pause
end

for k = 1:size(objetos,1)
    bool_x = trajectories2(:,1) < objetos(k,1) + win_obj(k,1) & trajectories2(:,1) > objetos(k,1) - win_obj(k,1);
    bool_y = trajectories2(:,2) < objetos(k,2) + win_obj(k,2) & trajectories2(:,2) > objetos(k,2) - win_obj(k,2);
    bool_xy = bool_x & bool_y;
    plot(trajectories2(bool_xy,1),trajectories2(bool_xy,2),'*r')
    time_exp(k) = sum(bool_xy)/frame_rate;
        % calculo de intervalos de exploracion
    bool_xy(1) = false;
    bool_xy(end) = false;
    diff_bool_xy = diff(bool_xy);
    entradas = find(diff_bool_xy == 1);
    salidas = find(diff_bool_xy == -1);
    interv = (salidas - entradas);
end

save(matfiles.name, 'probtrajectories','trajectories2','trajectories','objetos','win_obj','lim_interp','frame_ini','frame_fin');
%%
%
clear
matfiles = dir('*Macho1.mat');
load(matfiles.name);
avifiles = dir('*Macho 1 sin sueño 08092017.avi');
mov = VideoReader(avifiles.name);

for k = frame_ini:mov.NumberOfFrames
    imshow(read(mov,k))
    hold on
    plot(trajectories2(k-(frame_ini - 1),1),trajectories2(k-(frame_ini - 1),2),'ro','markersize',10)
%     pause(1/(2*mov.FrameRate))
    pause(0.001)
    hold off
end