function [spk_q1,spk_q2,spk_q3,spk_q4,theta_obj,theta_q,t_quad] = spk_quad_S(spikes,vertices,txy,video_sr)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

for k = 1:2
    vertices.maze(:,k) = vertices.maze(:,k) - vertices.maze_centroid(k);
    vertices.obj1(:,k) = vertices.obj1(:,k) - vertices.maze_centroid(k);
    vertices.obj2(:,k) = vertices.obj2(:,k) - vertices.maze_centroid(k);
end
geom = polygeom(vertices.obj1(:,1),vertices.obj1(:,2));
centroid_obj1 = [geom(2),geom(3)];
geom = polygeom(vertices.obj2(:,1),vertices.obj2(:,2));
centroid_obj2 = [geom(2),geom(3)];
theta_obj(1) = wrapTo2Pi(cart2pol(centroid_obj1(1),centroid_obj1(2)));
theta_obj(2) = wrapTo2Pi(cart2pol(centroid_obj2(1),centroid_obj2(2)));
a = exp(1i*(theta_obj(1) - pi/4)) + exp(1i*(theta_obj(2) - pi/4));

theta1 = wrapTo2Pi(angle(a) - pi/4);
theta2 = wrapTo2Pi(angle(a) + pi/4);
theta3 = wrapTo2Pi(theta1 + pi);
theta4 = wrapTo2Pi(theta2 + pi);
theta_q = sort([theta1; theta2; theta3; theta4]);

txy(:,2) = txy(:,2) - vertices.maze_centroid(1);
txy(:,3) = txy(:,3) - vertices.maze_centroid(2);

theta_taject = wrapTo2Pi(cart2pol(txy(:,2),txy(:,3)));
quad(:,1) = theta_taject > theta_q(1) & theta_taject < theta_q(2);
quad(:,2) = theta_taject > theta_q(2) & theta_taject < theta_q(3);
quad(:,3) = theta_taject > theta_q(3) & theta_taject < theta_q(4);
quad(:,4) = theta_taject < theta_q(1) | theta_taject > theta_q(4);

spk_q1 = interp1(txy(:,1),double(quad(:,1)),spikes);
spk_q2 = interp1(txy(:,1),double(quad(:,2)),spikes);
spk_q3 = interp1(txy(:,1),double(quad(:,3)),spikes);
spk_q4 = interp1(txy(:,1),double(quad(:,4)),spikes);

spk_q1(isnan(spk_q1)) = 0; spk_q1 = logical(spk_q1);
spk_q2(isnan(spk_q2)) = 0; spk_q2 = logical(spk_q2);
spk_q3(isnan(spk_q3)) = 0; spk_q3 = logical(spk_q3);
spk_q4(isnan(spk_q4)) = 0; spk_q4 = logical(spk_q4);

t_quad(1) = sum(quad(:,1))/video_sr;
t_quad(2) = sum(quad(:,2))/video_sr;
t_quad(3) = sum(quad(:,3))/video_sr;
t_quad(4) = sum(quad(:,4))/video_sr;
end
