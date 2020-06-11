function txy_matrix = mktxy(meta, tsp, vertices, trajectories)
% txy_matrix = mktxy(meta, tsp, vertices, trajectories)
% 
% This functions creates the txy_matrix containing the tracking of the animal that will be used to compute the firing rate map of a given neuron
% Inputs:
% 	- meta file data: It contains the timestamp of the start of recording (computer clock - ms). This is important because the timestamps of the videoframes in the tsp file are all respect to this initial timestamp, thus this number must be sustracted. 
% 	- tsp matrix: matrix of the .tsp file produced by Amplipex, which contains the timestamp of each animal's position point with its corresponding (x,y) coordinates in pixels
% 	- vertices: n_vertices+1x2 matrix containing the xy coordinates of the vertices of the maze and objects used. It will be used to discard incorrect corrections outside the maze and inside the objects, which improves the interpolation of points where no detection was found. You can include an empty matrix if you do not want to consider this input.
% 	- trajectories (optional): (x,y) coordinates of the animal's position produced by IdTracker. If this input is included, the (x,y) coordinates of the tsp matrix will not be considered

% In this function, every (x,y) point outside the maze and inside objects will be replaced by a NaN, and all these points with a timestamp but without an (x,y) point will be interpolated to end up with a contious trajectory of (x,y) points. 

ts_ini = strsplit(meta{14,1},'='); % trick to isolate the timestamp of the start of the recording based on the structure of the meta file content
ts_ini = str2double(ts_ini{1,2}); % timestamp of the start of recording
tsp(tsp(:,1) < ts_ini,:) = []; % this is because one recording has a very strange tsp column one. Ensure that all the timestamps are later than the recording start time


if nargin < 4
	xy = tsp(:,[6 7]);
	xy(xy == -1) = nan; % making nan those points where Amplipex did not detect the animal (it adds -1 by default)
	t = tsp(:,1); % timestamps of the videoframes
else
	if ndims(trajectories) == 3
		trajectories = squeeze(trajectories);
	end
	xy = trajectories;
	if size(tsp,1) > size(trajectories,1) 
		t = tsp(1:size(trajectories,1),1); % this is because sometimes the number of frames of the trajectories matrix does not match with the number of frames of the tsp file
	else
		t = tsp(:,1); % timestamps of the videoframes

	end
end
if ~isempty(vertices)
	inmaze = inpolygon(xy(:,1),xy(:,2),vertices.maze(:,1),vertices.maze(:,2)); % detecting points inside the maze
	ino1 = inpolygon(xy(:,1),xy(:,2),vertices.obj1(:,1),vertices.obj1(:,2)); % detecting points inside object 1
	ino2 = inpolygon(xy(:,1),xy(:,2),vertices.obj2(:,1),vertices.obj2(:,2)); % detecting points inside object 2
	xy(~inmaze|ino1|ino2,:) = nan; % making nan the points outside the maze and inside the objects
end

xy_nojumps = rmjumps(xy); % removing huge jumps in the tracking of the animal due to artefactual detections

% As interpolation returns erros when having NaNs either at the end or the beginning of the vector, they are removed before interpolation
while isnan(xy_nojumps(1,1))
	xy_nojumps(1,:) = [];
	t(1,:) = [];
end
while isnan(xy_nojumps(end,1))
	xy_nojumps(end,:) = [];
	t(end,:) = [];
end

% Interpolating points
xi = interp1(find(~isnan(xy_nojumps(:,1))),xy_nojumps(~isnan(xy_nojumps(:,1)),1),1:length(xy_nojumps),'pchip')'; % x axis
yi = interp1(find(~isnan(xy_nojumps(:,2))),xy_nojumps(~isnan(xy_nojumps(:,2)),2),1:length(xy_nojumps),'pchip')'; % y axis

txy_matrix = [t,xi,yi]; 
txy_matrix(:,1) = txy_matrix(:,1) - ts_ini;
