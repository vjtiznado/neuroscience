function [spat_cohe, spat_coheR, n_pfields] = spatial_cohe(sfrmap,socmap,lim_zero,lim_pfields)
% lim_zero = number the bins with zero of ocupance

lim_r = size(socmap,1);
lim_c = size(socmap,2);
count = 0;
sc_val = [];
real_val = [];
n_pfields = 0;
for r = 2:lim_r - 1
    for c = 2:lim_c - 1
        neigh = socmap(r - 1:r + 1,c - 1:c + 1);
        fr_neigh = sfrmap(r - 1:r + 1,c - 1:c + 1);
        if length(find(neigh == 0)) <= lim_zero
            count = count + 1;
            sc_val(count,1) = mean(mean(fr_neigh));
            real_val(count,1) = fr_neigh(2,2);
        end
%         if sum(sum(fr_neigh)) > 0
%         fr_neigh
%         pause
%         end
        if fr_neigh(2,2) >= lim_pfields & sum(sum(fr_neigh > 0.5*lim_pfields)) == 9 - lim_zero
            n_pfields = n_pfields + 1;
        end
    end
end
spat_coheR = corr(real_val,sc_val);
spat_cohe = 0.5*log((1 + spat_coheR)/(1 - spat_coheR));
