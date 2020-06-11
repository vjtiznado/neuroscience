function [T,WV,n] = makeTTDAT2_split(chan,file_dat,half)
% This function detects any putative action potential during you 'file_dat' recording.
% All detected 'ocurrences' will undergo clustering to continue spike sorting.

% if nargin < 2; chan = [25 27 29 31]; end
if numel(chan) ~= 4;
    T = []; WV = [];
    disp('4 channels needed')
    return
end
% create a LAN from your .dat file
LAN = lan_from_dat_aut2(file_dat);
LAN.srate = 20000;
% set configuration parameters for occurrence detection
cfg = struct('sr', LAN.srate, 'w_pre', 16, 'w_post', 16,...
    'ref', 2*LAN.srate/1000, 'detection', 'neg', 'stdmin', 5,...
    'stdmax', 50, 'fmin', 300, 'fmax', 5000,...
    'interpolation', 'y', 'int_factor', 2);
% use only data from the LAN
rec_length = size(LAN.data{1},2);
x1 = double(LAN.data{1}(chan,1:round(rec_length/2)));
x2 = double(LAN.data{1}(chan,(round(rec_length/2)+1):end));
clear LAN %LAN = [];
% recording thresholds preallocation (one per channel)
thr = zeros(size(x1,1),1);
thrmax = zeros(size(x1,1),1);
thr1 = zeros(size(x1,1),1);
thr2 = zeros(size(x1,1),1);
thrmax1 = zeros(size(x1,1),1);
thrmax2 = zeros(size(x1,1),1);
for c = 1:size(x1,1)
%     filtering the signal
    [b,a]=ellip(2,0.1,40,[cfg.fmin cfg.fmax]*2/cfg.sr);
    x1(c,:)=filtfilt(b,a,double(x1(c,:)));
    
    noise_std1 = median(abs(x1(c,:)))/0.6745; % determining noise median
    thr1(c,1) = cfg.stdmin * noise_std1; % threshold (cfg.stdmin SD from noise) that need to be surpassed to detect any putative action potentials
    thrmax1(c,1) = cfg.stdmax * noise_std1; % upper threshold that avoid detecting artifacts
    % the same for the second half of the recording
    x2(c,:)=filtfilt(b,a,double(x2(c,:)));
    noise_std2 = median(abs(x2(c,:)))/0.6745;
    thr2(c,1) = cfg.stdmin * noise_std2;
    thrmax2(c,1) = cfg.stdmax * noise_std2;
    % shared thershold for the two recording halves
    thr(c,1) = min([thr1(c,1) thr2(c,1)]);
    thrmax(c,1) = min([thrmax1(c,1) thrmax2(c,1)]);
end
% now that thresholds were determined, detect occurrence for the recording half you specified in 'half'
if half == 1
    x = x1;
elseif half == 2
    x = x2;
end
clear x1 x2
% this function detects all the putative spikes that surpassed your threshold
[~,TS] = amp_detect2(x, cfg, false,thr,thrmax);
% this funcion gets the waveform of each putative action potential
[T,WV] = myoriginalLoadTT(x, TS);
n = length(T);
if half == 2
    T = T + round(rec_length/2);
end

    function [T,WV] = myoriginalLoadTT(x, TS)
        % x : DON'T DOWNSAMPLE!
        % TS : POINTS!
        
        
        if nargin < 3
            chan = [1 2 3 4];
        end
%         logind = false(size(TS,2));
        logind = false(1,size(TS,2));
        for c = chan
            logind( TS(2,:)==c ) = true;
        end
        T = TS(1, logind);
        
        WV = nan(length(T),4,32);
        for t = 1:length(T)
            WV(t,:,:) = permute(x(chan,T(t)-15:T(t)+16),[3 1 2]);
        end
    end
end