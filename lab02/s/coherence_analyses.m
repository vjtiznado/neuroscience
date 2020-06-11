%% Genera coherencia espectral en el tiempo
clear;clc
load('subject01_1.mat');


params.Fs = data.fsample; % sampling frequency
params.fpass =  [0 100]; % frequency range of interest
params.tapers = [7 13]; % emphasize smoothing
params.trialave = 0; % average over trials
params.err = [1 0.05]; % population error bars
win = data.fsample*2; % 2 seg de ventana para calcular coherencia
stepsize = 0.1*win;
% LAN2.data{1}(:,~LAN2.selected{1}) = nan;
n = 1;
canal1 = 2; % elegir canales para calculo coherencia
canal2 = 6;
for k = 1:stepsize:size(LAN2.data{1},2) - win
    data1 = LAN2.data{1}(canal1,k:k + win - 1);
    data2 = LAN2.data{1}(canal2,k:k + win - 1);
    [C(:,n),phi(:,n),~,~,~,frecuencia] = coherencyc(data1,data2,params);
    n = n + 1;
end
tiempo = (1:stepsize:size(LAN2.data{1},2) - win)/LAN2.srate;
figure; 
pcolor(tiempo,frecuencia,double(C)); 
colorbar
shading interp
colormap bone % parula hot jet 
ylabel('Frequency (Hz)')
xlabel('Time (s)')
caxis([0 1])
cb = colorbar;
cb.Label.String = 'Coherence';
set(gca,'fontsize',24,'linewidth',2,'tickdir','out','box','off')
set(gcf,'color','w')


