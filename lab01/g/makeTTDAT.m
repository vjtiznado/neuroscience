function [T,WV,n] = makeTTDAT(chan)

% if nargin < 2; chan = [25 27 29 31]; end
if numel(chan) ~= 4;
    T = []; WV = [];
    disp('4 channels needed')
    return
end

LAN = lan_from_dat_aut();
LAN.srate = 20000;
cfg = struct('sr', LAN.srate, 'w_pre', 16, 'w_post', 16,...
    'ref', 2*LAN.srate/1000, 'detection', 'neg', 'stdmin', 5,...
    'stdmax', 50, 'fmin', 300, 'fmax', 5000,...
    'interpolation', 'y', 'int_factor', 2);

x = double(LAN.data{1}(chan,:));
for c = 1:size(x,1)
    [b,a]=ellip(2,0.1,40,[cfg.fmin cfg.fmax]*2/cfg.sr);
    x(c,:)=filtfilt(b,a,double(x(c,:)));
end

[~,~,TS] = amp_detect(x, cfg, false);

[T,WV] = myoriginalLoadTT(x, TS);
n = length(T);

    function [T,WV] = myoriginalLoadTT(x, TS, chan)
        % x : DON'T DOWNSAMPLE!
        % TS : POINTS!
        
        
        if nargin < 3
            chan = [1 2 3 4];
        end
        logind = false(size(TS,2));
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