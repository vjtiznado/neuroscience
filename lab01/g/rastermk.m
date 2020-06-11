function raster = rastermk(fisiol_ts, task_ts, task_beh, trial_time_window)
% raster = rastermk(fisiol_ts, task_ts, task_beh, trial_time_window)
% 
% 
% This function creates a matrix to easily plot a raster plot. The function uses these inputs:
% IMPORTANT: THE FIRST 3 INPUTS MUST TO BE IN THE SAME TIME UNITS
% 
% fisiol_ts = vector containing the timestamps of your physiological phenomenon of interest (e.g. spikes, ripples, etc)
% task_ts = the centers of your raster plot. it must to be vector containing your task-relevant timestamps (eg. lever press, stimulus onset, reward, etc)
% trial_time_window = value of the lenght of your time window. the raster will show the activity of your 'fisiol_ts' +/- trial_time_window/2 time units respect to the center ('task_ts').                  
% task_beh = vector of the codes of the behavioral performance for each trial. For the case of the multisensory GO/NOGO task, is the vector containing the numbers 11,13,22,23 for HIT, MISS, FA, CR, respectively.
% 
% For each trial, the function will detect all the 'fisiol_ts' around your 'task_ts', taking as limits 'task_ts ? trial_time_window/2' and 'task_ts + trial_time_window/2'.
% Then, the function will transform these timestamps values to now show them as function of the 1:trial_time_window time vector of this trial (with your 'task_ts' in the center)
% For example, if trial_time_window = 6000ms and you have one spike 1000ms before your center and another one 1000ms after your center, the time values asigned to your spikes will be 2000ms and 4000ms, respectively
% In the 'raster' output, the new spikes timestamps values for all the trials will be in the same row (the first one) along the columns.
% In the second row you will have the number of the trial at which the spike of the same column in the first row corresponds
% 
% Thus, the resulting matrix is not the classical zeros/ones matrix with number_of_trials rows and (2*samples_for_each_side_of_the_center + 1) columns.
% The resulting ouput will be a matrix with 3 rows:
% raster(1,:) will contain the timestamp of each spike that was inside the time window of any trial, but now related to the 1:trial_time_window vector.
% raster(2,:) will contain the number of the trial at which the spike of the same column in the first row corresponds. If there were no spikes during one trial, in the column of these row will also be the number of the trial but in the above row you will have a NaN.
% raster(3,:) will contain the task_beh value for that trial, in order to easily index and take only the values of some trials of your interest (in the case of the multisensory GO/NOGO task, if you only want the HIT trials you index by the number '11' in this row).




% just to preallocate memory
% if the numbers of spikes is higher than the number of trials, uses the number of spikes as size reference of the matrix.
if length(fisiol_ts) > length(task_ts)
    raster = nan(3,length(fisiol_ts));
else
    raster = nan(3,length(task_ts) + 400);
end

for i = 1:length(task_ts)
        aux = fisiol_ts( fisiol_ts > task_ts(i) - trial_time_window/2 & fisiol_ts < task_ts(i) + trial_time_window/2); % here the function detects the timestamps around your center
        aux = ceil( aux - (task_ts(i) - trial_time_window/2 - 1) );
        aux = aux(aux > 0 & aux < trial_time_window);
        
        if isempty(aux)   % in case you do not have timestamps during the i trial
            raster(1,length(find(~isnan(raster(2,:))))+1) = nan; % add a nan instead of a timestamp in the first row
            raster(2,length(find(~isnan(raster(2,:))))+1) = i;   % the number of the i trial
            raster(3,length(find(~isnan(raster(3,:))))+1) = task_beh(i); % behavioral response for this trial
            
        else          % in case you have timestamps during the i trial
            raster(1,length(find(~isnan(raster(2,:))))+1:length(find(~isnan(raster(2,:))))+length(aux)) = aux; % "new" timestamp of the fisiological event, time=0 is the beginning of your time_window, and at time_window/2 is the task timestamp you centered
            raster(2,length(find(~isnan(raster(2,:))))+1:length(find(~isnan(raster(2,:))))+length(aux)) = i;   % number of the trial at which your fisiological timestamp corresponds
            raster(3,length(find(~isnan(raster(3,:))))+1:length(find(~isnan(raster(3,:))))+length(aux)) = task_beh(i); % behavioral response for this trial
        end
    
end

raster = raster(:,1:length(nonzeros(~isnan(raster(3,:))))); % to delete NaNs


