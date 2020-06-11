clear
count = 0;
cd('E:\Gonzalo')
exp = dir('Exp*');
for e = 1:length(exp)
    cd(exp(e).name)
    gv = dir('GV*');
    for g = 1:length(gv)
        cd(gv(g).name)
        rec_files = dir('rec*');
        for r = 1:length(rec_files)
            cd(rec_files(r).name) 
            spk_s = dir('spk*_S_*.mat');
            spk_t = dir('spk*_T_*.mat');
            for k = 1:length(spk_s)
                load(spk_s(k).name,'t_quad','theta_obj','theta_q');
                t_quad_s = t_quad;
                theta_obj_s = theta_obj;
                theta_q = theta_q';
                clear('t_quad','theta_obj')
                load(spk_t(k).name,'t_quad','theta_obj');
                t_quad_t = t_quad;
                theta_obj_t = theta_obj;
                clear('t_quad','theta_obj')
                all_theta_obj = sort([theta_obj_s theta_obj_t]);
                diff_theta_obj = diff([0 all_theta_obj]);
                
                [~,min_dist] = min(diff_theta_obj);
                theta_obj_f = mean(all_theta_obj(min_dist - 1:min_dist));
                all_theta_obj(min_dist-1:min_dist) = [];
                
                f_s1 = find(theta_obj_s == all_theta_obj(1));
                f_s2 = find(theta_obj_s == all_theta_obj(2));
                
                if ~isempty(f_s1)
                    theta_obj_c = all_theta_obj(1);
                    theta_obj_n = all_theta_obj(2);
                else
                    theta_obj_c = all_theta_obj(1);
                    theta_obj_n = all_theta_obj(2);
                end
                
                if theta_obj_f < theta_q(1)
                    count = count + 1;
                    time_quad_fam_s(count,1) = t_quad_s(4);
                    time_quad_fam_t(count,1) = t_quad_t(4);
                elseif theta_obj_f < theta_q(2)
                    count = count + 1;
                    time_quad_fam_s(count,1) = t_quad_s(1);
                    time_quad_fam_t(count,1) = t_quad_t(1);
                elseif theta_obj_f < theta_q(3)
                    count = count + 1;
                    time_quad_fam_s(count,1) = t_quad_s(2);
                    time_quad_fam_t(count,1) = t_quad_t(2);
                else
                    count = count + 1;
                    time_quad_fam_s(count,1) = t_quad_s(3);
                    time_quad_fam_t(count,1) = t_quad_t(3);
                end
                
                if theta_obj_c < theta_q(1)
                    time_quad_c_s(count,1) = t_quad_s(4);
                    time_quad_c_t(count,1) = t_quad_t(4);
                elseif theta_obj_c < theta_q(2)
                    time_quad_c_s(count,1) = t_quad_s(1);
                    time_quad_c_t(count,1) = t_quad_t(1);
                elseif theta_obj_c < theta_q(3)
                    time_quad_c_s(count,1) = t_quad_s(2);
                    time_quad_c_t(count,1) = t_quad_t(2);
                else
                    time_quad_c_s(count,1) = t_quad_s(3);
                    time_quad_c_t(count,1) = t_quad_t(3);
                end
                
                if theta_obj_n < theta_q(1)
                    time_quad_n_s(count,1) = t_quad_s(4);
                    time_quad_n_t(count,1) = t_quad_t(4);
                elseif theta_obj_n < theta_q(2)
                    time_quad_n_s(count,1) = t_quad_s(1);
                    time_quad_n_t(count,1) = t_quad_t(1);
                elseif theta_obj_n < theta_q(3)
                    time_quad_n_s(count,1) = t_quad_s(2);
                    time_quad_n_t(count,1) = t_quad_t(2);
                else
                    time_quad_n_s(count,1) = t_quad_s(3);
                    time_quad_n_t(count,1) = t_quad_t(3);
                end
                
                t_quad_s_all = [time_quad_fam_s(count,1) time_quad_n_s(count,1) time_quad_c_s(count,1)];
                t_quad_t_all = [time_quad_fam_t(count,1) time_quad_n_t(count,1) time_quad_c_t(count,1)];
                
                for d = 1:4
                    bus = find(t_quad_s_all == t_quad_s(d));
                    if isempty(bus)
                        time_quad_e_s(count,1) = t_quad_s(d);
                    end
                    bus = find(t_quad_t_all == t_quad_t(d));
                    if isempty(bus)
                        time_quad_e_t(count,1) = t_quad_t(d);
                    end
                end
            end
            cd ..
        end
        cd ..
    end
    cd ..
end

%%
close all
time_quad = [time_quad_fam_s; time_quad_fam_t; time_quad_c_s; time_quad_c_t; ...
    time_quad_n_s; time_quad_n_t; time_quad_e_s; time_quad_e_t];
var = ones(length(time_quad_c_s),1);
id_time_quad = [var; 2*var; 3*var; 4*var; 5*var; 6*var; 7*var; 8*var];

[p,tbl,stats] = anovan(time_quad,id_time_quad);
multcompare(stats)
 

