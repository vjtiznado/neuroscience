try
    for tt = 1:size(TT,1) % for each tetrode...
        display(' ')
        display(['TT' num2str(tt)])
        display('filtering between 300-5000 Hz and detecting occurrences (putative spikes)...')
        [T,WV,n] = makeTTDAT2(TT(tt,:),dat_dir(d).name); % detect the occurrences of each putative spike
        disp(['saving ttr' num2str(tt) ' file...']);
        save([dat_dir(d).name(1:end-4) '_tt' num2str(tt) '.ttr'],'T','WV','n'); % save the .ttr file of this tetrode
        disp(['TT' num2str(tt) ' file ready']);
        clear T WV n
    end
catch
    cd([basal_path r_dir(r).name '\' s_dir(s).name])
    ac_ttr = dir([dat_dir(d).name(1:end-4) '_tt*.ttr']);
    ac_ttr = {ac_ttr.name};
    cellfun(@(x) delete(x), ac_ttr)
    for tt = 1:size(TT,1) % for each tetrode...
        display(' ')
        display(['TT' num2str(tt)])
        display('filtering between 300-5000 Hz and detecting occurrences (putative spikes)...')
        [T,WV,n] = makeTTDAT2(TT(tt,:),dat_dir(d).name); % detect the occurrences of each putative spike
        disp(['saving ttr' num2str(tt) ' file...']);
        save([dat_dir(d).name(1:end-4) '_tt' num2str(tt) '.ttr'],'T','WV','n'); % save the .ttr file of this tetrode
        disp(['TT' num2str(tt) ' file ready']);
        clear T WV n
    end
    
end