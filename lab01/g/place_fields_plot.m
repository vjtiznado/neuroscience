%%
clear
close all
cd('E:\Gonzalo')
load('spat_features.mat')
result_analysis = result_place_cell;
for k = 220:size(result_analysis,1)
    cd(result_analysis.Var11{k,1}) % cambiar parta place cells o no place cells
    load('vertices_S.mat')
    load(result_analysis.Var1{k,1}) % cambiar parta place cells o no place cells
    % raw plot
    figure;clf;
    subplot(2,5,1);cla;
    plot(txy(:,2),txy(:,3),'-','color',[.6 .6 .6],'linewidth',2.5)
    hold on
    plot(spikes_xy(:,1),spikes_xy(:,2),'r.','markersize',25)
    axis ij
    axis square
    axis off
    
    axis square
    title('raw plot','fontsize',10)
    xlim([min(vertices.maze(:,1))-10 max(vertices.maze(:,1))+10]);
    ylim([min(vertices.maze(:,2))-10 max(vertices.maze(:,2))+10]);
    set(gcf,'color','w')
    
    lgd = legend(result_analysis.Var6{k,1}(1:end - 4),'Location','north');
    set(lgd,'FontSize',12);
    
    % smoothed firing rate map
    subplot(2,5,2);cla;
    pcolor(hist_xy{1},hist_xy{2},sfrmap')
    colormap parula
    colorbar
    caxis([0 max(max(sfrmap))])
    hold on
    axis ij
    axis square
    axis off
    shading flat
    title('smoothed firing rate map','fontsize',10)
    xlim([min(vertices.maze(:,1))-10 max(vertices.maze(:,1))+10]);
    ylim([min(vertices.maze(:,2))-10 max(vertices.maze(:,2))+10]);
    set(gcf,'color','w')
    
    %OCUPANCY MAP
    subplot(2,5,3);cla;
    pcolor(hist_xy{1},hist_xy{2},ocmap')
    colormap parula
    colorbar
    caxis([0 max(max(ocmap))])
    hold on
    axis ij
    axis square
    axis off
    shading flat
    
    title('occupancy map','fontsize',10)
    xlim([min(vertices.maze(:,1))-10 max(vertices.maze(:,1))+10]);
    ylim([min(vertices.maze(:,2))-10 max(vertices.maze(:,2))+10]);
    set(gcf,'color','w')
    
    %FIRING MAP
    
    subplot(2,5,4);cla;
    pcolor(hist_xy{1},hist_xy{2},fmap')
    colormap parula
    colorbar
    caxis([0 max(max(fmap))])
    hold on
    axis ij
    axis square
    axis off
    shading flat
    title('firing map','fontsize',10)
    xlim([min(vertices.maze(:,1))-10 max(vertices.maze(:,1))+10]);
    ylim([min(vertices.maze(:,2))-10 max(vertices.maze(:,2))+10]);
    set(gcf,'color','w')
    
    %RAW FIRING RATE MAP
    subplot(2,5,5);cla;
    pcolor(hist_xy{1},hist_xy{2},frmap')
    colormap parula
    colorbar
    caxis([0 max(max(frmap))])
    hold on
    axis ij
    axis off
    axis square
    shading flat
    title('raw firing rate map','fontsize',10)
    xlim([min(vertices.maze(:,1))-10 max(vertices.maze(:,1))+10]);
    ylim([min(vertices.maze(:,2))-10 max(vertices.maze(:,2))+10]);
    set(gcf,'color','w')
    
    clearvars -except k result result_no_place_cell result_place_cell result_analysis
    load('vertices_T.mat')
    load(result_analysis.Var6{k,1}) % cambiar parta place cells o no place cells
    
    % raw plot
    subplot(2,5,6);cla;
    plot(txy(:,2),txy(:,3),'-','color',[.6 .6 .6],'linewidth',2.5)
    hold on
    plot(spikes_xy(:,1),spikes_xy(:,2),'r.','markersize',25)
    axis ij
    axis square
    axis off
    
    axis square
    title('raw plot','fontsize',10)
    xlim([min(vertices.maze(:,1))-10 max(vertices.maze(:,1))+10]);
    ylim([min(vertices.maze(:,2))-10 max(vertices.maze(:,2))+10]);
    set(gcf,'color','w')
    
    % smoothed firing rate map
    subplot(2,5,7);cla;
    pcolor(hist_xy{1},hist_xy{2},sfrmap')
    colormap parula
    colorbar
    caxis([0 max(max(sfrmap))])
    hold on
    axis ij
    axis square
    axis off
    shading flat
    title('smoothed firing rate map','fontsize',10)
    xlim([min(vertices.maze(:,1))-10 max(vertices.maze(:,1))+10]);
    ylim([min(vertices.maze(:,2))-10 max(vertices.maze(:,2))+10]);
    set(gcf,'color','w')
    
    %OCUPANCY MAP
    subplot(2,5,8);cla;
    pcolor(hist_xy{1},hist_xy{2},ocmap')
    colormap parula
    colorbar
    caxis([0 max(max(ocmap))])
    hold on
    axis ij
    axis square
    axis off
    shading flat
    title('occupancy map','fontsize',10)
    xlim([min(vertices.maze(:,1))-10 max(vertices.maze(:,1))+10]);
    ylim([min(vertices.maze(:,2))-10 max(vertices.maze(:,2))+10]);
    set(gcf,'color','w')
    
    %FIRING MAP
    subplot(2,5,9);cla;
    pcolor(hist_xy{1},hist_xy{2},fmap')
    colormap parula
    colorbar
    caxis([0 max(max(fmap))])
    hold on
    axis ij
    axis square
    axis off
    shading flat
    title('firing map','fontsize',10)
    xlim([min(vertices.maze(:,1))-10 max(vertices.maze(:,1))+10]);
    ylim([min(vertices.maze(:,2))-10 max(vertices.maze(:,2))+10]);
    set(gcf,'color','w')
    
    %RAW FIRING RATE MAP
    subplot(2,5,10);cla;
    pcolor(hist_xy{1},hist_xy{2},frmap')
    colormap parula
    colorbar
    caxis([0 max(max(frmap))])
    hold on
    axis ij
    axis off
    axis square
    shading flat
    title('raw firing rate map','fontsize',10)
    xlim([min(vertices.maze(:,1))-10 max(vertices.maze(:,1))+10]);
    ylim([min(vertices.maze(:,2))-10 max(vertices.maze(:,2))+10]);
    set(gcf,'color','w')
    
    pause
end