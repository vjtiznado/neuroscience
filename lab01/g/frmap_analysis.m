%%
mean_fr = mean(sfrmap(sfrmap~=0));
peak_fr = max(sfrmap(:));
[maxrow, maxcol] = find(sfrmap == peak_fr); 
ecc = 1;
per_th = 0.3;
surr_bins = cell2mat(arrayfun(@(e) [sfrmap(maxrow-ecc,(maxcol-ecc):(maxcol+ecc)),sfrmap(maxrow,maxcol-ecc),sfrmap(maxrow,maxcol+ecc),sfrmap(maxrow+ecc,(maxcol-ecc):(maxcol+ecc))],1:ecc,'uniformoutput',false));
mean_surr = mean(surr_bins);
ispfield = (mean_surr/peak_fr) > per_th;
%% place field detection
% based on Roux et al 2017
% A place field was defined as a contiguous region of at least 72 cm2 (8 bins) in which the firing rate was above 60% of the peak rate in the maze, containing at least one bin above 80% of the peak rate in the maze
peak_maze = max(sfrmap(:));
peak_pf_thr = 0.8;

[put_peaks_r, put_peaks_c] = find(sfrmap >= peak_maze*peak_pf_thr); % row and columns of the bins above threshold
