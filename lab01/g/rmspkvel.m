function [spikes_invel,txy_invel] = rmspkvel(spikes, txy, pix_per_cm, video_sr, ivel_threshold)
% This function removes all the spikes that occurred when the animal was moving slower than a defined speed threshold (ivel_threshold). To do this, the codes first computes the instant velocity on each video frame, then interpolates the spikes' timestamps to this velocities to get the velocity the animal was moving at when each spike occurred. Finally, all spikes below the threshold are removed.
% INPUTS:
%	- spikes: vector of spikes timestmaps, the time units must be in miliseconds
%	- txy: txy matrix that results from mktxy.m function. It is a n_framesx3 matrix containing the timestamp of the video frames in the first column and the xy points of the position of the animal in the second and third columns
%	- pix_per_cm: ratio of how many pixels corresponds to one centimeter in the videoframe of the current recording.The function pix2cm.m creates this value.
%	- video_sr: sampling rate of the video (frames/s)
%	- ivel_threshold: instant velocity threshold you define to discard spikes

ivel = [0; arrayfun(@(t) pdist(txy(t:t+1,[2 3])),1:size(txy,1)-1)']; % compute distance between consecutive frames (pixels/frame)
ivel = ivel/pix_per_cm; % from pixels to cm, distance is now cm/frame
ivel = ivel*video_sr; % from frames to seconds, now instant velocity is cm/s
					
spikes_vel = interp1(txy(:,1),ivel, spikes); % interpolation to obatin the velocity the animal was moving at when the cell fired.
spikes_invel = spikes(spikes_vel >= ivel_threshold);
txy_invel = txy(ivel >= ivel_threshold,:);
