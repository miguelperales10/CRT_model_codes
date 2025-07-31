function OS = virt_trial_figures_repr(N,QT_dosis,RT_dosis,delta_ED)
tic

OS = [];

vol_in = 50;
death_threshold = 280;

param_dist = zeros(N, 15);

% Fixed for representative patients:
ki67 = 0.3;
param_dist(1:4,1) = 4e-02; param_dist(5:8,1) = 7e-02; 
param_dist(:,2) = ki67.*param_dist(:,1);               
param_dist(:,3) = [.35 .35 .6 .6 .35 .35 .6 .6];  % mu_SQ
param_dist(:,4) = ki67.*(param_dist(:,3)./(1-ki67)-param_dist(:,1)); % mu_QS
param_dist(:,5) = 0.1; % mu_PS   
param_dist(:,6) = ki67;
% RT:
param_dist(1:2:end-1,7) = .4; param_dist(2:2:end,7) = .8;    % gamma
param_dist(:,8) = 0.35; % alphaRT_S 
param_dist(:,9) = ki67.*param_dist(:,8); % alphaRT_R
param_dist(:,10) = 0.4; % alphaRT_R
% TMZ:
param_dist(:,11) = 0.3560;         % beta_SP
param_dist(:,12) = 0.0697;         % beta_PR
param_dist(:,13) = 0.4469;         % alpha_QT
param_dist(:,14) = 8.31;           % lambda
param_dist(:,15) = delta_ED;       % delta_ED


%% Simulations
OS = zeros(N,1);
for i = 1:N
    parametros = param_dist(i,:);

    OS_months = simulacion_tto_QRT_figures(vol_in,death_threshold, ...
                                   RT_dosis,QT_dosis,parametros);
    
    OS(i) = OS_months;
    
end


toc

end
