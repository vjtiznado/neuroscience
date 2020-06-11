function smspars = getsmspars(socmap, sfrmap)
% This function calculates the Sparsity value, which represents the relative proportion of the maze on which the cell fired.
% The formula is the following:
%                    __ 
%                    \
%    Sparsity =      /_ (p(i) * (R(i)^2)) /Rmean^2)
%                     i
% where i is the value for each space bin and
%	- p(i) corresponds to the probability of obtaining the determined occupancy that the spacebin has
%	- R(i) corresponds to the actual firing rate in the bin
%	- R_mean corresponds to the average firing rate of all bins that had a occupancy>0
%
total_occ = sum(sum(socmap)); % sum of all occupancy values to get total occupation time
p_occ = socmap./total_occ; % computing probability of all given occupancy values
p_occ = p_occ(:); % linearazing the matrix

% % Computing average firing rate between spacebins.
% idx = find(ocmap(:)>0); % Only using as N the number of bins where occupancy was above zero
% total_matrix = (sum(sum(frmap)))/length(idx); % mean firing rate

sfrmap = sfrmap(:); % linearizing the matrix
Pi_Ri = p_occ.*sfrmap;
Pi2_Ri2 = (sum(Pi_Ri))^2;  % First component of equation

Pi_Ri2 = p_occ.*(sfrmap.^2);
SPi_Ri2 = sum(Pi_Ri2);   % second component

smspars = Pi2_Ri2/SPi_Ri2;



