function [spikes_xy, ocmap, fmap, frmap, sfrmap, hist_xy] =  mkfrmap(spikes, txy_matrix, centroid, video_sr, pix_per_cm, cm_per_bin)
% [spikes_xy, ocmap, fmap, frmap, sfrmap, hist_xy] =  mkfrmap(spikes, txy_matrix, centroid, video_sr, pix_per_cm, cm_per_bin)
% this function creates a firing rate map of a given neuron
% INPUTS:
% 	- spikes: timestamps of your spike's firings
% 	- txy_matrix: matrix containing the position of the animal, it has to be a <n_timestampsx3> matrix
% 		- first column: timestamp of the position measure. they must match the same units as spikes timestamps
% 		- second column: position in x-axis (normally pixels)
% 		- third column: position in y-axis (normally pixels)
%		* this matrix is the output of the mktxy.m function
%	- video_sr: sampling rate of the video that recorded animal's position
%	- pix_per_cm: How many pixels of the videoframe correspond to 1cm of the maze. This value is the output of the pix2cm.m function
%	- cm_per_bin: Number of centimeters you will use as the spacebin square to compute firing rate maps. Default value is 3, to create a 3x3cm spacebin.
% OUTPUTS:
%	- spikes_xy: (x,y) position of each spike during exploration time.
%	- ocmap: Occupancy map. How many seconds the animal spent on each space bin
%	- fmap: Firing map. Number of spikes on each space bin
%	- frmap: Firing rate map. Firing rate on each space bin. It corresponds to fmap divided by ocmap
%	- sfrmap: Smoothed firing rate map. 
%	- hist_xy: xy axis to create all the matrices. It is based on the defined cm_per_bin for each space bin, which is transformed to pixels to create xy vectors based on the dimensions of the videoframes of the camera (960x720)
%
% This function first create a position map representing the occupancy of the animal in the maze
% Then, it computes the firing map of the current neuron in the space, 

% videocamera parameters
if nargin < 6
	cm_per_bin = 3; % 3x3cm bins
end
pixels_per_bin = pix_per_cm*cm_per_bin;

% x and y vectors for creating the histograms
hist_xy{1} = [fliplr(2*centroid(1)-(centroid(1):pixels_per_bin:centroid(1)+pix_per_cm*200)),centroid(1)+pixels_per_bin:pixels_per_bin:centroid(1)+pix_per_cm*200];
hist_xy{2} = [fliplr(2*centroid(2)-(centroid(2):pixels_per_bin:centroid(2)+pix_per_cm*200)),centroid(2)+pixels_per_bin:pixels_per_bin:centroid(2)+pix_per_cm*200];

if isempty(spikes)
    % occupancy map
    ocmap = hist3([txy_matrix(:,2) txy_matrix(:,3)],'Edges',hist_xy); % histogram of how many videoframes the animal was on each spacebin
    ocmap =  ocmap/video_sr; % from number_of_frames on each spacebin to seconds spent on each spacebin
    spikes_xy = [];
    fmap = hist3([nan nan],'Edges',hist_xy); % histogram of how many spikes occurred on each spacebin
    frmap = fmap;
    sfrmap = fmap;
    return
end

% looking for the spikes during the exploration of the maze
spikes_exp = spikes(spikes > txy_matrix(1,1) & spikes < txy_matrix(end,1));

% finding the xy position of each firing
spikes_xy(:,1) = interp1(txy_matrix(:,1),txy_matrix(:,2), spikes_exp); %find the X-pos where spike occurred
spikes_xy(:,2) = interp1(txy_matrix(:,1),txy_matrix(:,3), spikes_exp); %find the Y-pos where spike occurred

% occupancy map
ocmap = hist3([txy_matrix(:,2) txy_matrix(:,3)],'Edges',hist_xy); % histogram of how many videoframes the animal was on each spacebin
ocmap =  ocmap/video_sr; % from number_of_frames on each spacebin to seconds spent on each spacebin
% ocmap(ocmap<0.100) = 0;

% firing map
fmap = hist3([spikes_xy(:,1) spikes_xy(:,2)],'Edges',hist_xy); % histogram of how many spikes occurred on each spacebin

% firing rate map
frmap = fmap./ocmap; % histogram of firing rate (spikes/second) on each spacebin
% cleaning firing rate map
frmap(isnan(frmap)) = 0;
frmap(~isfinite(frmap)) = 0;
frmap(frmap>100) = 0;

% smoothed firing rate map
sfrmap = conv2(frmap,(gausswin(5)./sum(gausswin(5)))*(gausswin(5)'./sum(gausswin(5))),'valid');
% as the convolution results in non-matching sizes between sfrmap and frmap, we equals them by adding zero-valued space bins in the sfrmap
sfrmap2 = sfrmap;
diffrows = size(frmap,1) - size(sfrmap,1);
diffcols = size(frmap,2) - size(sfrmap,2);

sfrmap = [zeros(diffrows/2,size(sfrmap2,2)); sfrmap2; zeros(diffrows/2,size(sfrmap2,2))]; % adding zero-valued rows
sfrmap = [zeros(size(sfrmap,1),diffcols/2), sfrmap, zeros(size(sfrmap,1),diffcols/2)]; % adding zero-valued columns

