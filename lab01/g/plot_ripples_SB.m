%% ESTE PLOTEA CON RIPPLES DETECTADOS POR METODO LOGOTHETIS
% SELECCION DE LA RATA Y SESION A PLOTEAR
clc
clear
base_dir = 'C:\Users\neuro\Dropbox\VT\LFP_data';
cd(base_dir)
exp_dir = dir(fullfile(base_dir,'SB*'));
display('loading ripples data...')
load('ripples_data_raw_SD_5.mat')
% load('ripples_data_raw_SD_3.mat')

% SELECCIONA LA RATA. n_rat = 1, SB32; 2, SB33; 3, SB34; 4, SB41.
n_rat = 6;
cd(exp_dir(n_rat).name)
sessions = dir('session*');

% SELECCIONA LA SESION
n_ses = 2;
cd(sessions(n_ses).name)

RT = rat_ripples(n_rat).ripples_data{n_ses,1};
display('loading LFP of the selected session...')
load('LFP.mat')
% data = data(:,1:end-2390000);
if isempty(dir('LFPf_100_250Hz.mat'))
    display('filtering LFP between 100-250 Hz...')
    ripples = nan(size(data));
    for ch = 1:size(data,1)
        display(['channel ' num2str(ch) '/' num2str(size(data,1)) '...'])
        ripple = eegfilt(data(ch,:),srate,100,250);
        ripples(ch,:) = ripple;
    end
    display('saving filtered LFP...')
    save('LFPf_100_250Hz.mat','ripples','srate','channels','tetrodes','-v7.3')
else
    display('loading LFP filtered between 100-250 Hz...')
    load('LFPf_100_250Hz.mat')
end
display('data ready for plotting.')
beep
pause(.5)
beep

%%
% SELECCIONA EL CANAL (n_ch)
% figure(2)
clc;
n_ch = 7; % elijo el canal a plotear
curr_ch = n_ch;
% n_ch = 4*(n_ch - 1) + 1; % como estan los cuatro canales de cada tetrodo, con esta linea se salta al tetrodo siguiente cuando n_ch = n_ch + 1;
ch = RT.est == n_ch; % crea un vector logico con los ripples detectados que pertenecen a este canal
ch = find(ch == 1); % me da los valores dentro de la matriz de estos ripples encontrados
% display([num2str(size(ch,2)) ' ripples in this channel'])
% clear data; data = LAN.data{1,1};
time = ((1:size(data(n_ch,:),2)))/srate; % vector de tiempo para el ploteo

% ELIGE EL RIPPLE QUE QUIERES PLOTEAR (n_ripp)
n_ripp = 28;% aqui seleccionas el ripple de esta sesion que quieres plotear
clf
% figure(2)
win = .5*srate; % ventana de tiempo al rededor del ripple que se va a plotear
% plot(time,detrend(data(n_ch,:)),'k')



plot(time(1,((RT.latency(ch(n_ripp))*srate/1000)-win):((RT.latency(ch(n_ripp))*srate/1000)+win)),detrend(data(n_ch,((RT.latency(ch(n_ripp))*srate/1000)-win):((RT.latency(ch(n_ripp))*srate/1000)+win))),'k')
hold on
if max(detrend(data(n_ch,((RT.latency(ch(n_ripp))*srate/1000)-win):((RT.latency(ch(n_ripp))*srate/1000)+win)))*5) > 4500
% plot(RT.latency(ch)/1000,ones(1,sum(ch))*5000,'*','markersize',13,'color',[0 0 .6])
plot(time(1,((RT.latency(ch(n_ripp))*srate/1000)-win):((RT.latency(ch(n_ripp))*srate/1000)+win)),ripples(n_ch,((RT.latency(ch(n_ripp))*srate/1000)-win):((RT.latency(ch(n_ripp))*srate/1000)+win))*2+5000,'color',[0 .4 0])
plot(RT.latency(ch(n_ripp))/1000,ones(1,1)*6000,'*','markersize',13,'color',[.6 0 0],'linewidth',2)
ylim([min(detrend(data(n_ch,((RT.latency(ch(n_ripp))*srate/1000)-win):((RT.latency(ch(n_ripp))*srate/1000)+win)))) max(ripples(n_ch,((RT.latency(ch(n_ripp))*srate/1000)-win):((RT.latency(ch(n_ripp))*srate/1000)+win))*2+5000)+1000])
else
plot(time(1,((RT.latency(ch(n_ripp))*srate/1000)-win):((RT.latency(ch(n_ripp))*srate/1000)+win)),ripples(n_ch,((RT.latency(ch(n_ripp))*srate/1000)-win):((RT.latency(ch(n_ripp))*srate/1000)+win))*2+3000,'color',[0 .4 0])
plot(RT.latency(ch(n_ripp))/1000,ones(1,1)*4000,'*','markersize',13,'color',[.6 0 0],'linewidth',2)
ylim([min(detrend(data(n_ch,((RT.latency(ch(n_ripp))*srate/1000)-win):((RT.latency(ch(n_ripp))*srate/1000)+win)))) max(ripples(n_ch,((RT.latency(ch(n_ripp))*srate/1000)-win):((RT.latency(ch(n_ripp))*srate/1000)+win))*2+3000)+1000])
end
hold off
% plot(time,ripples*2+4000,'color',[.6 0 0])
% hold on; plot(time(1,((RT.latency(n_ripp)*srate/1000)-win):((RT.latency(n_ripp)*srate/1000)+win)),ripples*2 + 600,'color',[0 0 .6])
% hold on;plot(RT.latency(ch1),ones(1,sum(ch1))*1000,'*','markersize',8,'color',[.6 0 0])
xlim([time(1,((RT.latency(ch(n_ripp))*srate/1000)-win)) time(1,((RT.latency(ch(n_ripp))*srate/1000)+win))])
xlabel('Time (s)','fontsize',18)
title(['Rat ' rat_ripples(n_rat).name ', '   ' ' sessions(n_ses).name(8:9) '/' sessions(n_ses).name(11:12) ', tetrode ' num2str(tetrodes(1,ceil(n_ch/4))) ', channel ' num2str(channels(n_ch,1))]...
      ,'fontsize',16,'fontweight','demi','color',[.6 0 0])
hleg = legend('\color[rgb]{0 0 0}raw LFP','\color[rgb]{0 .4 0}filtered 100-250 Hz',['\color[rgb]{.6 0 0}event ' num2str(n_ripp) '/' num2str(size(ch,2))]);
set(hleg,'fontsize',10,'fontweight','demi','location','southeast')
set(gca,'fontsize',16)
set(gcf,'color','w','paperunits','points','PaperPosition', [0 40 1040 540])


%% GUARDA LA FIGURA
if n_ch == curr_ch && isempty(dir('figuras_ripples'))
    mkdir('figuras_ripples')
end
cd('figuras_ripples')
clear list_pic;
list_tt = dir('*TT*');

example = 1;

if example == 1 % si es el primer ejemplo que se crea para este canal, se creara una carpeta con el nombre del tetrodo al que pertenece
    mkdir(['TT' num2str(num2str(tetrodes(1,ceil(n_ch/4))))])
end
cd(['TT' num2str(num2str(tetrodes(1,ceil(n_ch/4))))])
% clear list_pic;
% list_pic = dir('*.tif');
% 
% if length(list_pic) == 0;
%     example = 1;
% else
%     example = length(list_pic) + 1;
% end


iname = ['ripples_' exp_dir(n_rat).name '_' sessions(n_ses).name(11:end)  '_tt' num2str(tetrodes(1,ceil(n_ch/4)))...
    '_ex' num2str(example)]; % SI GUARDAS MAS DE UN EJEMPLO POR SESION, CAMBIAR ESTE NUMERO
print(gcf,'-dtiff',iname,'-r0')
display(['figure ' num2str(example) ' (ripple ' num2str(n_ripp) ') saved'])
cd ..
cd ..