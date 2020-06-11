clear
cd('E:\Gonzalo')
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
            file_s = dir('spk*_S_*');
            file_t = dir('spk*_T_*');
            for n = 1:length(file_s)
                count = count + 1;
                name_file_s{count,1} = file_s(n).name;
                load(file_s(n).name,'Mean_Frate','peakFR','smips','smspars');
                mfrate_s(count,1) = Mean_Frate;
                peakfr_s(count,1) = peakFR;
                smips_s(count,1) = smips;
                smspars_s(count,1) = smspars;
                clear('Mean_Frate','peakFR','smips','smspars');
                load(file_t(n).name,'Mean_Frate','peakFR','smips','smspars');
                name_file_t{count,1} = file_t(n).name;
                load(file_t(n).name,'Mean_Frate','peakFR','smips','smspars');
                mfrate_t(count,1) = Mean_Frate;
                peakfr_t(count,1) = peakFR;
                smips_t(count,1) = smips;
                smspars_t(count,1) = smspars;
                location{count,1} = pwd;
                clear('Mean_Frate','peakFR','smips','smspars');
            end
            cd ..
        end
        cd ..
    end
    cd ..
end
result = table(name_file_s,mfrate_s,peakfr_s,smips_s,smspars_s,name_file_t,mfrate_t,peakfr_t,smips_t,smspars_t,location);
save('spat_features','result')
%% classification
clear
load('spat_features.mat')
mfrate_thr = 0;
peak_thr = 0.4;
smips_thr = 0.25;
smspars = 0.45;

neuron = result.name_file_s;
class = result.mfrate_s > mfrate_thr & result.peakfr_s > peak_thr & result.smips_s > smips_thr & result.smspars_s < smspars;

result_place_cell = table(result.name_file_s(class),result.mfrate_s(class), ...
    result.peakfr_s(class),result.smips_s(class),result.smspars_s(class), ...
    result.name_file_t(class),result.mfrate_t(class),result.peakfr_t(class), ...
    result.smips_t(class),result.smspars_t(class),result.location(class));

result_no_place_cell = table(result.name_file_s(~class),result.mfrate_s(~class), ...
    result.peakfr_s(~class),result.smips_s(~class),result.smspars_s(~class), ...
    result.name_file_t(~class),result.mfrate_t(~class),result.peakfr_t(~class), ...
    result.smips_t(~class),result.smspars_t(~class),result.location(~class));
save('spat_features','result','result_place_cell','result_no_place_cell')

%% sleep / no sleep

clear
cd('E:\Gonzalo')
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
            fle = pwd;
            sleep = input([fle '      Sleep(1) No sleep(0) = ']);
            file_s = dir('spk*_S_*');
            file_t = dir('spk*_T_*');
            for n = 1:length(file_s)
                save(file_s(n).name,'sleep','-append')
                save(file_t(n).name,'sleep','-append')
            end
            clear sleep
            cd ..
        end
        cd ..
    end
    cd ..
end