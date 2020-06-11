function [spikes_groom,txy_groom] = rmspkgroom(spikes, txy, grooming, video_sr, nframes, interv_det)
% This function removes all the spikes that occurred when the animal was moving slower than a defined speed threshold (ivel_threshold). To do this, the codes first computes the instant velocity on each video frame, then interpolates the spikes' timestamps to this velocities to get the velocity the animal was moving at when each spike occurred. Finally, all spikes below the threshold are removed.
% INPUTS:
%	- spikes: vector of spikes timestmaps, the time units must be in miliseconds
%   - grooming intervals
%	- video_sr: sampling rate of the video (frames/s)
%   - interv_det: inter-frame interval for grooming detection

grooming_corrected = [];
for k = 1:length(grooming) - 1
    if grooming(k + 1) - grooming(k) == interv_det;
        grooming_corrected = [grooming_corrected grooming(k):grooming(k + 1)];
    else
        grooming_corrected  = [grooming_corrected grooming(k)];
    end
end
grooming_corrected = unique(grooming_corrected);
groom = zeros(1,nframes);
groom(grooming_corrected) = 1;
t_groom = (1:length(groom))/video_sr;

dummy = interp1(t_groom,groom,spikes/1000);
dummy(isnan(dummy)) = 0;
spk_groom = logical(dummy);
spikes(spk_groom) = [];
spikes_groom = spikes;

dummy = interp1(t_groom,groom,txy(:,1)/1000);
dummy(isnan(dummy)) = 0;
txy_groom = logical(dummy);
txy(txy_groom,:) = [];
txy_groom = txy;
