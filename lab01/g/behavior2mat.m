%% to create a struct of the behavior of the animal
% * sacando los NaN

% clear all

ratt(1).behavior = xlsread('behavior1.xlsx','SB29');
ratt(2).behavior = xlsread('behavior1.xlsx','SB32');
ratt(3).behavior = xlsread('behavior1.xlsx','SB33');

for n_rat = 1:size(ratt,2)
    for n_sessions = 1:length(ratt(n_rat).behavior(1,:))
        
        b_ses = ratt(n_rat).behavior(:,n_sessions);
        b_ses(isnan(b_ses)) = [];    
        ses_cell = mat2cell(b_ses);
        rat_trials(n_rat).b_sessions{n_sessions,1} = ses_cell{1,1};
        
    end    
end










