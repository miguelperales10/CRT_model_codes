function OS = virt_trial_figures(N,QT_dosis,RT_dosis,delta_ED)
tic
% Num de virt patients
%  N = 500
% 
% % Tratamiento. El Stupp sería:
% RT_dosis = [1:5, 8:12, 15:19, 22:26, 29:33, 36:40];
% QT_ady = [70.02:75.02,70.04:75.04, 98.02:104.02,98.04:104.04, 126.02:131.02,126.04:131.04, 154.02:159.02,154.04:159.04, 182.02:187.02,182.04:187.04, 210.02:215.02,210.04:215.04];
% QT_dosis = [1.02:42.02, QT_ady];
% 
% vector de OS:



% Volúmenes iniciales y de muerte
% vol_in_dist = normrnd(20, 5, [N,1]);
% death_threshold_dist = normrnd(260, 20, [N,1]); % 280 Thibault
vol_in = 50;
death_threshold = 280;

% Parámetros:
% [normal, mu_p, sigma_p] = plos_fit_par;
% De momento sólo la media:
alpha_QT = 0.4469;
beta_SP = 0.3560;
beta_PR = 0.0697;

% % Parámetros:
param_dist = zeros(N, 15);

% Control:
ki67 = 0.1 + (0.5-0.1).*rand(N,1);
%param_dist(:,1) = 1e-03+(1e-02-1e-03).*rand(N,1); % rho_S %1e-01 en GMBs, 1e-02 en LGG
param_dist(:,1) = 1e-03+(1e-01-1e-03).*rand(N,1); % rho_S %1e-01 en GMBs, 1e-02 en LGG
param_dist(:,2) = ki67.*param_dist(:,1);               % rho_R
param_dist(:,3) = 0.2+(0.6-0.2).*rand(N,1);       % mu_SQ
param_dist(:,4) = ki67.*(param_dist(:,3)./(1-ki67)-param_dist(:,1)); % mu_QS
param_dist(:,5) = 0.1; % mu_PS     ¡¡¡¡¡¡0.2 en el N.onc.Adv. y 0.1 en el plos!!!!!!
param_dist(:,6) = ki67;

% RT:
param_dist(:,7) = rand(N,1);        % gamma
param_dist(:,8) = 0.5.*rand(N,1);        % alphaRT_S  (¿¿cota sup.??)
param_dist(:,9) = ki67.*param_dist(:,8); % alphaRT_R
param_dist(:,10) = param_dist(:,1)./10 + (param_dist(:,1)-param_dist(:,1)./10).*rand(N,1); % alphaRT_R


% TMZ (Plos):
param_dist(:,11) = 0.3560;         % beta_SP
param_dist(:,12) = 0.0697;         % beta_PR
param_dist(:,13) = 0.4469;         % alpha_QT
param_dist(:,14) = 8.31;           % lambda
param_dist(:,15) = delta_ED;       % delta_ED


% param_dist(:,1) = normrnd(0.3, 0.01/10, [N,1]);        % rho_S
% param_dist(:,2) = normrnd(0.1, 0.004/10, [N,1]);      % rho_R
% param_dist(:,3) = normrnd(0.4, 0.1, [N,1]);          % mu_SQ
% param_dist(:,4) = normrnd(0.015, 0, [N,1]);          % mu_QS
% param_dist(:,5) = normrnd(0.2, 0    , [N,1]);          % mu_PS
% param_dist(:,6) = normrnd(0.35, 0, [N,1]);          % ki67
% param_dist(:,7) = normrnd(0.5, 0.2, [N,1]);          % gamma
% param_dist(:,8) = normrnd(0.5, 0.2, [N,1]);        % alphaRT_S
% param_dist(:,9) = normrnd(0.5*0.4, 0.2*0.4, [N,1]);        % alphaRT_R
% param_dist(:,10) = normrnd(0.05, 0.005/10, [N,1]);       % tau
% param_dist(:,11) = normrnd(48, 0, [N,1]);         % beta_SP
% param_dist(:,12) = normrnd(16, 0, [N,1]);         % beta_PR
% param_dist(:,13) = normrnd(0.5, 0.05/10, [N,1]);       % alpha_QT
% param_dist(:,14) = normrnd(8.31, 0, [N,1]);       % lambda
% param_dist(:,15) = normrnd(1, 0, [N,1]);          % delta_ED



%% Simulamos el virt trial
OS = zeros(N,1);
for i = 1:N
    parametros = param_dist(i,:);

    OS_months = simulacion_tto_QRT_figures(vol_in,death_threshold, ...
                                   RT_dosis,QT_dosis,parametros);
    
    OS(i) = OS_months;
    
end


toc

end
