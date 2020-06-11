function neuron_evaluation_gui(spk_dir,ws_list,spk_srate,time_window,maxlag,bin)%, ws_n)
f = figure('Visible','off','Position',[1060,100,850,885],'color','w');
ws_n = 1;
% Construct the components.
hR    = uicontrol('Style','pushbutton',...
    'String','>','Position',[775,830,70,25],'Callback',{@rightbutton_Callback,ws_n});
hL    = uicontrol('Style','pushbutton',...
    'String','<','Position',[775,800,70,25],'Callback',{@leftbutton_Callback,ws_n});

hraster = axes('Units','pixels','Position',[80,550,680,300]);
hwform  = axes('Units','pixels','Position',[80,50,340,400]);
hacorr  = axes('Units','pixels','Position',[490,50,340,400]);

raster_data = cell(size(ws_list,1));
waveform_data = cell(size(ws_list,1));
acorr_data = cell(size(ws_list,1));
for ws = 1:size(ws_list,1)
    load([spk_dir char(ws_list(ws))]) % ***
    spikes = V_f{1,1}.spikes;
    TTL = V_f{1,1}.TTLaux;
    spikes = 1000*spikes/spk_srate;
    
    % raster data
    raster_data{ws} = rastermk(spikes,TTL(:,6),TTL(:,1),time_window);
    % waveform data
    waveform_data{ws} = V_f{1,1}.long_meanspk;
    % autocorrelation data
    [acorr_data{ws},eje] = corr_cruz(spikes,spikes,maxlag, bin);
    display(num2str(ws));
end
% ws_n = 1;

% plot the data of the first neuron
plot(hraster,(raster_data{ws_n,1}(1,:)-3000)/1000,raster_data{ws_n,1}(2,:),'sk','markerfacecolor','k','markersize',2)
%     title(ws_list(ws).name,'interpreter','none')
title(hraster,ws_list(ws_n),'interpreter','none','fontweight','demi') % ***
ylim(hraster,[1 max(raster_data{ws_n,1}(2,:))])
xlim(hraster,[-3 3])
xlabel(hraster,'time from stimulus onset (s)','fontsize',13,'fontweight','demi')
ylabel(hraster,'Trial #','fontsize',13,'fontweight','demi')
set(hraster,'fontweight','demi','fontsize',13,'ytick',max(raster_data{ws_n,1}(2,:)))

t = (1:length(waveform_data{ws_n,1}))*1000/spk_srate;
plot(hwform,t,waveform_data{ws_n,1},'k','linewidth',3)
xlim(hwform,[t(1) t(end)])
xlabel(hwform,'Time (ms)','fontsize',13,'fontweight','demi')
ylim(hwform,[-250 200])
ylabel(hwform,'Voltage (\muV)','fontsize',13,'fontweight','demi')
set(hwform,'fontweight','demi','fontsize',13)

bar(hacorr,eje,acorr_data{ws_n,1},'facecolor','k');
xlim(hacorr,[-maxlag maxlag])
xlabel(hacorr,'Time (ms)','fontsize',13,'fontweight','demi')
ylabel('spike counts','fontsize',13,'fontweight','demi')
set(hacorr,'fontweight','demi','fontsize',13,'box','off')

set(f,'Visible','on');

    function rightbutton_Callback(hObject,eventdata,x)
        
        ws_n = ws_n + 1;
        
        plot(hraster,(raster_data{ws_n,1}(1,:)-3000)/1000,raster_data{ws_n,1}(2,:),'sk','markerfacecolor','k','markersize',2)
        %     title(ws_list(ws).name,'interpreter','none')
        title(hraster,ws_list(ws_n),'interpreter','none','fontweight','demi') % ***
        ylim(hraster,[1 max(raster_data{ws_n,1}(2,:))])
        xlim(hraster,[-3 3])
        xlabel(hraster,'time from stimulus onset (s)','fontsize',13,'fontweight','demi')
        ylabel(hraster,'Trial #','fontsize',13,'fontweight','demi')
        set(hraster,'fontweight','demi','fontsize',13,'ytick',max(raster_data{ws_n,1}(2,:)))
        
        t = (1:length(waveform_data{ws_n,1}))*1000/spk_srate;
        plot(hwform,t,waveform_data{ws_n,1},'k','linewidth',3)
        xlim(hwform,[t(1) t(end)])
        xlabel(hwform,'Time (ms)','fontsize',13,'fontweight','demi')
        ylim(hwform,[-250 200])
        ylabel(hwform,'Voltage (\muV)','fontsize',13,'fontweight','demi')
        set(hwform,'fontweight','demi','fontsize',13)
        
        bar(hacorr,eje,acorr_data{ws_n,1},'facecolor','k');
        xlim(hacorr,[-maxlag maxlag])
        xlabel(hacorr,'Time (ms)','fontsize',13,'fontweight','demi')
        ylabel('spike counts','fontsize',13,'fontweight','demi')
        set(hacorr,'fontweight','demi','fontsize',13,'box','off')
        
        display(['n = ' num2str(ws_n)])
    end

    function leftbutton_Callback(hObject,eventdata,x)
        
        ws_n = ws_n - 1;
        plot(hraster,(raster_data{ws_n,1}(1,:)-3000)/1000,raster_data{ws_n,1}(2,:),'sk','markerfacecolor','k','markersize',2)
        %     title(ws_list(ws).name,'interpreter','none')
        title(hraster,ws_list(ws_n),'interpreter','none','fontweight','demi') % ***
        ylim(hraster,[1 max(raster_data{ws_n,1}(2,:))])
        xlim(hraster,[-3 3])
        xlabel(hraster,'time from stimulus onset (s)','fontsize',13,'fontweight','demi')
        ylabel(hraster,'Trial #','fontsize',13,'fontweight','demi')
        set(hraster,'fontweight','demi','fontsize',13,'ytick',max(raster_data{ws_n,1}(2,:)))
        
        t = (1:length(waveform_data{ws_n,1}))*1000/spk_srate;
        plot(hwform,t,waveform_data{ws_n,1},'k','linewidth',3)
        xlim(hwform,[t(1) t(end)])
        xlabel(hwform,'Time (ms)','fontsize',13,'fontweight','demi')
        ylim(hwform,[-250 200])
        ylabel(hwform,'Voltage (\muV)','fontsize',13,'fontweight','demi')
        set(hwform,'fontweight','demi','fontsize',13)
        
        bar(hacorr,eje,acorr_data{ws_n,1},'facecolor','k');
        xlim(hacorr,[-maxlag maxlag])
        xlabel(hacorr,'Time (ms)','fontsize',13,'fontweight','demi')
        ylabel('spike counts','fontsize',13,'fontweight','demi')
        set(hacorr,'fontweight','demi','fontsize',13,'box','off')
        
        display(['n = ' num2str(ws_n)])
    end

end