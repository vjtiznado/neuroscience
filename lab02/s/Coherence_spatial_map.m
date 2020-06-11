
%Carga coordenadas espaciales xy
clear
sratevid = 30;
xydata = importdata('d1t2.txt');
xydata = xydata.data;
intan_ini = 41; %indicar frame inicio recording INTAN
xydata = xydata(intan_ini:end,:);
inicio_test = 200 - intan_ini; %indicar inicio de test respecto de Intan
xydata = xydata(inicio_test:end,:);
figure; plot(xydata(:,1),xydata(:,2))
t_test = (inicio_test:inicio_test + size(xydata,1) - 1)';
xydata(:,3) = t_test/sratevid;
%%
% carga espigas
spks = loadods('IN77_BM_rec_tet3_un1.ods');
spks = cell2mat(spks(:,2))/1000; % espigas en seg
spks(1) = []; % se quita el NaN inicial
hist_spks = hist(spks,t_test/sratevid);
delta = 5; %tamaño de los puntos
XY = zeros(round(max(xydata(:,1))) + delta,round(max(xydata(:,2))) + delta);
 
 for k = 2:length(hist_spks) - 1,
     xvar = round(xydata(k,1));
     yvar = round(xydata(k,2));
     if ~isnan(xvar + yvar),
         if isnan(XY(xvar,yvar)),
             XY(xvar - delta:xvar + delta,yvar - delta:yvar + delta) = hist_spks(k);
         else
             XY(xvar - delta:xvar + delta,yvar - delta:yvar + delta) = XY(xvar - delta:xvar + delta,yvar - delta:yvar + delta) + hist_spks(k);
         end
    end
 end
 %figure; surface(XY); shading interp
%% lee coherencia a partir de datos xls

cohe = xlsread('Coh_IN67_BM_d1t2.xlsx');
t_cohe = cohe(1,:);
cohe = cohe(2:end,:);
theta = freq >= 6 & freq <= 10; %indicar banda de frecuencia
cohe_theta = sum(cohe(theta,:));
for k = 1:length(t_test),
    if ~isnan(t_test(k)),
        ind_t_cohe = find(t_cohe > t_test(k)/sratevid - 1 & t_cohe < t_test(k)/sratevid);
        cohe_tvid(k) = sum(cohe_theta(ind_t_cohe));
    end
end
delta = 5;
XY = zeros(round(max(xydata(:,1))) + delta,round(max(xydata(:,2))) + delta);

for k = 2:length(cohe_tvid) - 1,
    xvar = round(xydata(k,1));
    yvar = round(xydata(k,2));
    if ~isnan(xvar + yvar),
        if isnan(XY(xvar,yvar)),
            XY(xvar - delta:xvar + delta,yvar - delta:yvar + delta) = cohe_tvid(k);
        else
            XY(xvar - delta:xvar + delta,yvar - delta:yvar + delta) = XY(xvar - delta:xvar + delta,yvar - delta:yvar + delta) + cohe_tvid(k);
        end
    end
end
surface(XY); shading interp

%% cargar poder en cierta freuencia

poder = loadods('IN67_beta_PFC_d1t2.ods');
poder = poder(2:end,:);
t_poder = cell2mat(poder(:,2));
poder = poder(:,3);
for k = 1:length(poder),
    if poder{k} == 'NaN'
        poder{k} = NaN;
    end
end
poder = cell2mat(poder);
plot(t_poder,poder);
% cambio a srate del video
poder_vid = interp1(t_poder,poder,xydata(:,3));
%%
delta = 50;
XY = hist3(xydata(:,1:2),'Edges',{(min(xydata(:,1)) - delta:max(xydata(:,1)) + delta)' (min(xydata(:,2)) - delta:max(xydata(:,2)) + delta)'});
XY = conv2(XY,(hanning(30)./sum(hanning(30)))*(hanning(30)'./sum(hanning(30))),'valid');
figure; surface(XY); shading interp;
%axis([350 450 40 240])
