function spikes_noripp = rmspkripp(spikes, RT)
% This function removes all the spikes that occurred during a ripple event.
% INPUTS:
% 	- spikes: your vector of the spikes timestamps (it must be a [1 x n_spikes] vector)
%	- RT: RT struct, which is the struct that results from ripples detection. It must contain a vector with the timestamps of yur detected ripples and a vector with the duration of each of them.
%
% OUTPUTS:
%	- spikes_noripp = a vector containing only the spikes timestamps that occurred outside ripple events.
%
% NOTE: It is mandatory that time units of both spikes and ripples match (we recommend you to use miliseconds as units). Please perform units transformation before invoking this function.

ripps_ts = RT.laten;
ripps_durs = RT.OTHER.duration;

spikes_ripp = cell2mat(arrayfun(@(r) spikes >= ripps_ts(r) & spikes <= (ripps_ts(r)+ripps_durs(r)),1:size(ripps_ts,2),'uniformoutput',false));
spikes_ripp = logical(sum(spikes_ripp,2))';

spikes_noripp = spikes(~spikes_ripp);
