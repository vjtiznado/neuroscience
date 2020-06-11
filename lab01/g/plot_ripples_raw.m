%%
base_dir = 'C:\Users\pflab\Dropbox\VT\LFP_data';
cd(base_dir)
exp_dir = dir(fullfile(base_dir,'SB*'));

% SELECCIONA LA RATA. n_rat = 1, SB32; 2, SB33; 3, SB34; 4, SB41.
n_rat = 1;
cd(exp_dir(n_rat).name)
sessions = dir('session*');

% SELECCIONA LA SESION
n_ses = 4;
cd(sessions(n_ses).name)


load('LFP.mat')
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
beep
pause(.5)
beep
display('ready')
%%

n_ch = 1;
n_ch = 4*(n_ch - 1) + 1;
t = ((1:size(data(n_ch,:),2)))/srate;

figure(1)
clf
plot(t,data(n_ch,:),'k')
hold on
plot(t,ripples(n_ch,:)*2 + 3000,'r')
hold off

title(['Rat ' exp_dir(n_rat).name ', ' sessions(n_ses).name(1:9) ' ' sessions(n_ses).name(16:17) '/' sessions(n_ses).name(19:20) ', tetrode ' num2str(tetrodes(1,ceil(n_ch/4))) ', channel ' num2str(channels(n_ch,1))]...
      ,'fontsize',16,'fontweight','demi','color',[.6 0 0])
set(gcf,'color','w','paperunits','points','PaperPosition', [0 40 1140 540])

%%

if n_ch == 1 && isempty(dir('figuras_ripples'))
    mkdir('figuras_ripples')
end
cd('figuras_ripples')

example = 21;
if example == 1 % si es el primer ejemplo que se crea para este canal, se creara una carpeta con el nombre del tetrodo al que pertenece
    mkdir(['TT' num2str(num2str(tetrodes(1,ceil(n_ch/4))))])
end
cd(['TT' num2str(num2str(tetrodes(1,ceil(n_ch/4))))])
iname = ['ripples_' exp_dir(n_rat).name '_' sessions(n_ses).name(1:9) '_' sessions(n_ses).name(16:17) '_' sessions(n_ses).name(19:20) '_tt' num2str(tetrodes(1,ceil(n_ch/4)))...
    '_ex' num2str(example)]; % SI GUARDAS MAS DE UN EJEMPLO POR SESION, CAMBIAR ESTE NUMERO
print(gcf,'-dtiff',iname,'-r0')
display(['figure ' num2str(example) ' saved'])
cd ..
cd ..