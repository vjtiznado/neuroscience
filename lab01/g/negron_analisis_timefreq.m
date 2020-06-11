%% luego de procesamiento en LAN, guardar el LAN

save('spIN85_d1t4','LAN')

%% indicar canal de analisis
canal = 1;
% cambiar extencion de .ldt a .mat y luego cargar archivo
tiempo = LAN.time(1):LAN.time(3)/LAN.srate:LAN.time(2)- LAN.time(3)/LAN.srate;

% graficar el registro
if min(LAN.selected{1}) == 0,
    raw_data = LAN.data{1}(canal,:);
    raw_data(~LAN.selected{1}) = nan;
    figure; plot(tiempo,raw_data); xlim([tiempo(1) tiempo(end)])
    hold on
    raw_data = LAN.data{1}(canal,:);
    raw_data(LAN.selected{1}) = nan;
    plot(tiempo,raw_data,'r'); xlim([tiempo(1) tiempo(end)])
end
frecuencia = LAN.freq.freq;
tiempo_f = LAN.freq.time;
TF = squeeze(double(t_powspctrm{1}));
figure; pcolor(tiempo_f,frecuencia,TF); 
shading interp

%% calculo Z-score en rango de frecuencia de interes

banda_frec_analisis = [60 80];
z_score_banda = frecuencia >= banda_frec_analisis(1) & frecuencia <= banda_frec_analisis(2);
z_score_banda = mean_nonan(TF(z_score_banda,:),1);
z_score = z_score_banda;
z_score(~LAN.selected{1}) = nan;
figure; plot(tiempo_f,z_score)
hold on
z_score = z_score_banda;
z_score(LAN.selected{1}) = nan;
plot(tiempo_f,z_score,'r')
resultado = [tiempo_f' z_score_banda' [LAN.selected{1} 1]'];
%dlmwrite('IN67_d1t1_HPC (gamma).xls',resultado,'delimiter','\t');