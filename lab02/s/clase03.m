%% 02-bonus creating a function
clear;clc;
% load('C:\Users\juana\Downloads\LFP_HG_HFO.mat')

n_cols = 1000;
n_rows = 1;
u = randi([1 30],n_rows,n_cols);

% (we created getdata.m in another script)
% running our new function
% to edit it, in the command window run
% edit getdata.m
[mean_u, median_u, max_u, min_u] = getdata(u);

%%  clase 3
%% plots


%% keywords: for, if, while

% for, enable us to create loops, in order to run the same line of codes to
% different arrays of data that we want be subject of the same kind of
% analyses
clear; clc
disp('running our for loop...')
for t = 1:10
    disp(num2str(t))
    disp(t)
    pause(.5)
end
%% let's try to run our getdata function to every row of our u matrix
% in our speaking language:
% matlab, for every row of u, i want you to run getdata and save the ouputs
% in a different variable
clear; clc;
% setting u matrix dimensions
n_cols = 1000;
n_rows = 10;

% creating u
u = randi([1 30], n_rows, n_cols);

% remembering how getdata works
% [mean_u, median_u, max_u, min_u] = getdata(u);

% so, in a horrifying naive way, we can obtain what we want by running,
% for example:
[mean_u{1},median_u{1},max_u{1},min_u{1}] = getdata(u(1,:));
[mean_u{2},median_u{2},max_u{2},min_u{2}] = getdata(u(2,:));
[mean_u{3},median_u{3},max_u{3},min_u{3}] = getdata(u(3,:));
[mean_u{4},median_u{4},max_u{4},min_u{4}] = getdata(u(4,:));
[mean_u{5},median_u{5},max_u{5},min_u{5}] = getdata(u(5,:));
[mean_u{6},median_u{6},max_u{6},min_u{6}] = getdata(u(6,:));
[mean_u{7},median_u{7},max_u{7},min_u{7}] = getdata(u(7,:));
[mean_u{8},median_u{8},max_u{8},min_u{8}] = getdata(u(8,:));
[mean_u{9},median_u{9},max_u{9},min_u{9}] = getdata(u(9,:));
[mean_u{10},median_u{10},max_u{10},min_u{10}] = getdata(u(10,:));
% so, if our matrix had 5000 rows, we should repeat this lines 5000
% times...

% instead, we just need to create a foor loop and run itiratively indexing
% the rows of our matrix

for row_of_u = 1:size(u,1)
    disp(['running our function to the row number ' num2str(row_of_u) ' of our u matrix'])
    [mean_u{row_of_u},median_u{row_of_u},max_u{row_of_u},min_u{row_of_u}] = getdata(u(row_of_u,:));
    pause(.5)
end

%%
for t = {'subject_01' 'subject_02'}
    whos t
    disp(char(t))
    disp(' ') 
    pause(2)
    
end





