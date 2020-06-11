function mkvert(videos,total)
% mkvert(videos,total)
%
% This function creates and saves a struct called 'vertices' with three fields: 
% 	- vertices.maze: n_vertices_maze
if total ~= 2 && total ~= 4
	return
end

if total == 2
	tags = {'S' 'T'};
elseif total == 4
	tags = {'RA1' 'RA2' 'RB1' 'RB2'};
end

for v = 1:total

	figure(666)
	set(gcf,'color','w','units','normalized','outerposition',[0 0 1 1])
	% since VideoReader seems to work differently depending on the operating system of the computer running it, the code is adapted to it
	if isunix || ismac
		xyloObj = VideoReader(videos(v).name,'currenttime',10);
		mov = readFrame(xyloObj);

		image(mov)
		xlabel(videos(v).name,'fontsize',20,'interpreter','none')
		set(gca,'ycolor','w','xcolor','w','tickdir','out')

		title('\color[rgb]{0 0 0}click on the vertices of \color[rgb]{1 0 0}THE MAZE \color[rgb]{0 0 0}, then press enter','fontsize',28,'fontweight','bold')
		n = 0;
		maze_vertices = [];
		while true
			[x, y, button] = ginput(1);
			if isempty(x) || button(1) ~= 1; break; end
			n = n+1;
			maze_vertices(n,[1 2]) = [x,y];
			hold on
			plot(maze_vertices(:,1),maze_vertices(:,2), 'r.-','linewidth',2,'markersize',15)
			drawnow
		end
		maze_vertices(size(maze_vertices,1)+1,:) = maze_vertices(1,:); % repeat the first point at the end to close the polygon

		title('\color[rgb]{0 0 0}click on the vertices of \color[rgb]{0 .7 0}OBJECT 1 \color[rgb]{0 0 0}, then press enter','fontsize',28,'fontweight','bold')
		n = 0;
		obj1_vertices = [];
		while true
			[x, y, button] = ginput(1);
			if isempty(x) || button(1) ~= 1; break; end
			n = n+1;
			obj1_vertices(n,[1 2]) = [x,y];
			hold on
			plot(obj1_vertices(:,1),obj1_vertices(:,2), 'r.-','color',[0 .7 0],'linewidth',2,'markersize',15)
			drawnow
		end
		obj1_vertices(size(obj1_vertices,1)+1,:) = obj1_vertices(1,:); % repeat the first point at the end to close the polygon

		title('\color[rgb]{0 0 0}click on the vertices of \color[rgb]{0 0 .7}OBJECT 2 \color[rgb]{0 0 0}, then press enter','fontsize',28,'fontweight','bold')
		n = 0;
		obj2_vertices = [];
		while true
			[x, y, button] = ginput(1);
			if isempty(x) || button(1) ~= 1; break; end
			n = n+1;
			obj2_vertices(n,[1 2]) = [x,y];
			hold on
			plot(obj2_vertices(:,1),obj2_vertices(:,2), '.-','color',[0 0 .7],'linewidth',2,'markersize',15)
			drawnow
		end
		obj2_vertices(size(obj2_vertices,1)+1,:) = obj2_vertices(1,:); % repeat the first point at the end to close the polygon

		clf
	elseif ispc
		xyloObj = VideoReader(videos(v).name);
		vidHeight = xyloObj.Height;
		vidWidth = xyloObj.Width;

		mov = struct('cdata',zeros(vidHeight,vidWidth, 3,'uint8'),'colormap',[]);

		frame_to_plot = 500;
		mov(1).cdata = read(xyloObj,frame_to_plot);
		[X,~] = frame2im(mov(1));
		image(X)
		xlabel(videos(v).name,'fontsize',20,'interpreter','none')
		set(gca,'ycolor','w','xcolor','w','tickdir','out')

		title('\color[rgb]{0 0 0}click on the vertices of \color[rgb]{1 0 0}THE MAZE \color[rgb]{0 0 0}, then press enter','fontsize',28,'fontweight','bold')
		n = 0;
		while true
			[x, y, button] = ginput(1);
			if isempty(x) || button(1) ~= 1; break; end
			n = n+1;
			maze_vertices(n,[1 2]) = [x,y];
			hold on
			plot(maze_vertices(:,1),maze_vertices(:,2), 'r.-','linewidth',2,'markersize',15)
			drawnow
		end
		maze_vertices(size(maze_vertices,1)+1,:) = maze_vertices(1,:); % repeat the first point at the end to close the polygon

		title('\color[rgb]{0 0 0}click on the vertices of \color[rgb]{0 .7 0}OBJECT 1 \color[rgb]{0 0 0}, then press enter','fontsize',28,'fontweight','bold')
		n = 0;
		while true
			[x, y, button] = ginput(1);
			if isempty(x) || button(1) ~= 1; break; end
			n = n+1;
			obj1_vertices(n,[1 2]) = [x,y];
			hold on
			plot(obj1_vertices(:,1),obj1_vertices(:,2), 'r.-','color',[0 .7 0],'linewidth',2,'markersize',15)
			drawnow
		end
		obj1_vertices(size(obj1_vertices,1)+1,:) = obj1_vertices(1,:); % repeat the first point at the end to close the polygon

		title('\color[rgb]{0 0 0}click on the vertices of \color[rgb]{0 0 .7}OBJECT 2 \color[rgb]{0 0 0}, then press enter','fontsize',28,'fontweight','bold')
		n = 0;
		while true
			[x, y, button] = ginput(1);
			if isempty(x) || button(1) ~= 1; break; end
			n = n+1;
			obj2_vertices(n,[1 2]) = [x,y];
			hold on
			plot(obj2_vertices(:,1),obj2_vertices(:,2), '.-','color',[0 0 .7],'linewidth',2,'markersize',15)
			drawnow
		end
		obj2_vertices(size(obj2_vertices,1)+1,:) = obj2_vertices(1,:); % repeat the first point at the end to close the polygon

		clf
	end
	psm = polyshape(maze_vertices);
	[cx,cy] = centroid(psm);
	vertices.maze_centroid = [cx,cy];
	vertices.maze = maze_vertices;
	vertices.obj1 = obj1_vertices;
	vertices.obj2 = obj2_vertices;
	save(['vertices_' tags{v} '.mat'],'vertices');
	clear xyloObj vidWidth vidHeight mov X vertices maze_vertices obj1_vertices obj2_vertices
end
close
