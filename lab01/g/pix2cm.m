function pix2cm(videos,maze_length_cm,frame_to_plot)
% pix2cm(videos,maze_length_cm,frame_to_plot)
%
% This function obtains the number of how many pixels correspond to one centimeter for all the videos added as inputs, and saves the resulting values. 
% It makes you mark two points in a plotted video frame that should correspond to the length of one of the dimensions of your maze (maze_length_cm input). After this, the function computes the distance between the two points in pixels, calculates the ratio, and saves the value.
% 	INPUTS:
% 		- videos: it is the output struct obtained using dir() function, that should contain the filenames of all your videos
% 		- maze_length_cm: the length of your maze in centimeters
% 		- frame_to_plot (optional): the video frame you want to plot to mark the points required for computing the ratio (default = 200).
%
if nargin < 3
	frame_to_plot = 200;
end
total = size(videos,1);
if total ~= 2 && total ~= 4
	return
end

if total == 2
	tags = {'S' 'T'};
elseif total == 4
	tags = {'RA1' 'RA2' 'RB1' 'RB2'};
end
close(figure(666))
for v = 1:total
	figure(666)
	set(gcf,'color','w','units','normalized','outerposition',[0 0 1 1])

	if isunix || ismac	
		currtime = frame_to_plot/30;
		xyloObj = VideoReader(videos(v).name,'currenttime',currtime);
		mov = readFrame(xyloObj);

		image(mov)
		axis off
		title('\color[rgb]{0 0 0}Click two \color[rgb]{1 0 0}vertical \color[rgb]{0 0 0}points to get the length of the base of the maze','fontsize',20)

		maze_points(1,:) = ginput(1);
		hold on
		plot(maze_points(1,1),maze_points(1,2),'r.','markersize',20)
		maze_points(2,:) = ginput(1);
		plot(maze_points(2,1),maze_points(2,2),'r.','markersize',20)

		maze_length_pix = pdist(maze_points);
		pix_per_cm = maze_length_pix/maze_length_cm;

	elseif ispc
		xyloObj = VideoReader(videos(v).name);
		vidHeight = xyloObj.Height;
		vidWidth = xyloObj.Width;

		mov = struct('cdata',zeros(vidHeight,vidWidth, 3,'uint8'),'colormap',[]);

		mov(1).cdata = read(xyloObj,frame_to_plot);
		[X,~] = frame2im(mov(1));
		image(X)
		axis off
		title('\color[rgb]{0 0 0}Click two \color[rgb]{1 0 0}vertical \color[rgb]{0 0 0}points to get the length of the base of the maze','fontsize',20)

		maze_points(1,:) = ginput(1);
		hold on
		plot(maze_points(1,1),maze_points(1,2),'r.','markersize',20)
		maze_points(2,:) = ginput(1);
		plot(maze_points(2,1),maze_points(2,2),'r.','markersize',20)

		maze_length_pix = pdist(maze_points);
		pix_per_cm = maze_length_pix/maze_length_cm;

	end
	pause(.1)
	clf
	save(['pix_per_cm_' tags{v} '.mat'],'pix_per_cm');
	clear xyloObj mov maze_vertices pix_per_cm maze_length_pix
end
close(figure(666))
