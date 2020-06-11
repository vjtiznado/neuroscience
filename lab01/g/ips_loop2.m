%% run this one time
clear;clc;
% setting the location of the recording session you want to analyze
data_dir = 'E:\Gonzalo\Exp GV11 - GV12 Mayo 2018\GV12\rec_03_OPR2\rec_AM\';
data_dir_hs = strfind(data_dir,'\');
cd(data_dir)
% ifidtracker = true;
ifidtracker = false;

if ifidtracker == true
    tsp_dir = dir([data_dir '*.tsp']);
    trajectories_dir = dir([data_dir 'traj*.mat']);
    spikes_dir = dir([data_dir 'spk*.mat']);
    meta_dir = dir([data_dir '*.meta']);
    
    % importing data of all the spikes, tsp and meta files
    spikes_all = arrayfun(@(L) struct2array(load([data_dir spikes_dir(L).name],'spikes')),1:size(spikes_dir,1),'uniformoutput',false)';
    spkwfs_all = arrayfun(@(L) struct2array(load([data_dir spikes_dir(L).name],'mean_spk')),1:size(spikes_dir,1),'uniformoutput',false)';
    trajectories_all = arrayfun(@(L) squeeze(struct2array(load([data_dir trajectories_dir(L).name],'trajectories'))),1:size(trajectories_dir,1),'uniformoutput',false)';
    tsp_all = arrayfun(@(L) importdata([data_dir tsp_dir(L).name]),1:size(tsp_dir,1),'uniformoutput',false)';
    if strcmp(data_dir(data_dir_hs(end-3):end),'\GV12\rec_02_OPR1\rec_AM\')
        tsp_all{1,1}(tsp_all{1,1}(:,1)<1389095) = [];
        tsp_all{3,1} = tsp_all{3,1}(:,1);
    end
    meta_all = arrayfun(@(L) importdata([data_dir meta_dir(L).name],'\t'),1:size(meta_dir,1),'uniformoutput',false)';
    ts_ini = arrayfun(@(m) strsplit(meta_all{m,1}{14,1},'='),1:size(meta_all,1),'uniformoutput',false)';
    ts_ini = cell2mat(arrayfun(@(m) str2double(ts_ini{m,1}{1,2}),1:size(ts_ini,1),'uniformoutput',false)');
    
    try
        tsp_all{1,1}(:,[6 7]) = trajectories_all{1,1};
        tsp_all{2,1}(:,[6 7]) = nan;
        tsp_all{3,1}(:,[6 7]) = trajectories_all{2,1};
    catch
        sizetsp1 = size(tsp_all{1,1},1);
        sizetsp3 = size(tsp_all{3,1},1);
        sizetraj1 = size(trajectories_all{1,1},1);
        sizetraj2 = size(trajectories_all{2,1},1);
        
        diff1 = sizetsp1 - sizetraj1;
        diff2 = sizetsp3 - sizetraj2;
        
        tsp_all{1,1}(1:diff1,:) = [];
        tsp_all{3,1}(1:diff2,:) = [];
        
        tsp_all{1,1}(:,[6 7]) = trajectories_all{1,1};
        tsp_all{2,1}(:,[6 7]) = nan;
        tsp_all{3,1}(:,[6 7]) = trajectories_all{2,1};
    end
    
elseif ifidtracker == false
    % list of the files of the spikes, meta files, and tsp
    tsp_dir = dir([data_dir '*.tsp']);
    spikes_dir = dir([data_dir 'spk*.mat']);
    meta_dir = dir([data_dir '*.meta']);
    % load([data_dir 'ttr_conc_order.mat']);
    
    % importing data of all the spikes, tsp and meta files
    spikes_all = arrayfun(@(L) struct2array(load([data_dir spikes_dir(L).name],'spikes')),1:size(spikes_dir,1),'uniformoutput',false)';
    spkwfs_all = arrayfun(@(L) struct2array(load([data_dir spikes_dir(L).name],'mean_spk')),1:size(spikes_dir,1),'uniformoutput',false)';
    tsp_all = arrayfun(@(L) importdata([data_dir tsp_dir(L).name]),1:size(tsp_dir,1),'uniformoutput',false)';
    meta_all = arrayfun(@(L) importdata([data_dir meta_dir(L).name],'\t'),1:size(meta_dir,1),'uniformoutput',false)';
    ts_ini = arrayfun(@(m) strsplit(meta_all{m,1}{14,1},'='),1:size(meta_all,1),'uniformoutput',false)';
    ts_ini = cell2mat(arrayfun(@(m) str2double(ts_ini{m,1}{1,2}),1:size(ts_ini,1),'uniformoutput',false)');
    
    % tsp_all = {tsp_all{1,1};tsp_all{3,1}};
    % meta_all = {meta_all{1,1};meta_all{3,1}};
    % ts_ini = [ts_ini(1);ts_ini(3)];
    % ts_fin = arrayfun(@(m) strsplit(meta_all{m,1}{14,1},'='),1:size(meta_all,1),'uniformoutput',false)';
end

if strcmp(data_dir(data_dir_hs(end-3):end),'\GV11\rec_02_OPR1\rec_AM\')
    circle = false;
    % sample
    xv{1,1}(1) = 262; yv{1,1}(1) = 660;
    xv{1,1}(2) = 262; yv{1,1}(2) = 120;
    xv{1,1}(3) = 836; yv{1,1}(3) = 120;
    xv{1,1}(4) = 836; yv{1,1}(4) = 660;
    xv{1,1}(5) = xv{1,1}(1); yv{1,1}(5) = yv{1,1}(1);
    
    obj1_x{1,1}(1) = 367; obj1_y{1,1}(1) = 176;
    obj1_x{1,1}(2) = 439; obj1_y{1,1}(2) = 226;
    obj1_x{1,1}(3) = 440; obj1_y{1,1}(3) = 289;
    obj1_x{1,1}(4) = 377; obj1_y{1,1}(4) = 289;
    obj1_x{1,1}(5) = obj1_x{1,1}(1); obj1_y{1,1}(5) = obj1_y{1,1}(1);
    
    obj2_x{1,1}(1) = 365; obj2_y{1,1}(1) = 481;
    obj2_x{1,1}(2) = 430; obj2_y{1,1}(2) = 484;
    obj2_x{1,1}(3) = 433; obj2_y{1,1}(3) = 555;
    obj2_x{1,1}(4) = 360; obj2_y{1,1}(4) = 557;
    obj2_x{1,1}(5) = obj2_x{1,1}(1); obj2_y{1,1}(5) = obj2_y{1,1}(1);
    
    
    % test
    xv{3,1}(1) = 256; yv{3,1}(1) = 676;
    xv{3,1}(2) = 280; yv{3,1}(2) = 122;
    xv{3,1}(3) = 823; yv{3,1}(3) = 134;
    xv{3,1}(4) = 826; yv{3,1}(4) = 683;
    xv{3,1}(5) = xv{3,1}(1); yv{3,1}(5) = yv{3,1}(1);
    
    obj1_x{3,1}(1) = 365; obj1_y{3,1}(1) = 497;
    obj1_x{3,1}(2) = 428; obj1_y{3,1}(2) = 497;
    obj1_x{3,1}(3) = 433; obj1_y{3,1}(3) = 567;
    obj1_x{3,1}(4) = 365; obj1_y{3,1}(4) = 568;
    obj1_x{3,1}(5) = obj1_x{3,1}(1); obj1_y{3,1}(5) = obj1_y{3,1}(1);
    
    obj2_x{3,1}(1) = 646; obj2_y{3,1}(1) = 231;
    obj2_x{3,1}(2) = 646; obj2_y{3,1}(2) = 291;
    obj2_x{3,1}(3) = 711; obj2_y{3,1}(3) = 298;
    obj2_x{3,1}(4) = 777; obj2_y{3,1}(4) = 183;
    obj2_x{3,1}(5) = obj2_x{3,1}(1); obj2_y{3,1}(5) = obj2_y{3,1}(1);
    
    
elseif strcmp(data_dir(data_dir_hs(end-3):end),'\GV11\rec_02_OPR1\rec_AM\')
    
elseif strcmp(data_dir(data_dir_hs(end-3):end),'\GV11\rec_03_OPR2\rec_AM\')
    n_sides = 200;
    % sample
    radius = 285;
    xcenter = 640;
    ycenter = 410;
    
    t = linspace(0,1,n_sides + 1);
    xv{1,1} = cos(t.*2*pi)*radius + xcenter;
    yv{1,1} = sin(t.*2*pi)*radius + ycenter;
%     hold on;
%      plot(xv{1,1},yv{1,1},'b')
    
    obj1_x{1,1}(1) = 502; obj1_y{1,1}(1) = 233;
    obj1_x{1,1}(2) = 553; obj1_y{1,1}(2) = 286;
    obj1_x{1,1}(3) = 521; obj1_y{1,1}(3) = 322;
    obj1_x{1,1}(4) = 485; obj1_y{1,1}(4) = 293;
    obj1_x{1,1}(5) = obj1_x{1,1}(1); obj1_y{1,1}(5) = obj1_y{1,1}(1);
    
    obj2_x{1,1}(1) = 464; obj2_y{1,1}(1) = 493;
    obj2_x{1,1}(2) = 499; obj2_y{1,1}(2) = 529;
    obj2_x{1,1}(3) = 534; obj2_y{1,1}(3) = 488;
    obj2_x{1,1}(4) = 496; obj2_y{1,1}(4) = 456;
    obj2_x{1,1}(5) = obj2_x{1,1}(1); obj2_y{1,1}(5) = obj2_y{1,1}(1);
    
    % test
    radius = 285;
    xcenter = 635;
    ycenter = 400;
    
    t = linspace(0,1,n_sides + 1);
    xv{3,1} = cos(t.*2*pi)*radius + xcenter;
    yv{3,1} = sin(t.*2*pi)*radius + ycenter;
%     hold on; 
%     plot(xv{3,1},yv{3,1},'b') 


    obj1_x{3,1}(1) = 453; obj1_y{3,1}(1) = 480;
    obj1_x{3,1}(2) = 488; obj1_y{3,1}(2) = 521;
    obj1_x{3,1}(3) = 528; obj1_y{3,1}(3) = 481;
    obj1_x{3,1}(4) = 483; obj1_y{3,1}(4) = 447;
    obj1_x{3,1}(5) = obj1_x{3,1}(1); obj1_y{3,1}(5) = obj1_y{3,1}(1);
    
    obj2_x{3,1}(1) = 814; obj2_y{3,1}(1) = 257;
    obj2_x{3,1}(2) = 740; obj2_y{3,1}(2) = 271;
    obj2_x{3,1}(3) = 742; obj2_y{3,1}(3) = 324;
    obj2_x{3,1}(4) = 796; obj2_y{3,1}(4) = 324;
    obj2_x{3,1}(5) = obj2_x{3,1}(1); obj2_y{3,1}(5) = obj2_y{3,1}(1);

elseif strcmp(data_dir(data_dir_hs(end-3):end),'\GV11\rec_04_OPR3\rec_AM\')
    n_sides = 200;
    % sample
    radius = 285;
    xcenter = 635;
    ycenter = 330;
    
    t = linspace(0,1,n_sides + 1);
    xv{1,1} = cos(t.*2*pi)*radius + xcenter;
    yv{1,1} = sin(t.*2*pi)*radius + ycenter;
%     hold on;
%      plot(xv{1,1},yv{1,1},'r')

    obj1_x{1,1}(1) = 491; obj1_y{1,1}(1) = 195;
    obj1_x{1,1}(2) = 558; obj1_y{1,1}(2) = 200;
    obj1_x{1,1}(3) = 552; obj1_y{1,1}(3) = 272;
    obj1_x{1,1}(4) = 485; obj1_y{1,1}(4) = 265;
    obj1_x{1,1}(5) = obj1_x{1,1}(1); obj1_y{1,1}(5) = obj1_y{1,1}(1);
    
    obj2_x{1,1}(1) = 481; obj2_y{1,1}(1) = 399;
    obj2_x{1,1}(2) = 548; obj2_y{1,1}(2) = 403;
    obj2_x{1,1}(3) = 545; obj2_y{1,1}(3) = 473;
    obj2_x{1,1}(4) = 480; obj2_y{1,1}(4) = 475;
    obj2_x{1,1}(5) = obj2_x{1,1}(1); obj2_y{1,1}(5) = obj2_y{1,1}(1);
    
    % test
    radius = 285;
    xcenter = 640;
    ycenter = 320;
    
    t = linspace(0,1,n_sides + 1);
    xv{3,1} = cos(t.*2*pi)*radius + xcenter;
    yv{3,1} = sin(t.*2*pi)*radius + ycenter;
%     hold on; 
%     plot(xv{3,1},yv{3,1},'r') 


    obj1_x{3,1}(1) = 464; obj1_y{3,1}(1) = 205;
    obj1_x{3,1}(2) = 534; obj1_y{3,1}(2) = 211;
    obj1_x{3,1}(3) = 531; obj1_y{3,1}(3) = 279;
    obj1_x{3,1}(4) = 463; obj1_y{3,1}(4) = 277;
    obj1_x{3,1}(5) = obj1_x{3,1}(1); obj1_y{3,1}(5) = obj1_y{3,1}(1);
    
    obj2_x{3,1}(1) = 662; obj2_y{3,1}(1) = 423;
    obj2_x{3,1}(2) = 660; obj2_y{3,1}(2) = 488;
    obj2_x{3,1}(3) = 734; obj2_y{3,1}(3) = 511;
    obj2_x{3,1}(4) = 734; obj2_y{3,1}(4) = 425;
    obj2_x{3,1}(5) = obj2_x{3,1}(1); obj2_y{3,1}(5) = obj2_y{3,1}(1);


elseif strcmp(data_dir(data_dir_hs(end-3):end),'\GV12\rec_02_OPR1\rec_AM\')
   circle = false;
    % sample
    xv{1,1}(1) = 294; yv{1,1}(1) = 115;
    xv{1,1}(2) = 288; yv{1,1}(2) = 657;
    xv{1,1}(3) = 852; yv{1,1}(3) = 662;
    xv{1,1}(4) = 829; yv{1,1}(4) = 117;
    xv{1,1}(5) = xv{1,1}(1); yv{1,1}(5) = yv{1,1}(1);
    
    obj1_x{1,1}(1) = 404; obj1_y{1,1}(1) = 196;
    obj1_x{1,1}(2) = 396; obj1_y{1,1}(2) = 289;
    obj1_x{1,1}(3) = 461; obj1_y{1,1}(3) = 291;
    obj1_x{1,1}(4) = 461; obj1_y{1,1}(4) = 224;
    obj1_x{1,1}(5) = obj1_x{1,1}(1); obj1_y{1,1}(5) = obj1_y{1,1}(1);
    
    obj2_x{1,1}(1) = 390; obj2_y{1,1}(1) = 497;
    obj2_x{1,1}(2) = 459; obj2_y{1,1}(2) = 500;
    obj2_x{1,1}(3) = 461; obj2_y{1,1}(3) = 570;
    obj2_x{1,1}(4) = 394; obj2_y{1,1}(4) = 572;
    obj2_x{1,1}(5) = obj2_x{1,1}(1); obj2_y{1,1}(5) = obj2_y{1,1}(1);
    
    
    % test
    xv{3,1}(1) = 264; yv{3,1}(1) = 100;
    xv{3,1}(2) = 260; yv{3,1}(2) = 660;
    xv{3,1}(3) = 844; yv{3,1}(3) = 662;
    xv{3,1}(4) = 835; yv{3,1}(4) = 113;
    xv{3,1}(5) = xv{3,1}(1); yv{3,1}(5) = yv{3,1}(1);
    
    obj1_x{3,1}(1) = 370; obj1_y{3,1}(1) = 481;
    obj1_x{3,1}(2) = 437; obj1_y{3,1}(2) = 489;
    obj1_x{3,1}(3) = 445; obj1_y{3,1}(3) = 558;
    obj1_x{3,1}(4) = 368; obj1_y{3,1}(4) = 560;
    obj1_x{3,1}(5) = obj1_x{3,1}(1); obj1_y{3,1}(5) = obj1_y{3,1}(1);
    
    obj2_x{3,1}(1) = 650; obj2_y{3,1}(1) = 269;
    obj2_x{3,1}(2) = 715; obj2_y{3,1}(2) = 269;
    obj2_x{3,1}(3) = 734; obj2_y{3,1}(3) = 176;
    obj2_x{3,1}(4) = 652; obj2_y{3,1}(4) = 208;
    obj2_x{3,1}(5) = obj2_x{3,1}(1); obj2_y{3,1}(5) = obj2_y{3,1}(1);
    

elseif strcmp(data_dir(data_dir_hs(end-3):end),'\GV12\rec_03_OPR2\rec_AM\')
    n_sides = 200;
    % sample
    radius = 285;
    xcenter = 625;
    ycenter = 435;
    
    t = linspace(0,1,n_sides + 1);
    xv{1,1} = cos(t.*2*pi)*radius + xcenter;
    yv{1,1} = sin(t.*2*pi)*radius + ycenter;
%     hold on;
%      plot(xv{1,1},yv{1,1},'b')

    obj1_x{1,1}(1) = 475; obj1_y{1,1}(1) = 280;
    obj1_x{1,1}(2) = 526; obj1_y{1,1}(2) = 326;
    obj1_x{1,1}(3) = 492; obj1_y{1,1}(3) = 364;
    obj1_x{1,1}(4) = 453; obj1_y{1,1}(4) = 323;
    obj1_x{1,1}(5) = obj1_x{1,1}(1); obj1_y{1,1}(5) = obj1_y{1,1}(1);
    
    obj2_x{1,1}(1) = 473; obj2_y{1,1}(1) = 482;
    obj2_x{1,1}(2) = 517; obj2_y{1,1}(2) = 520;
    obj2_x{1,1}(3) = 476; obj2_y{1,1}(3) = 552;
    obj2_x{1,1}(4) = 440; obj2_y{1,1}(4) = 516;
    obj2_x{1,1}(5) = obj2_x{1,1}(1); obj2_y{1,1}(5) = obj2_y{1,1}(1);
    
    % test
    radius = 285;
    xcenter = 630;
    ycenter = 430;
    
    t = linspace(0,1,n_sides + 1);
    xv{3,1} = cos(t.*2*pi)*radius + xcenter;
    yv{3,1} = sin(t.*2*pi)*radius + ycenter;
%     hold on; 
%     plot(xv{3,1},yv{3,1},'r') 


    obj1_x{3,1}(1) = 821; obj1_y{3,1}(1) = 285;
    obj1_x{3,1}(2) = 796; obj1_y{3,1}(2) = 354;
    obj1_x{3,1}(3) = 735; obj1_y{3,1}(3) = 340;
    obj1_x{3,1}(4) = 742; obj1_y{3,1}(4) = 301;
    obj1_x{3,1}(5) = obj1_x{3,1}(1); obj1_y{3,1}(5) = obj1_y{3,1}(1);
    
    obj2_x{3,1}(1) = 487; obj2_y{3,1}(1) = 480;
    obj2_x{3,1}(2) = 532; obj2_y{3,1}(2) = 516;
    obj2_x{3,1}(3) = 490; obj2_y{3,1}(3) = 555;
    obj2_x{3,1}(4) = 449; obj2_y{3,1}(4) = 518;
    obj2_x{3,1}(5) = obj2_x{3,1}(1); obj2_y{3,1}(5) = obj2_y{3,1}(1);
    
    
    
    
    
end

%% then, run rhis
clc

def_caxis = true;
clims{1,1} = [0 5]; % plot sample
clims{1,3} = [0 5]; % plot test
ips_table = table(cell(size(spikes_dir,1),1),nan(size(spikes_dir,1),1),nan(size(spikes_dir,1),1),'variablenames',{'neuron_id','ips_sample','ips_test'});
sparsity_table = table(cell(size(spikes_dir,1),1),nan(size(spikes_dir,1),1),nan(size(spikes_dir,1),1),'variablenames',{'neuron_id','sparsity_sample','sparsity_test'});

for s = 1:size(spikes_dir,1)
    ips_table.neuron_id{s,1} = spikes_dir(s).name;
    sparsity_table.neuron_id{s,1} = spikes_dir(s).name;
    for m = 1:2:size(tsp_all,1)
        clear X Y Xpos Ypos xq yq spikes
        if size(tsp_all{m,1},2) == 7
            try
            if ifidtracker == false
                tsp_all{m,1}(tsp_all{m,1}(:,6) == -1,[6 7]) = nan;
                %         tsp_all{m,1}(tsp_all{m,1}(:,6)<350,[6 7]) = nan;
                %         tsp_all{m,1}(tsp_all{m,1}(:,7)>700,[6 7]) = nan;
                %         clearvars -except xy_time
                
                ct = tsp_all{m,1}(:,[6 7]);
                ct(ct(:,1) == -1,:) = nan;
                % ctdiff = find(abs([0;diff(ct(:,1))])>65);
                %             if circle
                %                 in = ((ct(:,1)-xcenter).^2+(ct(:,2)-ycenter).^2<=Rcircle^2);
                %                 ct2 = ct;
                %                 ct2(in,:) = nan;
                %             else
                in = inpolygon(ct(:,1),ct(:,2),xv{m,1},yv{m,1});
                in_o1 = inpolygon(ct(:,1),ct(:,2),obj1_x{m,1},obj1_y{m,1});
                in_o2 = inpolygon(ct(:,1),ct(:,2),obj2_x{m,1},obj2_y{m,1});
                ct2 = ct;
                ct2(~in,:) = nan;
                %             end
                ct2(in_o1,:) = nan;
                ct2(in_o2,:) = nan;
                t = tsp_all{m,1}(:,1);
                if isnan(ct2(end,1)) && ~isnan(ct2(1,1))
                    nonan = find(~isnan(ct2(:,1)));
                    ct2(nonan(end)+1:end,:) = [];
                    t(nonan(end)+1:end,:) = [];
                elseif isnan(ct2(end,1)) && isnan(ct2(1,1))
                    nonan = find(~isnan(ct2(:,1)));
                    ct2(1:nonan(1)-1,:) = [];
                    t(1:nonan(1)-1,:) = [];
                    nonan = find(~isnan(ct2(:,1)));
                    ct2(nonan(end)+1:end,:) = [];
                    t(nonan(end)+1:end,:) = [];
                end
                xq = interp1(find(~isnan(ct2(:,1))),ct2(~isnan(ct2(:,1)),1),1:length(ct2),'pchip')';
                yq = interp1(find(~isnan(ct2(:,2))),ct2(~isnan(ct2(:,2)),2),1:length(ct2),'pchip')';
                
                
                
                % X and Y coordinates of the location of the animal, and the timestamps of each (X,Y) detection
                %                 X = tsp_all{m,1}(:,6);
                %                 Y = tsp_all{m,1}(:,7);
                %                 t = tsp_all{m,1}(:,1);
                %
                %                 Xq = interp1(find(~isnan(X)),X(~isnan(X)),1:length(X),'nearest')';
                %                 Yq = interp1(find(~isnan(Y)),Y(~isnan(Y)),1:length(Y),'nearest')';
            else
                xq = tsp_all{m,1}(:,6);
                yq = tsp_all{m,1}(:,7);
                t = tsp_all{m,1}(:,1);
            end
            
            X = xq;
            Y = yq;
            
            % spikes timestamps processing
            rec_step = 360000000;
            spikes_srate = 20000;
            if strcmp(data_dir(data_dir_hs(end-3):end),'\GV12\rec_02_OPR1\rec_AM\') && m == 3
                m = 2;
                spikes = spikes_all{s,1}(spikes_all{s,1} > rec_step*(m-1) & spikes_all{s,1} < rec_step*m,1);
                spikes = spikes - rec_step*(m-1);
                m = 3;
            else
                spikes = spikes_all{s,1}(spikes_all{s,1} > rec_step*(m-1) & spikes_all{s,1} < rec_step*m,1);
                spikes = spikes - rec_step*(m-1);
            end
            spikes = (spikes/spikes_srate)*1000; % to ms
            spikes(spikes>600000) = []; % standarized recording lenght
            spikes = spikes + ts_ini(m,1);
            
            tstart = t(1);
            tend = t(end);
            
            % looking for the spikes firing during the exploration of the maze
            
            S2 = find(spikes>tstart & spikes<tend);
            spikes_oi = spikes(S2);
            
            % buscando la posicion de la espiga en el espacio
            Xpos = interp1(t,X, spikes_oi); %find the X-pos where each cell fired
            Ypos = interp1(t,Y, spikes_oi); %find the Y-pos where each cell fired
            
            %figure(218);
            maze_length_cm = 65;
            maze_length_pix = 520;
            pix_per_cm = maze_length_pix/maze_length_cm;
            cm_per_bin = 3; % 3x3cm bins
            pixels_per_bin = round(pix_per_cm*cm_per_bin);
            
            edge{1} = 0:pixels_per_bin:960;
            edge{2} = 0:pixels_per_bin:720;
            

            values_pos = hist3([X Y],'Edges',edge);

            values_spikes = hist3([Xpos,Ypos],'Edges',edge);
            
            %%% normalizando por firing rate
            video_srate = 14;
            vector_pos  = values_pos/video_srate; % from frames to seconds units
            vector_spike = values_spikes;
            
            %descartando posible errores de calculo
            vector_rate = vector_spike./vector_pos;
            vector_rate(isnan(vector_rate)) = 0;
            vector_rate(~isfinite(vector_rate)) = 0;
            vector_rate(vector_rate>100) = 0;

            final_matrix_hann = conv2(vector_rate,(hanning(7)./sum(hanning(7)))*(hanning(7)'./sum(hanning(7))),'valid');
            
            % IPS
            sum_values_pos = sum(sum(values_pos));
            P_values_pos = values_pos./sum_values_pos;%transformando ocupancia en probabilidad
            
            % para calcular el Rmean debo descontar los bines con valor 0, sino la
            % media no es correcta:
            idx = find(values_pos(:)>0);
            total_matrix = (sum(sum(vector_rate)))/length(idx); % tasa de descarga promedio por bin. suma las tasas de descarga de todos los bines, y la divide por el numero de bines en que el animal tuvo una ocupancia mayor que cero
            Ri_Rmean = vector_rate./total_matrix; %variable Ri/R, ojo que queda una matriz
            lin_RiR = Ri_Rmean(:); %Ri/R linealizado
            logR = log2(lin_RiR); %segundo componente de la ecc
            logR(~isfinite(logR)) = 0;
            logR(isnan(logR)) = 0;
            lin_P_values = P_values_pos(:);
            lin_PiR = lin_P_values.*lin_RiR; % primer componente de la ecc
            lin_PiR(~isfinite(lin_PiR)) = 0;
            lin_PiR(isnan(lin_PiR)) = 0;
            fIPS2 = lin_PiR.*logR;
            IPS_final = sum(fIPS2);
            %Sparsity
            lin_vrate = vector_rate(:);
            fsparsity = sum((lin_P_values.*(lin_vrate.^2)));
            gsparsity = sum(lin_P_values.*lin_vrate).^2;
            sparsity = gsparsity./fsparsity;
            
            if m == 1
                ips_table.ips_sample(s,1) = IPS_final;
                sparsity_table.sparsity_sample(s,1) = sparsity;
            else
                ips_table.ips_test(s,1) = IPS_final;
                sparsity_table.sparsity_test(s,1) = sparsity;
            

            end
            end
   
        else
            disp(['Warning for ' tsp_dir(m).name ' recording'])
            disp('The .tsp file of this recording does not have columns 6 and 7.')
            disp('This mean that, for this recording, Amplipex software did not perform animal tracking')
        end
    end
end
save([data_dir 'ips_table.mat'],'ips_table')
