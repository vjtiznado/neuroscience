%%
spk_dir = 'C:\Users\pflab\Dropbox\SB\RESULTADOS\SPIKES\NEURONS\Protocolo 2\';
ws_list = dir([spk_dir 'workspace*']);

real_spk_logical = nan(size(ws_list,1),1);
for ws = 1:size(ws_list,1)
    load([spk_dir ws_list(ws).name])
    spikes = V_f{1,1}.spikes;
    TTL = V_f{1,1}.TTLaux;
    frate = V_f{1,1}.firing_rate;
    waveform = V_f{1,1}.long_meanspk;
    spk_srate = 20000;
    spikes = 1000*spikes/spk_srate;
    time_window = 6000;
    raster_all = rastermk(spikes,TTL(:,6),TTL(:,1),time_window);

    subplot(2,1,1)
    plot((raster_all(1,:)-3000)/1000,raster_all(2,:),'sk','markerfacecolor','k','markersize',2)
    title(ws_list(ws).name,'interpreter','none')
    ylim([1 max(raster_all(2,:))])
    xlim([-3 3])
    
    subplot(2,2,3)
    t = (1:length(waveform))*1000/spk_srate;
    plot(t,waveform,'k','linewidth',2)
    xlim([t(1) t(end)])
    
    set(gcf,'color','w')
    real_spk_logical(ws,1) = input(['ws = ' num2str(ws) ', real cell? ']);
    
end

real_spk_logical = logical(real_spk_logical);
display('ready')

