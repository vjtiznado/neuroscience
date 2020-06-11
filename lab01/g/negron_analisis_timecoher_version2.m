% Genera coherencia espectral en el tiempo
params.Fs = LAN.srate; % sampling frequency
params.fpass =  [0 100]; % frequency range of interest
params.tapers = [7 13]; % emphasize smoothing
params.trialave = 0; % average over trials
params.err = [1 0.05]; % population error bars
win = LAN.srate*2; % 2 seg de ventana para calcular coherencia
stepsize = 0.1*win;
LAN.data{1}(:,~LAN.selected{1}) = nan;
n = 1;
canal1 = 2; % elegir canales para calculo coherencia
canal2 = 6;
for k = 1:stepsize:size(LAN.data{1},2) - win,
    data1 = LAN.data{1}(canal1,k:k + win - 1);
    data2 = LAN.data{1}(canal2,k:k + win - 1);
    [C(:,n),phi(:,n),~,~,~,frecuencia] = coherencyc(data1,data2,params);
    n = n + 1;
end
tiempo = (1:stepsize:size(LAN.data{1},2) - win)/LAN.srate;
figure; pcolor(tiempo,frecuencia,double(C)); colorbar
shading interp

%% prueba esta forma de calcular coherencia (sin chronux)

LAN.data{1}(:,~LAN.selected{1}) = nan;
canal1 = 2; % elegir canales para calculo coherencia
canal2 = 6;
dt = 1/LAN.srate;
windowslength = 5*LAN.srate; % 2 seg de ventana para calcular coherencia
stepsize = 0.1*windowslength;
Nwindows = ((size(LAN.data{1},2) - windowslength)/stepsize) + 1;
clear C T
for nwin = 1:Nwindows
    win = (1:windowslength) + (nwin - 1)*stepsize;
    data1 = LAN.data{1}(canal1,win);
    data2 = LAN.data{1}(canal2,win);
    [C_sq,frecuencia] = mscohere(data1,data2,0.5*LAN.srate,...
        [],500,LAN.srate);
    C(nwin,:) = sqrt(C_sq);
    T(nwin) = median(win)*dt;
end
figure
imagesc(T,frecuencia,C')
axis xy