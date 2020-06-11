clc;clear;

%% TTL detection for INTAN recordings (.rhd)
% ONLY IF TTL file has been not created yet

disp('---------------------');
disp(' Creating TTL file');
disp('---------------------');

list_lan = dir('*lan*'); %LAN must be created from .rhd files (rhd2lan script)
disp('loading LAN...');
load(list_lan(1).name); %Load LAN
srate = 20000;
disp('detecting TTL pulses from digital channel...');

% %for RHD recordings:
% filename = list_lan(1).name(1:10);
% ch_TTL = LAN.ttl'; %selecting channel where TTL pulses are stored
% TTL = ch_TTL > 0; % detecting over-threshold pulses

% %for AMPLIPEX recordings:
filename = list_lan(1).name(5:end-4);
a = cell2mat(LAN.data);
ch_TTL = a(33,:); %selecciona el canal 33 (donde están los TTL)
TTL = ch_TTL > 1000; % umbral de deteccion de TTL's (amplitud), se seleccionan todos los que pasan de mil

time = (0:1:length(ch_TTL))/srate; % creating time vector (point-by-point)
TTL = diff(TTL) == 1;
ts_TTL = time(TTL); % TTL timestamps
ts_TTL = ts_TTL(1:end-3); %delete TTLs that will be not considered (if needed) 

disp('saving TTLs...');
clear C_f
res.ch_TTL = ch_TTL;
res.ts_TTL = ts_TTL;

if exist('C_f') && iscell(C_f)
    C_f = [C_f; res];
else
    C_f = {res};
end
clear res;
save(['TTL_' filename], 'C_f')
disp('---------------------');
disp(' DONE ');
disp('---------------------');
warndlg('READY')

%% MAKING TT: CORRER EN MATLAB DE 64bits!!!

%for AMPLIPEX recordings:
% The main folder must be that which stores all sessions of the animal
clear;clc
tic
display('---------------------')
display('   MAKING TTR FILES')
display('----------------------')

rat = 'SB34';
path = 'E:\CEBA 14-004\2015\';

rat_dir = [path rat];

TT =[26 28 30 32;  % TT1 
     18 20 22 24;  % TT2
     10 12 14 16;  % TT3
     2 4 6 8;      % TT4
     25 27 29 31;  % TT5
     17 19 21 23;  % TT6
     9 11 13 15;   % TT7
     1 3 5 7];     % TT8  
 
cd(rat_dir)

list_session = dir('_session*');
for s = 1%:length(list_session)
     session = list_session(s).name;
     cd(session);
     
     display(session(1:end))
     if ~strcmp(session(end-5:end),'tambor')
%          lan_id = dir('*LAN*');
%          load(lan_id(1).name);
         %Detect spikes by Quiroga's method for each ttr:
         for d = 1:length(TT)
             display(' ')
             display(['TT' num2str(d)])
             display('filtering between 300-5000 Hz and detecting occurrences (putative spikes)...')
             [T,WV,n] = makeTTDAT_large(TT(d,:));
             %WV = 0.1*WV;
             disp(['saving ttr' num2str(d) ' file...']);
             save([session(11:end) '_tt' num2str(d) '.ttr'],'T','WV','n');
             disp(['TT' num2str(d) ' file ready']);
         end
         cd ..
     else
         display('tambor session')
         cd ..
     end
 end
           

disp('*********** tetrodes made ************')
msgbox_icon = imread('bien.jpg');
msgbox('TETRODES MADE','Enhorabuena','custom',msgbox_icon)
toc
%% MAKING TT 

%for INTAN recordings:
% The main folder must be that which stores all sessions of the animal
clc
list_session = dir(['session*' '*a']);

    TT =[   25 26 27 28; 
            29 30 31 32; 
            1 2 3 4; 
            5 6 7 8;
            21 22 23 24;
            17 18 19 20;
            13 14 15 16;
            9 10 11 12];        

for s = 5%1:length(list_session)
    session = list_session(s).name;
    what_session = what(session);
    
    %enter into the specified folder:
    cd(what_session.path);
    
    a = dir('*lan*');
    filelan = a(1).name;
    load(filelan)
    
    %Detect spikes by Quiroga's method for each ttr:
    for d = 1:length(TT)
        [T,WV,n] = makeTTRHD_lan(LAN,TT(d,:));
        %WV = 0.1*WV;
        disp(['saving ttr' num2str(d) '...']);
        save([filelan(1:10) '_tt' num2str(d) '.ttr'],'T','WV','n');
        disp(['tt' num2str(d) ' listo']);
        
    end
    
    %return:
    cd ..    
    
end
          
disp('*********** tetrodes made ************')
msgbox_icon = imread('bien.jpg');
msgbox('TETRODES MADE','Enhorabuena','custom',msgbox_icon)
beep


%% CALCULATE WAVEFORMS' FEATURES FOR SPIKE SORTING
% The main folder must be that which stores all sessions of the animal
clc
tic
disp('--------------------------------');
disp(' WAVEFORMS FEATURES CALCULATION ');
disp('--------------------------------');
rat_dir = 'F:\CEBA 14-004\2016\SB37';
cd(rat_dir)
list_session = dir('session*');
for s = 1:length(list_session)
    cd(list_session(s).name);
    if ~strcmp(list_session(s).name(end-5:end),'tambor')
        RunClustBatch('Batch_Q.txt')        
        cd ..
    else
        cd ..
    end
    
end


disp('--------------------------------');
disp(' DONE ');
disp('--------------------------------');
toc
%% WAVEFORM SHORTENING (to better visualize them in Mclust GUI)

clc;
ses = dir('*.ttr');
disp('________________________');
disp('SHORTENING WAVEFORMS...');
disp('________________________')
disp('  ');
for tt_n = 1:length(ses);
    tic
    ses_name = ses(1).name(1:end-5);
    load([ses_name num2str(tt_n) '.ttr'],'-mat')
    WV = WV*0.1;
    save([ses_name num2str(tt_n) '.ttr'],'T','WV','n')
    disp(['tetrode ' num2str(tt_n) ' done:   ' num2str(toc) ' sec'])

    
end
clear
display('READY')
disp('________________________')
disp('________________________')

%%

clc
MClust

%% SAVING TIME STAMPS OF SPIKES

clear;clc;
disp('saving spk_ files...')
list = dir('*.t');

for i = 1:length(list)

    spks = LoadSpikes_modSB({list(i).name}); 
    spks = Data(spks{1});
    save(['spk_SB29_09_23' list(i).name(end-7:end-2)],'spks') 
    clearvars -except list

end

disp('*** spk_ files saved ***') 
%% TTLaux: Grouping all times available
%col 1-5: response, HOLD, RX, RELEASE, TTL_ts 
clear list TTLaux;
list = dir('spk*');
list2 = dir('*TTL*');
load([list2(1).name]);
TTLaux(:,6) = C_f{1}.ts_TTL(1:end)*1000;
% FILL the other 5 columns of TTLaux from Excel (times of behavioral performance)


%%

% namebase = 'SB29';
% ttrs = dir('*.ttr');
% for i = 1:length(ttrs)
%     
%     tic
%     load(ttrs(i).name, '-mat');
%     filename = [namebase ttrs(i).name(14:end)];
%     save(filename, 'WV', 'T', 'n');
%     disp(['tetrode ' num2str(i) ' done:   ' num2str(toc) ' sec'])
%     clearvars WV T n;    
%     
% end


%% Grouping variables of interest:
% spikes, 


disp('---------------------');
disp(' Creating workspaces');
disp('---------------------');

for i = 1:length(list)
   
filename = list(i).name;

disp(['loading spike cluster #' num2str(i) '...']);
srate = 20000; % sampling rate
spikes = load(filename);
spikes = getfield(spikes, 'spks');
FR = numel(spikes)/((length(C_f{1}.ch_TTL))/srate); %calculating firing rate

disp('calculating waveforms...');
load([filename(5:end-6) '.ttr'], '-mat')%
% WV = WV/0.1; 

for k = 1:length(spikes),
    var = find(T == spikes(k)); %finds the row of the matrix T in which the value is equal to a given "k" timestamp of the spike
    if length(var) > 1,
        ind_spikes(k) = var(1);
        T(var(1)) = []; % para evitar timestamps duplicados
    else
        ind_spikes(k) = var;
    end
end

WV_spk = WV(ind_spikes,:,:);
t_spk = 1/srate:1/srate:(size(WV_spk,3))/srate; % ventana de tiempo de la espiga

for k = 1 : 4,
    
    A = squeeze(WV_spk(:,k,:));
    mean_spk = mean(A);
 
end

disp('saving variables of interest...');
clear V_f
res.firing_rate = FR;
res.spikes = spikes;
res.TTLaux = TTLaux;
res.mean_spk = mean_spk;

if exist('V_f') && iscell(V_f)
    V_f = [V_f; res];
else
    V_f = {res};
end

disp('---------------------');
save(['workspace' filename(4:end-4)], 'V_f');
clearvars -except TTLaux list C_f 

end

disp('---------------------');
disp('   workspaces made   ')
disp('---------------------');

warndlg('READY')


%% DISPLAY NAMES OF SPKS

clear;clc;

list_ses = dir('sess*');
for s = 1:length(list_ses)
   
    curr_sess = what(list_ses(s).name);
    cd(curr_sess.path);
    clear curr_sess;
    ws = dir('work*');
    if ~isempty(ws)
        
        list_spk = dir('spk*');
        for i = 1:length(list_spk)
            load(ws(i).name);
%             disp(list_spk(i).name);
            disp(V_f{1}.firing_rate);
            clear V_f;
            
        end
        cd ..
    else
        cd ..
    end
    
end