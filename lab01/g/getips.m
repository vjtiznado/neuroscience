function ips = getips(ocmap, frmap)
% This function calculates the IPS value, which represents the spatial information content of the spiking activity of a given neuron
% The formula is the following:
%                    __ 
%                    \
%         IPS =      /_ p(i) * (R(i)/Rmean) * log2(R(i)/Rmean)
%                     i
% 
% where i is the value for each space bin and
%	- p(i) corresponds to the probability of obtaining the determined occupancy that the spacebin has
%	- R(i) corresponds to the actual firing rate in the bin
%	- R_mean corresponds to the average firing rate of all bins that had a occupancy>0
%
total_occ = sum(sum(ocmap)); % sum of all occupancy values to get total occupation time
p_occ = ocmap./total_occ; % computing probability of all given occupancy values
p_occ = p_occ(:); % linearazing the matrix

% Computing average firing rate between spacebins.
idx = find(ocmap(:)>0); % Only using as N the number of bins where occupancy was above zero
total_matrix = (sum(sum(frmap)))/length(idx); % mean firing rate

Ri_Rm = frmap./total_matrix; % Ri/Rmean variable. it is a matrix
Ri_Rm = Ri_Rm(:); % linearized Ri/Rmean

PiR = p_occ.*Ri_Rm; % First equation component. pi * (Ri/Rmean)
PiR(~isfinite(PiR)) = 0;
PiR(isnan(PiR)) = 0;

logR = log2(Ri_Rm); % Second equation component. log_2(Ri/Rmean)
logR(~isfinite(logR)) = 0;
logR(isnan(logR)) = 0;

pre_ips = PiR.*logR;

ips = sum(pre_ips);

