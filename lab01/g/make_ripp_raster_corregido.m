%%
clear;clc
ripp_dir = 'C:\Users\neuro\Dropbox\SB\RESULTADOS\RIPPLES\';
bin = 100;
load([ripp_dir 'ripples_raster_SD_3_' num2str(bin) 'ms.mat']) % aqui pon al que le quieras crear el corregido
ripp_raster_c = ripp_raster;
load([ripp_dir 'ripples_raster_SD_3_300ms_corregido.mat'],'ripp_raster') % este es fijo
ripp_raster_c2 = ripp_raster_c;

pos_v = nan(size(ripp_raster.info(:,2),1),2);
for g = 1:size(ripp_raster.info(:,2),1)
    log_find = strfind(ripp_raster_c2.info(:,2),char(ripp_raster.info(g,2)));
    try
        pos_v(g,1) = find(~cellfun(@isempty,log_find));
        pos_v(g,2) = 1;
    catch
        pos_v(g,1) = g;
        pos_v(g,2) = 0;
        disp('no')
    end
end

%%

for v = 1:size(pos_v,1)
    if pos_v(v,2)==1
        ripp_raster_c.press(v,:) = ripp_raster_c.press(pos_v(v),:);
        ripp_raster_c.stimo(v,:) = ripp_raster_c.stimo(pos_v(v),:);
        ripp_raster_c.levre(v,:) = ripp_raster_c.levre(pos_v(v),:);
        ripp_raster_c.info(v,:) = ripp_raster_c.info(pos_v(v),:);
    elseif pos_v(v,2)==0
        ripp_raster_c.press(v,:) = ripp_raster.press(pos_v(v),:);
        ripp_raster_c.stimo(v,:) = ripp_raster.stimo(pos_v(v),:);
        ripp_raster_c.levre(v,:) = ripp_raster.levre(pos_v(v),:);
        ripp_raster_c.info(v,:) = ripp_raster.info(pos_v(v),:);
    end
    
end
ripp_raster_c.press((size(pos_v,1)+1):end,:) = [];
ripp_raster_c.stimo((size(pos_v,1)+1):end,:) = [];
ripp_raster_c.levre((size(pos_v,1)+1):end,:) = [];
ripp_raster_c.info((size(pos_v,1)+1):end,:) = [];
%%
ripp_raster = ripp_raster_c;
sd_n = 3;
save([ripp_dir 'ripples_raster_SD_' num2str(sd_n) '_' num2str(bin) 'ms_corregido.mat'],'ripp_raster','time_window','tw_units','centros','eje','-v7.3')