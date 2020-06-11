clear
load('vertices_S.mat')
for k = 1:2
    vertices.maze(:,k) = vertices.maze(:,k) - vertices.maze_centroid(k);
    vertices.obj1(:,k) = vertices.obj1(:,k) - vertices.maze_centroid(k);
    vertices.obj2(:,k) = vertices.obj2(:,k) - vertices.maze_centroid(k);
end
plot(vertices.maze(:,1),vertices.maze(:,2))
hold on
plot(vertices.obj1(:,1),vertices.obj1(:,2))
geom = polygeom(vertices.obj1(:,1),vertices.obj1(:,2));
centroid_obj1 = [geom(2),geom(3)];
plot(centroid_obj1(1),centroid_obj1(2),'ro')
plot(vertices.obj2(:,1),vertices.obj2(:,2))
geom = polygeom(vertices.obj2(:,1),vertices.obj2(:,2));
centroid_obj2 = [geom(2),geom(3)];
plot(centroid_obj2(1),centroid_obj2(2),'ro')

theta1 = wrapTo2Pi(cart2pol(centroid_obj1(1),centroid_obj1(2)) - pi/4);
theta2 = wrapTo2Pi(cart2pol(centroid_obj2(1),centroid_obj2(2)) - pi/4);
a = exp(1i*theta1) + exp(1i*theta2);
theta1 = wrapTo2Pi(angle(a) - pi/4);
theta2 = wrapTo2Pi(angle(a) + pi/4);
theta3 = wrapTo2Pi(theta1 + pi);
theta4 = wrapTo2Pi(theta2 + pi);
thetas = sort([theta1; theta2; theta3; theta4]);
%%
traj_file = dir('trajectories*.mat');
load(traj_file.name,'trajectories2')
trajectories2(:,1) = trajectories2(:,1) - vertices.maze_centroid(1);
trajectories2(:,2) = trajectories2(:,2) - vertices.maze_centroid(2);
plot(trajectories2(:,1),trajectories2(:,2),'k')

theta_taject = wrapTo2Pi(cart2pol(trajectories2(:,1),trajectories2(:,2)));
cuad1 = theta_taject > thetas(1) & theta_taject < thetas(2);
cuad2 = theta_taject > thetas(2) & theta_taject < thetas(3);
cuad3 = theta_taject > thetas(3) & theta_taject < thetas(4);
cuad4 = theta_taject < thetas(1) | theta_taject > thetas(4);

plot(trajectories2(cuad1,1),trajectories2(cuad1,2),'gx')
plot(trajectories2(cuad2,1),trajectories2(cuad2,2),'mx')
plot(trajectories2(cuad3,1),trajectories2(cuad3,2),'rx')
plot(trajectories2(cuad4,1),trajectories2(cuad4,2),'bx')
axis square
