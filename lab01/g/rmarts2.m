%% this is a very preliminar way to try to discard artifacts that resemble ripple events. In order to avoid discarding actual ripples, the code discards events only when they occur in a non-physiological frequency (finding >=5 ripples in one second is very rare, even more if the interval between ripples is constant), or if the ripple has a very outlier amplitude
% once you set universal thresholds, the idea is to transform this ugly code into a matlab function
clear;clc;
close all;
basal_dir = '/home/labpf/Dropbox/A Garcia/LAN/LAN_PUPS/'; % set the folder where the recording you want to visualize is
cd(basal_dir);
load('lan1000_reg01_AG13_solosueño_p35_CTX_CA1_TH_180511_124456.mat') % add here the name of the recording you want to visualize
%%
clear;clc;
close all;
basal_dir = '/home/labpf/Dropbox/A Garcia/LAN/LAN_PUPS/'; % set the folder where the recording you want to visualize is
cd(basal_dir);
rec = dir('*AG13*p35*456*');
load(rec(1).name)

choi = 5;      % %%% channel of interest
f_ripps = [120 250]; % %%% ripples' frequency band (Hz)
mad_th = 20;    % %%% median absolute deviations threshold to discard very-high amplitude events
span = 50; % %%% max frequency of the low-pass filter used to smooth the envelope of the signal in the ripples frequency band. default value for ripple detection is 20Hz, but it has been set higher to capture the sharpness of short ripple-like artifacts 

chmod = LAN.data{1}(choi,:);

% preventing border effects before applying filters
% %%
sign = ones(1,length(chmod));
nborde = ceil((1/(f_ripps(1)-0.5))*LAN.srate);
win = hann(4*nborde+1);
sign(1:2*nborde) = win(1:2*nborde);
sign(end-2*nborde-1:end) = win(end-2*nborde-1:end);
chmod = chmod.*sign;
% %%

% envelope of the signal at the ripples' frequency band
env_ripps = filter_hilbert(chmod',LAN.srate,f_ripps(1),f_ripps(2))';
env_ripps = abs(real(env_ripps));

% smoothing the envelope (applying a low-pass filter)
[b,a] = butter(2,span/(LAN.srate/2));
power_filt = filtfilt(b,a,double(env_ripps));

% capturing the frequency at which ripple events occur along recording (kind of)
% filtering the smoothed envelope in a frequency band in which ripple events rarely occur (>5Hz)
pr_beta = abs(real(filter_hilbert(power_filt',LAN.srate,6,15)'));
% applying a sliding window to compute the sum of the power of pr_beta at each point
wwms = 400; % miliseconds
wwms = LAN.srate*wwms/1000;
sumpw = zeros(1,length(chmod));
for w = (wwms/2+1):(length(chmod)-wwms/2)
	sumpw(w) = sum(pr_beta((w-wwms/2):(w+wwms/2)));
end

ath = isoutlier(power_filt,'thresholdfactor',mad_th); % threshold to detect very outlier isolated points
ath2 = isoutlier(sumpw,'thresholdfactor',5); % threshold to discard ripples occuring at non-physiological frequencies
ref = ath|ath2; % combining the points of the two artifact detectors (you can use & or |) * I used "or" because the idea is to discard events occurring in a non-physiological frequency regardless of their amplitude. The events could have the same amplitude of a normal ripple but if their occur in a weird frequency they must be discarded anyway. Moreover, events with very outlier amplitudes should be discarded even if it is a single event.

winms = 500; % %%% length of the sliding windows to discard the points surrounding the artifactual points. The longer the window, the longer the section discarded surrounding the artifact

wins = (winms/1000)*LAN.srate; % samples
sel2 = true(1,LAN.pnts); % sel2 will be the new LAN.selected after running the sliding window. 0 = non-artifact. 1=artifact

% sliding window to discard points surrounding artifacts
for p = ((wins/2)+1):(LAN.pnts-wins/2)
	if any(ref(p-wins/2:p+wins/2))
		sel2(p) = false;
	end
end

LAN.selected_original{1} = LAN.selected{1}; % saves the original LAN.selected
LAN.selected_ripp{1} = sel2; % LAN.selected to analyze slow oscillations
LAN = rmfield(LAN,'selected');
LAN.selected{1} = LAN.selected_ripp{1}; % replace the LAN.selected to evaluate this function using the lan_master_gui

clc
disp(' ')
disp(['number of artefactual points in the LAN.selected0_original vector = ' num2str(sum(LAN.selected_original{1}==0))])
disp(['number of artefactual points in the LAN.selected_ripp vector (detected by matlab) = ' num2str(sum(LAN.selected_ripp{1}==0))])
disp(['number of matching points between LAN.selected_original and LAN.selected_ripp = ' num2str(sum(LAN.selected_ripp{1}==0&LAN.selected_original{1}==0))])
disp(' ')

chfilt = lan_butter(LAN,f_ripps(1),f_ripps(2),choi);
chfilt = chfilt{1}(choi,:);


LAN.data{1}(size(LAN.data{1},1)+1,:) = single(chfilt); % add the processed channel into the LAN structure

fields = fieldnames(LAN); % get LAN fields' list
nds = strcmp(fields,'data') | strcmp(fields,'srate') | strcmp(fields,'selected_original') | strcmp(fields,'selected_ripp') | strcmp(fields,'selected_so');
LAN = rmfield(LAN,fields(~nds)); % remove all fields excepting the important ones
LAN = lan_check(LAN);
LAN.selected{1} = LAN.selected_ripp{1}; % replace the LAN.selected to evaluate the results of this function using the lan_master_gui

%%

lan_master_gui(LAN) % run the lan_master_gui to evaluate if the thresholds you set are working

