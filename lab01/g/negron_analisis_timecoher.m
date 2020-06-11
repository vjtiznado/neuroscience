% Genera coherencia espectral en el tiempo
params.Fs = LAN.srate; % sampling frequency
params.fpass =  [0 100]; % frequency range of interest
params.tapers = [7 13]; % emphasize smoothing
params.trialave = 0; % average over trials
params.err = [1 0.05]; % population error bars
win = LAN.srate*2; % 2 seg de ventana para calcular coherencia
win_slide = 0.1*win;
LAN.data{1}(:,~LAN.selected{1}) = nan;
n = 1;
canal1 = 18; % elegir canales para calculo coherencia
canal2 = 22;
for k = 1:win_slide:size(LAN.data{1},2) - win,
    data1 = LAN.data{1}(canal1,k:k + win - 1);
    data2 = LAN.data{1}(canal2,k:k + win - 1);
    [C(:,n),phi(:,n),~,~,~,frecuencia] = coherencyc(data1,data2,params);
    n = n + 1;
end
tiempo = (1:win_slide:size(LAN.data{1},2) - win)/LAN.srate;
figure; pcolor(tiempo,frecuencia,double(C)); colorbar
shading interp