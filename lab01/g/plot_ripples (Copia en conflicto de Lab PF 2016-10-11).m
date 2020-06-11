%% ESTE PLOTEA TRIALS GOs EN BUSQUEDA DE RIPPLES

srate = 2000;
time = (1:size(SB41_trials.sessions{1,1}(1,:),2))/srate;
% time = (1:size(rat_trials(1).sessions{1,1}(1,:),2))/srate;
time = time - 3;

% nrat = 4;
nses = 9;
f_dir = ['C:\Users\neuro\Dropbox\VT\LFP_data\SB41\' SB41_trials.sessions{nses,2}(1:9) '_' SB41_trials.name '_' SB41_trials.sessions{nses,2}(16:20)];
cd(f_dir)

GOs = find(SB41_trials.b_sessions{nses,1}(:,1)==11);
nGO = 20;

plot(time,SB41_trials.sessions{nses,1}(GOs(nGO,1),:),'k')
hold on
ripples = eegfilt(SB41_trials.sessions{nses,1}(GOs(nGO,1),:),srate,100,250);
plot(time,ripples*2.5+1700,'color',[0 0 .6])
hold off
xlim([-3 3])
title(['Rat ' SB41_trials.name ', ' SB41_trials.sessions{nses,2}(1:9) ' ' SB41_trials.sessions{nses,2}(16:17) '/' SB41_trials.sessions{nses,2}(19:20) ', ' SB41_trials.sessions{nses,4} ', trial ' num2str(GOs(nGO))],'fontsize',16,'fontweight','demi','color',[.6 0 0])
% set(gcf,'color','w','Position', [0 40 1040 540],'paperunits','points','PaperPosition', [0 40 1040 540])
set(gcf,'color','w','paperunits','points','PaperPosition', [0 40 1040 540])
hleg = legend('\color[rgb]{0 0 0}raw LFP','\color[rgb]{0 0 .5}filtered 100-250 Hz');
set(hleg,'fontsize',10,'fontweight','demi','location','northeast')
xlabel('Time (s)')

%% GUARDA LA FIGURA

iname = ['ripples_' SB41_trials.name '_' SB41_trials.sessions{nses,2}(1:9) '_' SB41_trials.sessions{nses,2}(16:17) '_' SB41_trials.sessions{nses,2}(19:20) '_tt' SB41_trials.sessions{nses,4}(end)...
    '_ex7'];
print(gcf,'-dtiff',iname,'-r0')

%% ESTE PLOTEA CON RIPPLES DETECTADOS POR METODO LOGOTHETIS
% SELECCION DE LA RATA Y SESION A PLOTEAR
clc
clear
base_dir = 'C:\Users\neuro\Dropbox\VT\LFP_data';
cd(base_dir)
exp_dir = dir(fullfile(base_dir,'SB*'));
display('loading ripples data...')
load('ripples_data_raw_SD_5.mat')
% load('ripples_data_raw_SD_5__2.mat')
% load('ripples_data_raw_SD_3.mat')

% SELECCIONA LA RATA. n_rat = 1, SB32; 2, SB33; 3, SB34; 4, SB35; 5, SB37; 6, SB41; 7, SB42.
n_rat = 3;
cd(exp_dir(n_rat).name)

sessions = dir('session*');

% SELECCIONA LA SESION
n_ses = 1;
cd(sessions(n_ses).name)

RT = rat_ripples(n_rat).ripples_data{n_ses,1};
display('loading LFP of the selected session...')
load('LFP.mat')
if n_rat == 2 && n_ses == 1
    data = data(:,300000:2850000);
elseif n_rat == 2 && n_ses == 2
    data = data(:,1:2100000);
elseif n_rat == 2 && n_ses == 3
    data = data(:,1:2390000);
elseif n_rat == 2 && n_ses == 4
    data = data(:,1000000:2190000);
elseif n_rat == 2 && n_ses == 6
    data = data(:,1:1850000);    
elseif n_rat == 4 && n_ses == 1;
    data = data(:,1:end-50000);
elseif n_rat == 4 && n_ses == 3;
    data = data(:,1:end/2-100000);
elseif n_rat == 4 && n_ses == 4
    data = data(:,1430000:end);
elseif n_rat == 4 && n_ses == 5
    data = data(:,1:end/2+300000);
elseif n_rat == 4 && n_ses == 6
    data = data(:,1:end-900000);
elseif n_rat == 4 && n_ses == 7
    data = data(:,end/2+90000:end-30000);
elseif n_rat == 4 && n_ses == 8
    data = data(:,1:end-400000);
elseif n_rat == 4 && n_ses == 9
    data = data(:,1000000:2010000);    
elseif n_rat == 6 && n_ses == 8;
    data = data(:,250000:1400000);
elseif n_rat == 6 && n_ses == 3;
    data = data(:,end/2-10000:end-100000);
end

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
% theta = eegfilt(data,srate,6,10);
display('data ready for plotting.')
beep
pause(.5)
beep

%%
% SELECCIONA EL CANAL (n_ch)
% figure(2)
n_ch = 5; % elijo el canal a plotear
% n_ch = 4*(n_ch - 1)  + 1; % como estan los cuatro canales de cada tetrodo, con esta linea se salta al tetrodo siguiente cuando n_ch = n_ch + 1;
ch = RT.est(1,:) == n_ch; % crea un vector logico con los ripples detectados que pertenecen a este canal
ch = find(ch == 1); % me da los valores dentro de la matriz de estos ripples encontrados
% display([num2str(size(ch,2)) ' ripples in this channel'])
time = ((1:size(data(n_ch,:),2)))/srate; % vector de tiempo para el ploteo

% ELIGE EL RIPPLE QUE QUIERES PLOTEAR (n_ripp)
n_ripp = 1; % aqui seleccionas el ripple de esta sesion que quieres plotear
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
title(['Rat ' rat_ripples(n_rat).name ', ' sessions(n_ses).name(1:9) ' ' sessions(n_ses).name(16:17) '/' sessions(n_ses).name(19:20) ', tetrode ' num2str(tetrodes(1,ceil(n_ch/4))) ', channel ' num2str(channels(n_ch,1))]...
      ,'fontsize',16,'fontweight','demi','color',[.6 0 0])
hleg = legend('\color[rgb]{0 0 0}raw LFP','\color[rgb]{0 .4 0}filtered 100-250 Hz',['\color[rgb]{.6 0 0}event ' num2str(n_ripp) '/' num2str(size(ch,2))]);
set(hleg,'fontsize',15,'fontweight','demi','location','northeast')
set(gca,'fontsize',16)
set(gcf,'color','w','paperunits','points','PaperPosition', [0 40 1040 540])


%% PLOT CON SUBPLOTS
% SELECCIONA EL CANAL (n_ch)
n_ch = 4; % elijo el canal a plotear
% n_ch = 4*(n_ch - 1) + 1; % como estan los cuatro canales de cada tetrodo, con esta linea se salta al tetrodo siguiente cuando n_ch = n_ch + 1;
ch = RT.est == n_ch; % crea un vector logico con los ripples detectados que pertenecen a este canal
ch = find(ch == 1); % me da los valores dentro de la matriz de estos ripples encontrados
% display([num2str(size(ch,2)) ' ripples in this channel'])
time = ((1:size(data(n_ch,:),2)))/srate; % vector de tiempo para el ploteo

% ELIGE EL RIPPLE QUE QUIERES PLOTEAR (n_ripp)
n_ripp =  1;% aqui seleccionas el ripple de esta sesion que quieres plotear
% figure(2)
win = .5*srate; % ventana de tiempo al rededor del ripple que se va a plotear
% plot(time,detrend(data(n_ch,:)),'k')
subplot(2,1,1)
plot(time(1,((RT.latency(ch(n_ripp))*srate/1000)-win):((RT.latency(ch(n_ripp))*srate/1000)+win)),detrend(data(n_ch,((RT.latency(ch(n_ripp))*srate/1000)-win):((RT.latency(ch(n_ripp))*srate/1000)+win))),'k')
hold on
if strcmp(rat_ripples(n_rat).name,'SB34') || strcmp(rat_ripples(n_rat).name,'SB41')
% plot(RT.latency(ch)/1000,ones(1,sum(ch))*5000,'*','markersize',13,'color',[0 0 .6])
plot(time(1,((RT.latency(ch(n_ripp))*srate/1000)-win):((RT.latency(ch(n_ripp))*srate/1000)+win)),ripples(n_ch,((RT.latency(ch(n_ripp))*srate/1000)-win):((RT.latency(ch(n_ripp))*srate/1000)+win))*2+900,'color',[0 .4 0])
plot(RT.latency(ch(n_ripp))/1000,ones(1,1)*1250,'*','markersize',13,'color',[.6 0 0],'linewidth',2)
ylim([min(detrend(data(n_ch,((RT.latency(ch(n_ripp))*srate/1000)-win):((RT.latency(ch(n_ripp))*srate/1000)+win)))) max(ripples(n_ch,((RT.latency(ch(n_ripp))*srate/1000)-win):((RT.latency(ch(n_ripp))*srate/1000)+win))*2+900)+200])
else
plot(time(1,((RT.latency(ch(n_ripp))*srate/1000)-win):((RT.latency(ch(n_ripp))*srate/1000)+win)),ripples(n_ch,((RT.latency(ch(n_ripp))*srate/1000)-win):((RT.latency(ch(n_ripp))*srate/1000)+win))*2+2000,'color',[0 .4 0])
plot(RT.latency(ch(n_ripp))/1000,ones(1,1)*2500,'*','markersize',13,'color',[.6 0 0],'linewidth',2)
ylim([min(detrend(data(n_ch,((RT.latency(ch(n_ripp))*srate/1000)-win):((RT.latency(ch(n_ripp))*srate/1000)+win)))) max(ripples(n_ch,((RT.latency(ch(n_ripp))*srate/1000)-win):((RT.latency(ch(n_ripp))*srate/1000)+win))*2+2000)+500])
end
hold off
% plot(time,ripples*2+4000,'color',[.6 0 0])
% hold on; plot(time(1,((RT.latency(n_ripp)*srate/1000)-win):((RT.latency(n_ripp)*srate/1000)+win)),ripples*2 + 600,'color',[0 0 .6])
% hold on;plot(RT.latency(ch1),ones(1,sum(ch1))*1000,'*','markersize',8,'color',[.6 0 0])
xlim([time(1,round((RT.latency(ch(n_ripp))*srate/1000)-win)) time(1,round((RT.latency(ch(n_ripp))*srate/1000)+win))])
if strcmp(rat_ripples(n_rat).name,'SB42')
title(['Rat ' rat_ripples(n_rat).name ', ' sessions(n_ses).name(1:9) ' ' sessions(n_ses).name(11:12) '/' sessions(n_ses).name(14:15) ', tetrode ' num2str(tetrodes(1,ceil(n_ch/4))) ', channel ' num2str(channels(n_ch,1))]...
      ,'fontsize',16,'fontweight','demi','color',[.6 0 0])
else
title(['Rat ' rat_ripples(n_rat).name ', ' sessions(n_ses).name(1:9) ' ' sessions(n_ses).name(16:17) '/' sessions(n_ses).name(19:20) ', tetrode ' num2str(tetrodes(1,ceil(n_ch/4))) ', channel ' num2str(channels(n_ch,1))]...
      ,'fontsize',16,'fontweight','demi','color',[.6 0 0])    
end
  hleg = legend('\color[rgb]{0 0 0}raw LFP','\color[rgb]{0 .4 0}filtered 100-250 Hz',['\color[rgb]{.6 0 0}event ' num2str(n_ripp) '/' num2str(size(ch,2))]);
set(hleg,'fontsize',12,'fontweight','demi','location','southwest')
set(gca,'fontsize',16,'box','off')%,'xcolor','w',)
set(gcf,'color','w','paperunits','points','PaperPosition', [0 40 1040 540])

n_ch = 2; % elijo el canal a plotear
n_ch = 4*(n_ch - 1) + 1; % como estan los cuatro canales de cada tetrodo, con esta linea se salta al tetrodo siguiente cuando n_ch = n_ch + 1;
% ch = RT.est == n_ch; % crea un vector logico con los ripples detectados que pertenecen a este canal
% ch = find(ch == 1);
% n_ripp = 3;
subplot(2,1,2)
plot(time(1,round((RT.latency(ch(n_ripp))*srate/1000)-win):round((RT.latency(ch(n_ripp))*srate/1000)+win)),detrend(data(n_ch,round((RT.latency(ch(n_ripp))*srate/1000)-win):round((RT.latency(ch(n_ripp))*srate/1000)+win))),'k')
hold on
if strcmp(rat_ripples(n_rat).name,'SB34') || strcmp(rat_ripples(n_rat).name,'SB41')
% plot(RT.latency(ch)/1000,ones(1,sum(ch))*5000,'*','markersize',13,'color',[0 0 .6])
plot(time(1,((RT.latency(ch(n_ripp))*srate/1000)-win):((RT.latency(ch(n_ripp))*srate/1000)+win)),ripples(n_ch,((RT.latency(ch(n_ripp))*srate/1000)-win):((RT.latency(ch(n_ripp))*srate/1000)+win))*2+900,'color',[0 .4 0])
% plot(RT.latency(ch(n_ripp))/1000,ones(1,1)*1000,'*','markersize',13,'color',[.6 0 0],'linewidth',2)
ylim([min(detrend(data(n_ch,((RT.latency(ch(n_ripp))*srate/1000)-win):((RT.latency(ch(n_ripp))*srate/1000)+win)))) max(ripples(n_ch,((RT.latency(ch(n_ripp))*srate/1000)-win):((RT.latency(ch(n_ripp))*srate/1000)+win))*2+900)+150])
else
plot(time(1,((RT.latency(ch(n_ripp))*srate/1000)-win):((RT.latency(ch(n_ripp))*srate/1000)+win)),ripples(n_ch,((RT.latency(ch(n_ripp))*srate/1000)-win):((RT.latency(ch(n_ripp))*srate/1000)+win))*2+2000,'color',[0 .4 0])
% plot(RT.latency(ch(n_ripp))/1000,ones(1,1)*2500,'*','markersize',13,'color',[.6 0 0],'linewidth',2)
ylim([min(detrend(data(n_ch,((RT.latency(ch(n_ripp))*srate/1000)-win):((RT.latency(ch(n_ripp))*srate/1000)+win)))) max(ripples(n_ch,((RT.latency(ch(n_ripp))*srate/1000)-win):((RT.latency(ch(n_ripp))*srate/1000)+win))*2+2000)+500])
end
hold off
xlim([time(1,round((RT.latency(ch(n_ripp))*srate/1000)-win)) time(1,round((RT.latency(ch(n_ripp))*srate/1000)+win))])
% xlabel('Time (s)','fontsize',18)
if strcmp(rat_ripples(n_rat).name,'SB42')
title(['Rat ' rat_ripples(n_rat).name ', ' sessions(n_ses).name(1:9) ' ' sessions(n_ses).name(11:12) '/' sessions(n_ses).name(14:15) ', tetrode ' num2str(tetrodes(1,ceil(n_ch/4))) ', channel ' num2str(channels(n_ch,1))]...
      ,'fontsize',16,'fontweight','demi','color',[.6 0 0])
else
title(['Rat ' rat_ripples(n_rat).name ', ' sessions(n_ses).name(1:9) ' ' sessions(n_ses).name(16:17) '/' sessions(n_ses).name(19:20) ', tetrode ' num2str(tetrodes(1,ceil(n_ch/4))) ', channel ' num2str(channels(n_ch,1))]...
      ,'fontsize',16,'fontweight','demi','color',[.6 0 0])    
end% hleg = legend('\color[rgb]{0 0 0}raw LFP','\color[rgb]{0 .4 0}filtered 100-250 Hz',['\color[rgb]{.6 0 0}event ' num2str(n_ripp) '/' num2str(size(ch,2))]);
% set(hleg,'fontsize',12,'fontweight','demi','location','southwest')
set(gca,'fontsize',16,'box','off')
set(gcf,'color','w','paperunits','points','PaperPosition', [0 40 1040 640])

% n_ch = 3; % elijo el canal a plotear
% n_ch = 4*(n_ch - 1) + 1; % como estan los cuatro canales de cada tetrodo, con esta linea se salta al tetrodo siguiente cuando n_ch = n_ch + 1;
% % ch = RT.est == n_ch; % crea un vector logico con los ripples detectados que pertenecen a este canal
% % ch = find(ch == 1);
% % n_ripp = 3;
% subplot(3,1,3)
% plot(time(1,round((RT.latency(ch(n_ripp))*srate/1000)-win):round((RT.latency(ch(n_ripp))*srate/1000)+win)),detrend(data(n_ch,round((RT.latency(ch(n_ripp))*srate/1000)-win):round((RT.latency(ch(n_ripp))*srate/1000)+win))),'k')
% hold on
% if strcmp(rat_ripples(n_rat).name,'SB34') || strcmp(rat_ripples(n_rat).name,'SB41')
% % plot(RT.latency(ch)/1000,ones(1,sum(ch))*5000,'*','markersize',13,'color',[0 0 .6])
% plot(time(1,((RT.latency(ch(n_ripp))*srate/1000)-win):((RT.latency(ch(n_ripp))*srate/1000)+win)),ripples(n_ch,((RT.latency(ch(n_ripp))*srate/1000)-win):((RT.latency(ch(n_ripp))*srate/1000)+win))*2+1000,'color',[0 .4 0])
% % plot(RT.latency(ch(n_ripp))/1000,ones(1,1)*1000,'*','markersize',13,'color',[.6 0 0],'linewidth',2)
% ylim([min(detrend(data(n_ch,((RT.latency(ch(n_ripp))*srate/1000)-win):((RT.latency(ch(n_ripp))*srate/1000)+win)))) max(ripples(n_ch,((RT.latency(ch(n_ripp))*srate/1000)-win):((RT.latency(ch(n_ripp))*srate/1000)+win))*2+1000)+250])
% else
% plot(time(1,((RT.latency(ch(n_ripp))*srate/1000)-win):((RT.latency(ch(n_ripp))*srate/1000)+win)),ripples(n_ch,((RT.latency(ch(n_ripp))*srate/1000)-win):((RT.latency(ch(n_ripp))*srate/1000)+win))*2+2000,'color',[0 .4 0])
% % plot(RT.latency(ch(n_ripp))/1000,ones(1,1)*2500,'*','markersize',13,'color',[.6 0 0],'linewidth',2)
% ylim([min(detrend(data(n_ch,((RT.latency(ch(n_ripp))*srate/1000)-win):((RT.latency(ch(n_ripp))*srate/1000)+win)))) max(ripples(n_ch,((RT.latency(ch(n_ripp))*srate/1000)-win):((RT.latency(ch(n_ripp))*srate/1000)+win))*2+2000)+500])
% end
% hold off
% xlim([time(1,round((RT.latency(ch(n_ripp))*srate/1000)-win)) time(1,round((RT.latency(ch(n_ripp))*srate/1000)+win))])
% xlabel('Time (s)','fontsize',18)
% title(['Rat ' rat_ripples(n_rat).name ', ' sessions(n_ses).name(1:9) ' ' sessions(n_ses).name(16:17) '/' sessions(n_ses).name(19:20) ', tetrode ' num2str(tetrodes(1,ceil(n_ch/4))) ', channel ' num2str(channels(n_ch,1))]...
%       ,'fontsize',16,'fontweight','demi','color',[.6 0 0])
% % hleg = legend('\color[rgb]{0 0 0}raw LFP','\color[rgb]{0 .4 0}filtered 100-250 Hz',['\color[rgb]{.6 0 0}event ' num2str(n_ripp) '/' num2str(size(ch,2))]);
% % set(hleg,'fontsize',12,'fontweight','demi','location','southwest')
% set(gca,'fontsize',16,'box','off')
% set(gcf,'color','w','paperunits','points','PaperPosition', [0 40 1040 640])

%% GUARDA LA FIGURA
% n_ch = 5;
if find(tetrodes(1,ceil(n_ch/4))) == 1 && isempty(dir('figuras_ripples'))
    mkdir('figuras_ripples')
end
cd('figuras_ripples')

example = 2;
if example == 1 % si es el primer ejemplo que se crea para este canal, se creara una carpeta con el nombre del tetrodo al que pertenece
    mkdir(['TT' num2str(num2str(tetrodes(1,ceil(n_ch/4))))])
end
cd(['TT' num2str(num2str(tetrodes(1,ceil(n_ch/4))))])
if strcmp(rat_ripples(n_rat).name,'SB42')
    iname = ['ripples_' exp_dir(n_rat).name '_' sessions(n_ses).name(1:9) '_' sessions(n_ses).name(11:12) '_' sessions(n_ses).name(14:15) '_tt' num2str(tetrodes(1,ceil(n_ch/4)))...
    '_ex' num2str(example)]; 
else
iname = ['ripples_' exp_dir(n_rat).name '_' sessions(n_ses).name(1:9) '_' sessions(n_ses).name(16:17) '_' sessions(n_ses).name(19:20) '_tt' num2str(tetrodes(1,ceil(n_ch/4)))...
    '_ex' num2str(example)]; 
end
print(gcf,'-dtiff',iname,'-r0')
display(['figure ' num2str(example) ' (ripple ' num2str(n_ripp) ') saved'])
cd ..
cd ..

%%
clf
ws_dir = 'C:\Users\neuro\Dropbox\SB\RESULTADOS\SPIKES\NEURONS\Protocolo 2';
cd(ws_dir)
if strcmp(rat_ripples(n_rat).name,'SB42')
wss = dir(['workspace_' rat_ripples(n_rat).name '_' sessions(n_ses).name(11:15) '*']);
else
wss = dir(['workspace_' rat_ripples(n_rat).name '_' sessions(n_ses).name(16:20) '*']);
end
load(wss(1).name)
cd(base_dir); cd(exp_dir(n_rat).name); cd(sessions(n_ses).name)
TTLaux = V_f{1,1}.TTLaux;
% TTLaux(:,6) = TTLaux(:,6).*20; 
gos = TTLaux(:,1) == 11;

n_ch = 3;
% n_ch = 4*(n_ch - 1) + 1;
t = ((1:size(data(n_ch,:),2)))/srate;
sp = subplot(1,1,1);
plot(t,data(n_ch,:),'w')
hold on
plot(t,ripples(n_ch,:)*2 + 2000,'r')
% plot(t,theta(n_ch,:)-500,'color',[.4 .4 1],'linewidth',2)
plot([(TTLaux(gos,6))/1000 (TTLaux(gos,6))/1000],[-3000 19000],'g--','linewidth',2)
% plot(t,data(5,:)+2500,'w')
% plot(t,ripples(5,:)+4000,'r')
% plot(t,data(9,:)+4500,'w')
% plot(t,ripples(9,:)+6500,'r')
% plot(t,data(14,:)+7500,'w')
% plot(t,ripples(14,:)+9000,'r')
% plot(t,data(20,:)+10000,'w')
% plot(t,ripples(20,:)+12000,'r')
% plot(t,data(21,:)+12000,'w')
% plot(t,ripples(21,:)+13500,'r')
% plot(t,data(25,:)+14500,'w')
% plot(t,ripples(25,:)+16000,'r')
% text([(TTLaux(gos,6))/1000+0.1 (TTLaux(gos,6))/1000+0.1],[15000 15000],'HIT','color',[0 1 0],'fontweigth','demi')
hold off
xlim([0 t(end)])

if strcmp(rat_ripples(n_rat).name,'SB42')
title(['Rat ' rat_ripples(n_rat).name ', ' sessions(n_ses).name(1:9) ' ' sessions(n_ses).name(11:12) '/' sessions(n_ses).name(14:15) ', tetrode ' num2str(tetrodes(1,ceil(n_ch/4))) ', channel ' num2str(channels(n_ch,1))]...
      ,'fontsize',16,'fontweight','demi','color',[1 0 0])
else
title(['Rat ' rat_ripples(n_rat).name ', ' sessions(n_ses).name(1:9) ' ' sessions(n_ses).name(16:17) '/' sessions(n_ses).name(19:20) ', tetrode ' num2str(tetrodes(1,ceil(n_ch/4))) ', channel ' num2str(channels(n_ch,1))]...
      ,'fontsize',16,'fontweight','demi','color',[1 0 0])    
end
set(gcf,'color','k','paperunits','points','PaperPosition', [0 40 1040 540])
set(sp,'color','k')
set(gca,'ycolor','w','xcolor','w')
gospos = find(gos == 1); 

%%
win = 1;%*srate;
go_trial = 7;

xlim([TTLaux(gospos(go_trial,1),6)/1000-win/2 TTLaux(gospos(go_trial,1),6)/1000+win])
ylim([-1000 2500])
xlabel(['HIT trial n° ' num2str(go_trial)])
hold on
text(TTLaux(gospos(go_trial,1),6)/1000+0.1,17000,'HIT','color',[0 1 0],'fontweight','demi')
hold off

%% 
clf
ws_dir = 'C:\Users\neuro\Dropbox\SB\RESULTADOS\SPIKES\NEURONS\Protocolo 2';
cd(ws_dir)
if strcmp(rat_ripples(n_rat).name,'SB42')
wss = dir(['workspace_' rat_ripples(n_rat).name '_' sessions(n_ses).name(11:15) '*']);
else
wss = dir(['workspace_' rat_ripples(n_rat).name '_' sessions(n_ses).name(16:20) '*']);
end
load(wss(1).name)
cd(base_dir); cd(exp_dir(n_rat).name); cd(sessions(n_ses).name)
set(gcf,'color','w','paperunits','points','Position', [60 90 1340 640])
TTLaux = V_f{1,1}.TTLaux;
% TTLaux(:,6) = TTLaux(:,6).*20; 
gos = TTLaux(:,1) == 11;
n_ch = 3;
% n_ch = 4*(n_ch - 1) + 1;
downsrate = 1000;
data_ds = resample(double(data)',downsrate,srate)';
ripples_ds = resample(double(ripples)',downsrate,srate)';
t = ((1:size(data_ds(n_ch,:),2)))/downsrate;
plot(t,data_ds(n_ch,:),'k')
hold on
% plot(t,data_ds(1,:) + 1500,'k')

plot(t,ripples_ds(n_ch,:)*2 + 2000,'r')
plot(t,gamma(n_ch,:),'color',[0 .5 0])
plot(t,theta(n_ch,:) - 500,'b','linewidth',2)

plot([(TTLaux(gos,6))/1000 (TTLaux(gos,6))/1000],[-5000 5000],'g--','linewidth',2)

xlim([0 1])
ylim([-1000 3000])
step = 0.1;

for j = 1:100000
    
    xlim([0 2] + j*step)
    title(['Time = ' num2str(mean(xlim())) ' s'])
    pause(0.000001)
    
end

%% inspection of ripples in each trial

clc
clear
sdr = 3;

base_dir = 'C:\Users\neuro\Dropbox\VT\LFP_data';
cd(base_dir)
display('loading ripples data...')
load(['ripples_data_raw_SD_' num2str(sdr) '.mat'])

% SELECCIONA LA RATA. n_rat = 1, SB32; 2, SB33; 3, SB34; 4, SB35; 5, SB37; 6, SB41; 7, SB42.
n_rat = 6;
exp_dir = [base_dir '\' rat_ripples(n_rat).name];
cd(exp_dir)

sessions = dir('session*');

% SELECCIONA LA SESION
n_ses = 7;
cd(sessions(n_ses).name)

RT = rat_ripples(n_rat).ripples_data{n_ses,1};
display('loading LFP of the selected session...')
load('LFP.mat')
load('TTL.mat','TTL')
if n_rat == 2 && n_ses == 1
    data = data(:,300000:2850000);
elseif n_rat == 2 && n_ses == 2
    data = data(:,1:2100000);
elseif n_rat == 2 && n_ses == 3
    data = data(:,1:2390000);
elseif n_rat == 2 && n_ses == 4
    data = data(:,1000000:2190000);
elseif n_rat == 2 && n_ses == 6
    data = data(:,1:1850000);    
elseif n_rat == 4 && n_ses == 1;
    data = data(:,1:end-50000);
elseif n_rat == 4 && n_ses == 3;
    data = data(:,1:end/2-100000);
elseif n_rat == 4 && n_ses == 4
    data = data(:,1430000:end);
elseif n_rat == 4 && n_ses == 5
    data = data(:,1:end/2+300000);
elseif n_rat == 4 && n_ses == 6
    data = data(:,1:end-900000);
elseif n_rat == 4 && n_ses == 7
    data = data(:,end/2+90000:end-30000);
elseif n_rat == 4 && n_ses == 8
    data = data(:,1:end-400000);
elseif n_rat == 4 && n_ses == 9
    data = data(:,1000000:2010000);    
elseif n_rat == 6 && n_ses == 8;
    data = data(:,250000:1400000);
elseif n_rat == 6 && n_ses == 3;
    data = data(:,end/2-10000:end-100000);
end

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
% theta = eegfilt(data,srate,6,10);
display('data ready for plotting.')
beep
pause(.5)
beep

%%
clf
n_ch = 17;
% n_ch = 4*(n_ch - 1) + 1;
ch = find(RT.est == n_ch);
t = ((1:size(data(n_ch,:),2)))/srate;

plot(t,detrend(data(n_ch,:)),'k')
hold on
plot(RT.latency(ch)/1000,ones(1,size(ch,2))*1500,'*','markersize',13,'color',[0 0 .6])
plot(t,ripples(n_ch,:)*2 + 1000,'r')
plot([TTL(:,2)/1000 TTL(:,2)/1000],[-3000 6000],'g--','linewidth',2)
hold off

%%
win = 6;
trial = 1;

xlim([(TTL(trial,2)/1000)-win/2 (TTL(trial,2)/1000)+win/2])
ylim([-1000 2000])
