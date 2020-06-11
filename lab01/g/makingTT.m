%%
% 
clear
clc
%% 1. crear LAN a partir de archivos.dat (saltarse al paso 3)

LAN = lan_from_dat();
LAN.srate = 20000; % Tasa de sampleo
LAN = lan_check(LAN);
lan_fill_gui(LAN);


%% 1.5 guardar LAN con el nomre del archivo dat original

save('SB09_10_23.mat','LAN', '-v7.3') 
disp('*********** saved ************')

%% 2. hacer tétrodos a partir de .dat
% clc
% 
% filename = 'LAN_session03.mat'; %cambiar NOMBRE para tratar con el siguiente segmento
% path = 'C:/...';

% % disp('tt1...')
% % [T,WV,n] = makeTTDAT([25 26 27 28], path); %makeTTDAT detecta las espigas por método de Quiroga
% % save([filename(1:end-4) '_tt1.ttr'], 'T', 'WV', 'n'); % el número del tétrodo debe coincidir con los canales de la línea 59
% 
% % disp('tt2...')
% % [T,WV,n] = makeTTDAT([29 30 31 32], path); %makeTTDAT detecta las espigas por método de Quiroga
% % save([filename(1:end-4) '_tt2.ttr'], 'T', 'WV', 'n'); % el número del tétrodo debe coincidir con los canales de la línea 59
% 
% disp('tt3...')
% [T,WV,n] = makeTTDAT([1 2 3 4]); %makeTTDAT detecta las espigas por método de Quiroga
% save([filename(1:end-4) '_tt3.ttr'], 'T', 'WV', 'n'); % el número del tétrodo debe coincidir con los canales de la línea 59
% 
% [T,WV,n] = makeTTDAT([5 6 7 8]); %makeTTDAT detecta las espigas por método de Quiroga
% save([filename(1:end-4) '_tt4.ttr'], 'T', 'WV', 'n'); % el número del tétrodo debe coincidir con los canales de la línea 59
% disp('tt4...')
% 
% % [T,WV,n] = makeTTDAT([21 22 23 24]); %makeTTDAT detecta las espigas por método de Quiroga
% % save([filename(1:end-4) '_tt5.ttr'], 'T', 'WV', 'n'); % el número del tétrodo debe coincidir con los canales de la línea 59
% % disp('tt5...')
% 
% disp('tt6...')
% [T,WV,n] = makeTTDAT([17 18 19 20]); %makeTTDAT detecta las espigas por método de Quiroga
% save([filename(1:end-4) '_tt6.ttr'], 'T', 'WV', 'n'); % el número del tétrodo debe coincidir con los canales de la línea 59
% 
% disp('tt7...')
% [T,WV,n] = makeTTDAT([13 14 15 16]); %makeTTDAT detecta las espigas por método de Quiroga
% save([filename(1:end-4) '_tt7.ttr'], 'T', 'WV', 'n'); % el número del tétrodo debe coincidir con los canales de la línea 59
% 
% disp('tt8...')
% [T,WV,n] = makeTTDAT([9 10 11 12]); %makeTTDAT detecta las espigas por método de Quiroga
% save([filename(1:end-4) '_tt8.ttr'], 'T', 'WV', 'n'); % el número del tétrodo debe coincidir con los canales de la línea 59
% 
% clearvars -except nLAN filename t0 new_t0;
% 
% disp('*********** tetrodes made ************')
% msgbox_icon = imread('bien.jpg');
% msgbox('TETRODES MADE','Enhorabuena','custom',msgbox_icon)


%% for INTAN recordings:

clear;clc;
TT =[25 26 27 28; 
    29 30 31 32; 
    1 2 3 4; 
    5 6 7 8;
    21 22 23 24;
    17 18 19 20;
    13 14 15 16;
    9 10 11 12];

a = dir('*.mat');
filelan = a(1).name;

for d = 1:length(TT)
    [T,WV,n] = makeTTRHD_lan(filelan,TT(d,:));
%     WV = 0.1*WV;
    save(['SB34_03_15b_tt' num2str(d) '.ttr'],'T','WV','n');
    disp(['tt' num2str(d) '' 'listo']);
end           

disp('*********** tetrodes made ************')
msgbox_icon = imread('bien.jpg');
msgbox('TETRODES MADE','Enhorabuena','custom',msgbox_icon)
beep

%% 3. Extraccion de info de las espigas detectadas (para Klustakwik)
% (Ubicarse en la carpeta donde estï¿½n lo tï¿½trodos a analizar)

RunClustBatch('Batch_Q.txt')
warndlg('OK!');

%% Shortening of waveform amplitude

list = dir('*.ttr');
for i = 1:length(list)
    filename = list(i).name;
%     filename = 'LAN_session06_tt7.ttr';
    load(filename,'T', 'WV', 'n','-mat')
    WV= WV*0.1; %if multiply, waveform shortens; if divide, waveform enlarges
    save(filename,'WV', 'T', 'n');
    disp(['done' '      ' filename(1:end-4)]);
    disp('');
    clearvars -except list
    
end

%% 4. Abrir Klustakwik

MClust

% aï¿½adir features
% agrupar clusters
% determinar veracidad de las neuronas segï¿½n ISI
% extraer figuras ??? (forma de onda, ISI, autocorr)

%% 6. Creación del archivo spk (timestamps de espigas)
disp('saving spk_ files...')

list = dir('*.t');

for i = 1:length(list)

    spks = LoadSpikes_modSB({list(i).name}); %cambiar nombre segï¿½n el cluster
    spks = Data(spks{1});
    save(['spk_SB35_02_08' list(i).name(14:end-2)],'spks') 
    clearvars -except list

end

disp('*** spk_ files saved ***')
