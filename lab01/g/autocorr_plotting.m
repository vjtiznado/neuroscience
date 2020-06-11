clear

list = rdir('workspace*');
load('logic_anticipatory');
Autocorr_prepost = cell(2,3);
% ws = 37;
for ws = 1:length(list)
    clearvars -except list ws conc_hist log_osc2 logic_anticipatory autocorr_pre autocorr_post time_pre time_post
    disp(['analyzing neuron ' num2str(ws) ', ' list(ws).name(11:end-4)])
    load(list(ws).name)
    srate = 20000;
    spikes = V_f{1,1}.spikes;
    TTLaux = V_f{1,1}.TTLaux;
    clear V_f
    
    TTLaux = sortrows(TTLaux,2);                 % se ordenan por orden ascendente de tiempo de espera entre press-TTL
    TTLaux(:,7) = TTLaux(:,6) - TTLaux(:,2);   % columna 6 que tendra, en ms, el timestamp del lever press
    TTLaux = TTLaux';
    TTLaux(2:end,:) = TTLaux(2:end,:).*20; % deja todos los tiempos de TTLaux en puntos, ya que los timestamps de las espigas estan en puntos
    
    time_window = 1;                                   % tamanio total de la ventana del raster, en segundos
    tw_pts = time_window*srate;                        % time_window expresado en puntos
    
    % preallocating memory
    spikes_prev_press = nan(1,length(spikes));
    spikes_post_press = nan(1,length(spikes));

    %  creacion del raster para todos los trials juntos, sorteados por tiempo de espera entre press-TTL
    
    for i = 1:length(TTLaux(1,:))
        
        aux_pre = spikes( spikes > TTLaux(7,i) - tw_pts & spikes < TTLaux(7,i) );
        spikes_prev_press(1,length(find(~isnan(spikes_prev_press(1,:))))+1:length(find(~isnan(spikes_prev_press(1,:))))+length(aux_pre)) = aux_pre; % timestamps de la espiga en el raster PRESS
        
        aux_post = spikes( spikes > TTLaux(7,i)  & spikes < TTLaux(7,i) + tw_pts);
        spikes_post_press(1,length(find(~isnan(spikes_post_press(1,:))))+1:length(find(~isnan(spikes_post_press(1,:))))+length(aux_post)) = aux_post; % timestamps de la espiga en el raster PRESS

    end
    spikes_prev_press = spikes_prev_press(:,1:length(nonzeros(~isnan(spikes_prev_press(1,:))))); % elimina los nan
    spikes_post_press = spikes_post_press(:,1:length(nonzeros(~isnan(spikes_post_press(1,:))))); % elimina los nan
    clear aux_rxnt aux_press aux_ttl aux_release i    
    
    maxlag = 1000;
    bin = 1;
%     spks_autocorr(spikes_prev_press*1000/srate, ones(size(spikes_prev_press)))
    [autocorr_pre(ws,:), time_pre] = corr_cruz(spikes_prev_press*1000/srate ,spikes_prev_press*1000/srate,maxlag, bin);
    [autocorr_post(ws,:) , time_post] = corr_cruz(spikes_post_press*1000/srate ,spikes_post_press*1000/srate,maxlag, bin);
    
    subplot(121)
    bar(time_pre, autocorr_pre(ws,:)); 
    if logic_anticipatory(ws,1) == 1
        title(['cell #  ' num2str(ws) '  ant'])
    else
        title(['cell #  ' num2str(ws) '  nant'])
    end
    xlim([-1000 1000]);
    
    subplot(122)
    bar(time_post, autocorr_post(ws,:));
      xlim([-1000 1000]);
  
    log_osc2(ws,1) = input('yes or not?   '); 
%     ginput(ws);

%     folder_dir = 'C:\Users\pflab\Desktop\análisis_SB32_SB33\copia_spks_HIPP\Stim2\sin SB12\figuras_autocorr';
%     cd(folder_dir);
%     fname = ['autocorr_' list(ws).name(11:end-4) '_t2'];
%     print(gcf,'-dtiff',fname,'-r0')
%     pause(.3)
%     close
%     pause(.2)
%     cd ..
    
end
    Autocorr_prepost{1,1} = autocorr_pre;
    Autocorr_prepost{1,2} = autocorr_post;
    Autocorr_prepost{1,3} = time_pre;
    Autocorr_prepost{2,1} ={'autocorr_pre'};
    Autocorr_prepost{2,2} = {'autocorr_post'};
    Autocorr_prepost{2,3} = {'time'};
    
    log_osc2 = logical(log_osc2);

%%

%all ant:
f1 = figure(10);
% subplot(131)
% % cax         = [-0.2 0.6]; %set colobar limits
% imagesc(Autocorr{1,2}(1,:), 1:length(Autocorr{1,1}(:,1)), Autocorr{1,1});
imagesc(Autocorr{1,2}(1,:), 1:length(Autocorr{1,1}(:,1)), Autocorr{1,1});

title('Hit', 'FontSize',14,'FontName','Arial');
ylabel(' Neuron # ', 'FontSize',14,'FontName','Arial');
% caxis(cax);
colormap hot;
c = colorbar; 
ylabel(c, 'z-score','rotation', 270, 'FontSize',14,'FontName','Arial');
xlabel(' Time from lever press (seconds) ', 'FontSize',14,'FontName','Arial');
% xlim([-2 2]);

%%
clear

list = rdir('workspace*');

for ws = 1:length(list)
    clearvars -except list ws conc_hist
    disp(['analyzing neuron ' num2str(ws) ', ' list(ws).name(11:end-4)])
    load(list(ws).name)
    srate = 20000;
    spikes = V_f{1,1}.spikes;
    TTLaux = V_f{1,1}.TTLaux;
    clear V_f
    
    TTLaux = sortrows(TTLaux,2);                 % se ordenan por orden ascendente de tiempo de espera entre press-TTL
    TTLaux(:,6) = TTLaux(:,5) - TTLaux(:,2);   % columna 6 que tendra, en ms, el timestamp del lever press
    TTLaux = TTLaux';
    TTLaux(2:end,:) = TTLaux(2:end,:).*20; % deja todos los tiempos de TTLaux en puntos, ya que los timestamps de las espigas estan en puntos
    
    time_window = 1;                                   % tamanio total de la ventana del raster, en segundos
    tw_pts = time_window*srate;                        % time_window expresado en puntos
    
    % preallocating memory
    spikes_prev_press = nan(1,length(spikes));
    
    %  creacion del raster para todos los trials juntos, sorteados por tiempo de espera entre press-TTL
    
    for i = 1:length(TTLaux(1,:))
        
        aux_pre = spikes( spikes > TTLaux(6,i) - tw_pts*2 & spikes < TTLaux(6,i) - tw_pts );
        spikes_prev_press(1,length(find(~isnan(spikes_prev_press(1,:))))+1:length(find(~isnan(spikes_prev_press(1,:))))+length(aux_pre)) = aux_pre; % timestamps de la espiga en el raster PRESS

    end
    spikes_prev_press = spikes_prev_press(:,1:length(nonzeros(~isnan(spikes_prev_press(1,:))))); % elimina los nan
    clear aux_rxnt aux_press aux_ttl aux_release i    
    
    spks_autocorr(spikes_prev_press*1000/srate, ones(size(spikes_prev_press)))
    folder_dir = 'C:\Users\pflab\Desktop\análisis_SB32_SB33\copia_spks_HIPP\Stim2\sin SB12\figuras_autocorr';
    cd(folder_dir);
    fname = ['autocorr_' list(ws).name(11:end-4) '_t1'];
    print(gcf,'-dtiff',fname,'-r0')
    pause(.3)
    close
    pause(.2)
    cd ..
    
end

clear

list = rdir('workspace*');

for ws = 1:length(list)
    clearvars -except list ws conc_hist
    disp(['analyzing neuron ' num2str(ws) ', ' list(ws).name(11:end-4)])
    load(list(ws).name)
    srate = 20000;
    spikes = V_f{1,1}.spikes;
    TTLaux = V_f{1,1}.TTLaux;
    clear V_f
    
    TTLaux = sortrows(TTLaux,2);                 % se ordenan por orden ascendente de tiempo de espera entre press-TTL
    TTLaux(:,6) = TTLaux(:,5) - TTLaux(:,2);   % columna 6 que tendra, en ms, el timestamp del lever press
    TTLaux = TTLaux';
    TTLaux(2:end,:) = TTLaux(2:end,:).*20; % deja todos los tiempos de TTLaux en puntos, ya que los timestamps de las espigas estan en puntos
    
    time_window = 1;                                   % tamanio total de la ventana del raster, en segundos
    tw_pts = time_window*srate;                        % time_window expresado en puntos
    
    % preallocating memory
    spikes_prev_press = nan(1,length(spikes));
    
    %  creacion del raster para todos los trials juntos, sorteados por tiempo de espera entre press-TTL
    
    for i = 1:length(TTLaux(1,:))
        
        aux_pre = spikes( spikes > TTLaux(6,i) & spikes < TTLaux(6,i) + tw_pts );
        spikes_prev_press(1,length(find(~isnan(spikes_prev_press(1,:))))+1:length(find(~isnan(spikes_prev_press(1,:))))+length(aux_pre)) = aux_pre; % timestamps de la espiga en el raster PRESS

    end
    spikes_prev_press = spikes_prev_press(:,1:length(nonzeros(~isnan(spikes_prev_press(1,:))))); % elimina los nan
    clear aux_rxnt aux_press aux_ttl aux_release i    
    
    spks_autocorr(spikes_prev_press*1000/srate, ones(size(spikes_prev_press)))
    folder_dir = 'C:\Users\pflab\Desktop\análisis_SB32_SB33\copia_spks_HIPP\Stim2\sin SB12\figuras_autocorr';
    cd(folder_dir);
    fname = ['autocorr_' list(ws).name(11:end-4) '_t3'];
    print(gcf,'-dtiff',fname,'-r0')
    pause(.3)
    close
    pause(.2)
    cd ..
    
end