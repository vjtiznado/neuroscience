%% ESTE PLOTEA TRIALS GOs EN BUSQUEDA DE RIPPLES

srate = 2000;
time = (1:size(SB41_trials.sessions{1,1}(1,:),2))/srate;
% time = (1:size(rat_trials(1).sessions{1,1}(1,:),2))/srate;
time = time - 3;

% nrat = 4;
nses = 9;
f_dir = ['C:\Users\pflab\Dropbox\VT\LFP_data\SB41\' SB41_trials.sessions{nses,2}(1:9) '_' SB41_trials.name '_' SB41_trials.sessions{nses,2}(16:20)];
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
base_dir = 'C:\Users\pflab\Dropbox\VT\LFP_data';
cd(base_dir)
exp_dir = dir(fullfile(base_dir,'SB*'));
display('loading ripples data...')
load('ripples_data_raw_SD_5.mat')

% SELECCIONA LA RATA. n_rat = 1, SB32; 2, SB33; 3, SB34; 4, SB41.
n_rat = 1;
cd(exp_dir(n_rat).name)
sessions = dir('session*');

% SELECCIONA LA SESION
n_ses = 2;
cd(sessions(n_ses).name)

RT = rat_ripples(n_rat).ripples_data{n_ses,1};
display('loading LFP of the selected session...')
load('LFP.mat')
display('filtering LFP between 100-250 Hz...')
for ch = 1:size(data,1)
    display(['ch ' num2str(ch) '/' num2str(size(data,1)) '...'])
    ripples(ch,:) = eegfilt(data(ch,:),srate,100,250);
end
display('data ready for plotting.')
beep
pause(.5)
beep

%%
% SELECCIONA EL CANAL (n_ch)
n_ch = 4;
n_ch = 4*(n_ch - 1) + 1;
ch = RT.est == n_ch;
ch = find(ch == 1);
display(num2str(size(ch,2)))
time = ((1:size(data(n_ch,:),2)))/srate;

% ELIGE EL RIPPLE QUE QUIERES PLOTEAR (n_ripp)
n_ripp = 1; % aqui seleccionas el ripple de esta sesion que quieres plotear
clf
% figure(2)
win = .5*srate;
% plot(time,detrend(data(n_ch,:)),'k')
plot(time(1,((RT.latency(ch(n_ripp))*srate/1000)-win):((RT.latency(ch(n_ripp))*srate/1000)+win)),detrend(data(n_ch,((RT.latency(ch(n_ripp))*srate/1000)-win):((RT.latency(ch(n_ripp))*srate/1000)+win))),'k')
hold on
% plot(RT.latency(ch),ones(1,sum(ch))*5000,'*','markersize',13,'color',[0 0 .6])
plot(time(1,((RT.latency(ch(n_ripp))*srate/1000)-win):((RT.latency(ch(n_ripp))*srate/1000)+win)),ripples(n_ch,((RT.latency(ch(n_ripp))*srate/1000)-win):((RT.latency(ch(n_ripp))*srate/1000)+win))*2+5000,'color',[0 .5 0])
plot(RT.latency(ch(n_ripp))/1000,ones(1,sum(ch(n_ripp)))*6000,'*','markersize',13,'color',[.6 0 0])
hold off
% plot(time,ripples*2+4000,'color',[.6 0 0])
% hold on; plot(time(1,((RT.latency(n_ripp)*srate/1000)-win):((RT.latency(n_ripp)*srate/1000)+win)),ripples*2 + 600,'color',[0 0 .6])
% hold on;plot(RT.latency(ch1),ones(1,sum(ch1))*1000,'*','markersize',8,'color',[.6 0 0])
ylim([min(detrend(data(n_ch,((RT.latency(ch(n_ripp))*srate/1000)-win):((RT.latency(ch(n_ripp))*srate/1000)+win)))) max(ripples(n_ch,((RT.latency(ch(n_ripp))*srate/1000)-win):((RT.latency(ch(n_ripp))*srate/1000)+win))*2+5000)+1000])
xlim([time(1,((RT.latency(ch(n_ripp))*srate/1000)-win)) time(1,((RT.latency(ch(n_ripp))*srate/1000)+win))])
xlabel('Time (s)')
title(['Rat ' rat_ripples(n_rat).name ', ' sessions(n_ses).name(1:9) ' ' sessions(n_ses).name(16:17) '/' sessions(n_ses).name(19:20) ', tetrode ' num2str(tetrodes(1,ceil(n_ch/4))) ', channel ' num2str(channels(n_ch,1))]...
      ,'fontsize',16,'fontweight','demi','color',[.6 0 0])
  hleg = legend('\color[rgb]{0 0 0}raw LFP','\color[rgb]{0 .5 0}filtered 100-250 Hz');
set(hleg,'fontsize',10,'fontweight','demi','location','northeast')
set(gcf,'color','w','paperunits','points','PaperPosition', [0 40 1040 540])


%% GUARDA LA FIGURA
iname = ['ripples_' rat_ripples(n_rat).name '_' sessions(n_ses).name(1:9) '_' sessions(n_ses).name(16:17) '_' sessions(n_ses).name(19:20) '_tt' num2str(tetrodes(1,ceil(n_ch/4)))...
    '_ex7']; % SI GUARDAS MAS DE UN EJEMPLO POR SESION, CAMBIAR ESTE NUMERO
print(gcf,'-dtiff',iname,'-r0')
display('figure saved')