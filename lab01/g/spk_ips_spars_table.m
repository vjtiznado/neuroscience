clear
exp = dir('Exp*');
count = 0;
for e = 1:length(exp)
    cd(exp(e).name)
    archivos = dir('GV*');
    for k = 1:length(archivos) % CARPETAS CON DATOS A USAR (VER VARIALE FECHAS)
        cd(archivos(k).name)
        opr_files = dir('rec*OPR*');
        for d = 1:length(opr_files)
            cd(opr_files(d).name)
            spks_s = dir('spk*tt*_S_*.mat');
            spks_t = dir('spk*tt*_T_*.mat');
            if (length(spks_s) == length(spks_t)) & ~isempty(spks_s)
                for st = 1:length(spks_s)
                    load(spks_s(st).name)
                    count = count + 1;
                    name_spk{count,1} = [spks_s(st).name(5:end - 7) spks_s(st).name(end - 4)];
                    name_opr{count,1} = opr_files(d).name(end - 3 : end);
                    ips_sample(count,1) = ips;
                    spars_sample(count,1) = spars;
                    smips_sample(count,1) = smips;
                    smspars_sample(count,1) = smspars;
                    nspk_orig_sample(count,1) = length(spikes);
                    nspk_thr_sample(count,1) = size(spikes_xy,1);
%                     spat_cohe_sample(count,1) = spat_cohe;
%                     spat_R_sample(count,1) = spat_R;
                    Mean_Frate_sample(count,1) = Mean_Frate;
                    peakFR_sample(count,1) = peakFR;
                    clear ips spars smips smspars Mean_Frate peakFR
%                     load([spks_s(st).name(1:end - 7) 'T' spks_s(st).name(end - 5:end)])
                    load(spks_t(st).name)
                    ips_test(count,1) = ips;
                    spars_test(count,1) = spars;
                    smips_test(count,1) = smips;
                    smspars_test(count,1) = smspars;
                    nspk_orig_test(count,1) = length(spikes);
                    nspk_thr_test(count,1) = size(spikes_xy,1);
%                     spat_cohe_test(count,1) = spat_cohe;
%                     spat_R_test(count,1) = spat_R;
                    Mean_Frate_test(count,1) = Mean_Frate;
                    peakFR_test(count,1) = peakFR;
                end
            else
                disp(['Warning, in ' opr_files(d).name ' number of spikes in Sample and Test does not match, or there ar non spikes'])
            end
            cd ..
        end
        cd ..
    end
    cd ..
    
end
ips_spars_table = table(name_spk,name_opr,ips_sample,ips_test,smips_sample,smips_test,spars_sample, ...
   spars_test,smspars_sample,smspars_test,nspk_orig_sample,nspk_orig_test,nspk_thr_sample,nspk_thr_test,Mean_Frate_sample,Mean_Frate_test,peakFR_sample,peakFR_test);