clear

archivos = dir('GV*');
count2 = 0;
sample_test_cell = {'sample' 'test'};
for k = 2:length(archivos) % CARPETAS CON DATOS A USAR (VER VARIALE FECHAS)
    cd(archivos(k).name)
    carpeta_rec = dir('rec*OPR*');
    for n = 1:length(carpeta_rec)
        cd(carpeta_rec(n).name)
        rec_type = dir('rec*');
        for r = 1:length(rec_type)
            cd(rec_type(r).name)
            for s = 1:2
                try
                    cd(sample_test_cell{s})
                    load('resultados.mat')
                    traject_file = dir('trajectories*.mat');
                    load(traject_file.name)

                    %         'sleep')
                    avifiles = dir('*.avi');
                    mov = VideoReader(avifiles.name);
                    t_1 = (sample1 - frame_ini)/mov.FrameRate;
                    t_2 = (sample2 - frame_ini)/mov.FrameRate;
                    
                    count = 0;
                    t_acum1 = []; t_acum2 = [];
                    bin_eje = 0:30:660;
                    for d = bin_eje
                        count = count + 1;
                        t_acum1(count) = length(t_1(t_1 < d))/mov.FrameRate;
                        t_acum2(count) = length(t_2(t_2 < d))/mov.FrameRate;
                    end
                    count2 = count2 + 1;
                    test(count2,1) = s - 1;
                    
                    %%%%%%%%%%%%%%%%%%%%% CUANDO NO HAY DIFERENCIA POSICION  %%%%%%%%%
                    tiempo_acum_1(count2,:) = t_acum1;
                    tiempo_acum_2(count2,:) = t_acum2;
                    animal{count2,1} = archivos(k).name;
                    registro{count2,1} = carpeta_rec(n).name;
                    disp(archivos(k).name)
                    disp(carpeta_rec(n).name)
                    s_ns(count2,1) = input('sleep? 1(sleep) 0(no sleep) = ');
                    clc
                    sleep = s_ns(count2,1);
                    sample_test = sample_test_cell{s};
                    save(traject_file.name, 'trajectories', 'trajectories2', ...
                        'probtrajectories', 'frame_ini','frame_fin','lim_interp','sleep','sample_test')
                    clearvars ('trajectories', 'trajectories2', 'probtrajectories', 'frame_ini','frame_fin','lim_interp','sleep','sample_test')
                    cd ..
                end
            end
            cd ..
        end
        cd ..
    end
    cd ..
end
close all
%% Por tipo de test
cond = logical(tipo_test);
t1_encoding = tiempo_acum_1(~cond,:);
t2_encoding = tiempo_acum_2(~cond,:);
figure
subplot(221); 
plot(bin_eje,mean(t1_encoding,1))
hold on
plot(bin_eje,mean(t2_encoding,1),'r')
legend({'Fam. Object1','Fam. Object2'})
xlabel('time (s)')
ylabel('Exploration (s)')
title('Encoding all rats')
axis([0 660 0 50])

t1_retrieval = tiempo_acum_1(cond,:);
t2_retrieval = tiempo_acum_2(cond,:);

subplot(222); 
plot(bin_eje,mean(t1_retrieval,1))
hold on
plot(bin_eje,mean(t2_retrieval,1),'r')
legend({'Novel Object','Fam. Object'})
xlabel('time (s)')
title('Retrieval all rats')
axis([0 660 0 50])

cond = logical(tipo_test);
t1_encoding = tiempo_acum_1(~cond,:);
t2_encoding = tiempo_acum_2(~cond,:);

subplot(223); 
plot(bin_eje,mean((t1_encoding - t2_encoding)./(t1_encoding + t2_encoding),1))
xlabel('time (s)')
ylabel('Exp. INDEX')
title('Encoding all rats')
axis([0 660 -.2 .3])

t1_retrieval = tiempo_acum_1(cond,:);
t2_retrieval = tiempo_acum_2(cond,:);

subplot(224); 
plot(bin_eje,mean((t1_retrieval - t2_retrieval)./(t1_retrieval + t2_retrieval),1))
xlabel('time (s)')
title('Retrieval all rats')
axis([0 660 -.2 .3])

%% separados por sueño y no sueño (SUEÑO)
cond = s_ns == 2;
t1_encoding_sleep = tiempo_acum_1(~tipo_test & cond,:);
t2_encoding_sleep = tiempo_acum_2(~tipo_test & cond,:);

figure
subplot(221); 
plot(bin_eje,mean(t1_encoding_sleep,1))
hold on
plot(bin_eje,mean(t2_encoding_sleep,1),'r')
legend({'Fam. Object1','Fam. Object2'})
xlabel('time (s)')
ylabel('Exploration (s)')
title('Encoding Sleep rats')
axis([0 660 0 50])

t1_retrieval_sleep = tiempo_acum_1(tipo_test & cond,:);
t2_retrieval_sleep = tiempo_acum_2(tipo_test & cond,:);

subplot(222); 
plot(bin_eje,mean(t1_retrieval,1))
hold on
plot(bin_eje,mean(t2_retrieval,1),'r')
legend({'Novel Object','Fam. Object'})
xlabel('time (s)')
title('Retrieval Sleep rats')
axis([0 660 0 50])

t1_encoding_sleep = tiempo_acum_1(~tipo_test & cond,:);
t2_encoding_sleep = tiempo_acum_2(~tipo_test & cond,:);
index_encoding_sleep = (t1_encoding_sleep - t2_encoding_sleep)./(t1_encoding_sleep + t2_encoding_sleep);

subplot(223); 
plot(bin_eje,mean(index_encoding_sleep,1))
xlabel('time (s)')
ylabel('Exp. INDEX')
title('Encoding all rats')
axis([0 660 -.2 .6])

t1_retrieval_sleep = tiempo_acum_1(tipo_test & cond,:);
t2_retrieval_sleep = tiempo_acum_2(tipo_test & cond,:);
index_retrieval_sleep = (t1_retrieval_sleep - t2_retrieval_sleep)./(t1_retrieval_sleep + t2_retrieval_sleep);
subplot(224); 
plot(bin_eje,mean(index_retrieval_sleep,1))
xlabel('time (s)')
title('Retrieval sleep rats')
axis([0 660 -.2 .6])

%% separados por sueño y no sueño (NO SUEÑO)
cond = s_ns == 1;
t1_encoding_no_sleep = tiempo_acum_1(~tipo_test & cond,:);
t2_encoding_no_sleep = tiempo_acum_2(~tipo_test & cond,:);

figure
subplot(221); 
plot(bin_eje,mean(t1_encoding_no_sleep,1))
hold on
plot(bin_eje,mean(t2_encoding_no_sleep,1),'r')
legend({'Fam. Object1','Fam. Object2'})
xlabel('time (s)')
ylabel('Exploration (s)')
title('Encoding NO sleep rats')
axis([0 660 0 50])

t1_retrieval_no_sleep = tiempo_acum_1(tipo_test & cond,:);
t2_retrieval_no_sleep = tiempo_acum_2(tipo_test & cond,:);

subplot(222); 
plot(bin_eje,mean(t1_retrieval_no_sleep,1))
hold on
plot(bin_eje,mean(t2_retrieval_no_sleep,1),'r')
legend({'Novel Object','Fam. Object'})
xlabel('time (s)')
title('Retrieval NO sleep rats')
axis([0 660 0 50])

t1_encoding_no_sleep = tiempo_acum_1(~tipo_test & cond,:);
t2_encoding_no_sleep = tiempo_acum_2(~tipo_test & cond,:);

index_encoding_no_sleep = (t1_encoding_no_sleep - t2_encoding_no_sleep)./(t1_encoding_no_sleep + t2_encoding_no_sleep);

subplot(223); 
plot(bin_eje,mean(index_encoding_no_sleep,1))
xlabel('time (s)')
ylabel('Exp. INDEX')
title('Encoding all rats')
axis([0 660 -.2 .6])

t1_retrieval_no_sleep = tiempo_acum_1(tipo_test & cond,:);
t2_retrieval_no_sleep = tiempo_acum_2(tipo_test & cond,:);
index_retrieval_no_sleep = (t1_retrieval_no_sleep - t2_retrieval_no_sleep)./(t1_retrieval_no_sleep + t2_retrieval_no_sleep);

subplot(224); 
plot(bin_eje,mean(index_retrieval_no_sleep,1))
xlabel('time (s)')
title('Retrieval NO sleep rats')
axis([0 660 -.2 .6])

%% Index statistics
p = nan(size(index_retrieval_sleep,2),1);
p_retrie_no_sleep = nan(size(index_retrieval_sleep,2),1);
p_retrie_sleep = nan(size(index_retrieval_sleep,2),1);

for k = 1:size(index_retrieval_sleep,2)
    try
        p(k) = ranksum(index_retrieval_sleep(:,k),index_retrieval_no_sleep(:,k));
        p_retrie_sleep(k) = signrank(index_retrieval_sleep(:,k),0);
        p_retrie_no_sleep(k) = signrank(index_retrieval_no_sleep(:,k),0);
    end
    error_index_sleep(k,1) = std(index_retrieval_sleep(:,k))/sqrt(length(index_retrieval_sleep(:,k)));
    error_index_no_sleep(k,1) = std(index_retrieval_no_sleep(:,k))/sqrt(length(index_retrieval_no_sleep(:,k)));
end

figure
plot(bin_eje,mean(index_retrieval_sleep,1),'k','linewidth',2)
hold on
plot(bin_eje,mean(index_retrieval_no_sleep,1),'r','linewidth',2)
shadedErrorBar(bin_eje,mean(index_retrieval_sleep,1),error_index_sleep,{'k'},1)
shadedErrorBar(bin_eje,mean(index_retrieval_no_sleep,1),error_index_no_sleep,{'r'},1)
alpha .3
if ~isempty(bin_eje(p < 0.05))
plot(bin_eje(p < 0.05),0.6,'m*')
end
if ~isempty(bin_eje(p_retrie_sleep < 0.05))
plot(bin_eje(p_retrie_sleep < 0.05),-.2,'k*')
end
if ~isempty(bin_eje(p_retrie_no_sleep < 0.05))
plot(bin_eje(p_retrie_no_sleep < 0.05),-.3,'r*')
end
ylim([-.4 1])
title('Exp. Index during Retreival')
legend({'Sleep' 'No sleep'})

figure
plot(bin_eje,mean(index_encoding_sleep,1),'k','linewidth',2)
hold on
plot(bin_eje,mean(index_encoding_no_sleep,1),'r','linewidth',2)
shadedErrorBar(bin_eje,mean(index_encoding_sleep,1),error_index_sleep,{'k'},1)
hold on
shadedErrorBar(bin_eje,mean(index_encoding_no_sleep,1),error_index_no_sleep,{'r'},1)
alpha .3
ylim([-.4 1])

p_encod_sleep = nan(size(index_retrieval_sleep,2),1);
p_encod_no_sleep = nan(size(index_retrieval_sleep,2),1);

for k = 1:size(index_retrieval_sleep,2)
    try
        p_encod_sleep(k) = signrank(index_encoding_sleep(:,k),0);
        p_encod_no_sleep(k) = signrank(index_encoding_no_sleep(:,k),0);
    end
end
if ~isempty(bin_eje(p_encod_sleep < 0.05))
plot(bin_eje(p_encod_sleep < 0.05),-.2,'k*')
end
if ~isempty(bin_eje(p_encod_no_sleep < 0.05))
plot(bin_eje(p_encod_no_sleep < 0.05),-.3,'r*')
end
title('Exp. Index during Encoding')
legend({'Sleep' 'No sleep'})


%% GRAFICA LA DIFERENCIA DE EXPLORACION

delta_grupo_sleep = t1_retrieval_sleep - t2_retrieval_sleep;
delta_grupo_nosleep = t1_retrieval_nosleep - t2_retrieval_nosleep;

figure
subplot(121); boxplot(delta_grupo_sleep(:,1:11),0:30:300)
ylabel('\delta Exploration (s)')
title('Sleep Group')
xlabel('Time (s)')
ylim([-5 22])
subplot(122); boxplot(delta_grupo_nosleep(:,1:11),0:30:300)
xlabel('Time (s)')
title('NO Sleep Group')
ylim([-5 22])

for k = 1:11
    p_0_sleep(k) = ranksum(delta_grupo_sleep(:,k),0);
    p_0_nosleep(k) = ranksum(delta_grupo_nosleep(:,k),0);
    p_sleep_ns(k) = ranksum(delta_grupo_sleep(:,k),delta_grupo_nosleep(:,k));
end 