function [spat_R] = spatial_corr(sfrmap_s,sfrmap_t,socmap_s,socmap_t,lim_oc)
% lim_oc = threshold for occupance

lim_r = size(sfrmap_s,1);
lim_c = size(sfrmap_s,2);
vect_fr_s = reshape(sfrmap_s,[lim_r*lim_c 1]);
vect_fr_t = reshape(sfrmap_t,[lim_r*lim_c 1]);
vect_oc(:,1) = reshape(socmap_s,[lim_r*lim_c 1]);
vect_oc(:,2) = reshape(socmap_t,[lim_r*lim_c 1]);
vect_oc = min(vect_oc,[],2);

vect_fr_s(vect_oc <= lim_oc) = [];
vect_fr_t(vect_oc <= lim_oc) = [];
spat_R = corr(vect_fr_s,vect_fr_t);

