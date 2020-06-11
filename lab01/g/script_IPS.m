function script_IPS(file,hnnWnd,n_place_bins)

% X position on x
% Y position on Y
% t time for XY
% spikes: times for spikes
% video_srate (sampling video rate?)


%hnnWnd=7; % hanning window for the ratemap figure
%load('spikes_data_1.mat')
load(file)
% n_place_bins =32; %8,16, 32,64, 128, 256 selects the number of bins that you would the environment split into...in this case 64x64

Xpos = interp1(t,X,spikes); %find the X-pos where each cell fired
Ypos = interp1(t,Y,spikes); %find the Y-pos where each cell fired
subplot(1,2,1)
plot(X,Y,'color',[.6 .6 .6]); %plots the rats path for the epoch...
hold on;
plot(Xpos, Ypos, 'r*');
axis xy;
axis('square')
title('spikes during movement');

values_pos = hist3([X Y],[n_place_bins n_place_bins]); % 'animal acupancie'
bb=flipud(rot90(values_pos));
values_spikes = hist3([Xpos Ypos],[n_place_bins n_place_bins]); %'spikes per position
cc=flipud(rot90(values_spikes));

%%% normalizando por firing rate
vector_pos=(values_pos(:))*(1/video_srate);
vector_spike=values_spikes(:);
vector_rate=vector_spike./vector_pos;
vector_rate(isnan(vector_rate))=0;
vector_rate(~isfinite(vector_rate))=0;
%%% hanning
final_matrix=reshape(vector_rate,[n_place_bins,n_place_bins]);
final_matrix_hann=conv2(final_matrix,(hanning(hnnWnd)./sum(hanning(hnnWnd)))*(hanning(hnnWnd)'./sum(hanning(hnnWnd))),'same');

sum_values_pos=sum(sum(values_pos));
P_values_pos=values_pos./sum_values_pos;%transformando ocupancia en probabilidad

%para calcular el Rmean debo descontar los bines con valor 0, sino la
%media no es correcta:
idx = find(values_pos(:)>0);
total_matrix=(sum(sum(final_matrix)))/length(idx); % tasa de descarga promedio por bin. suma las tasas de descarga de todos los bines, y la divide por el numero de bines en que el animal tuvo una ocupancia mayor que cero
Ri_Rmean=final_matrix./total_matrix; %variable Ri/R, ojo que queda una matriz
lin_RiR = Ri_Rmean(:); %Ri/R linealizado
logR=log2(lin_RiR);%segundo componente de la ecc
logR(~isfinite(logR))=0;
logR(isnan(logR))=0;
lin_P_values= P_values_pos(:);
lin_PiR=lin_P_values.*lin_RiR;% primer componente de la ecc
lin_PiR(~isfinite(lin_PiR))=0;
lin_PiR(isnan(lin_PiR))=0;
fIPS2=lin_PiR.*logR;
IPS_final= sum(fIPS2);


%%%ploting the rate map
subplot(1,2,2)
dd=flipud(rot90(final_matrix_hann));
imagesc(dd);
axis xy;
axis('square')
title(strcat('IPS: ',num2str(sprintf('%.3f',IPS_final))));
colorbar('EastOutside');