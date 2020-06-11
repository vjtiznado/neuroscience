%% Shortening of waveform amplitude
 
list = dir('*.ttr');
for i = 1:length(list)
    filename = list(i).name;
%     filename = 'LAN_session06_tt7.ttr';
    try
        load(filename,'T', 'WV', 'n','ttr_conc_order','-mat')
    catch
        load(filename,'T', 'WV', 'n','-mat')
    end
    WV= WV*0.1; %if multiply, waveform shortens; if divide, waveform enlarges
    try               
        save(filename,'WV', 'T', 'n','ttr_conc_order');
    catch
        save(filename,'WV', 'T', 'n');
    end
    disp(['done' '      ' filename(1:end-4)]);
    disp('');
    clearvars -except list
     
end

%% 4. Abrir Klustakwik
 
MClust


% anhadir features
% agrupar clusters
% determinar veracidad de las neuronas segun ISI
% extraer figuras ??? (forma de onda, ISI, autocorr)
 
%% 6. Creación del archivo spk (timestamps de espigas)
disp('saving spk_ files...')
 
list = dir('*.t');
 
for i = 1:length(list)
 
    spikes = LoadSpikes_modSB({list(i).name}); %cambiar nombre segï¿½n el cluster
    spikes = Data(spikes{1});
    save(['spk_' list(i).name(1:end-2) '.mat'],'spikes') 
    clearvars -except list
 
end
 
disp('*** spk_ files saved ***')