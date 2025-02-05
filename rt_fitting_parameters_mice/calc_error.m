function error = calc_error(parameters)
% Calculates the error with respect to the data based on the input parameters:

%% Our parameters (reminder):
% The 4 parameters to be adjusted are beta1, alpha_RT, gamma, and tau. 
% The mouse number is also passed as a parameter.
% rho = parameters(1); already fitted
% PQ = parameters(2);
% tau = parameters(3); %----------------------THESE 3 GO INTO THE ODE
%  alpha_RT = parameters(4);
%  gamma = parameters(5);
% mouse_number = parameters(end);


%% Longitudinal Data:
num_mouse = round(parameters(end));
[data,first_RT] = invivo_IVIS_data(num_mouse);


%% TREATMENT. Fixed for RT-test experiments
t_after_RT = 60; % days after last RT session
spacing = 1;     % days between consecutive RT sessions
dose = 3;        % number of RT sessions

% The assumed Ki67 value is 0.1 in SVZ EGFR-wt animal model. 
ki67 = 0.1;

% Initial population to maintain Ki-67 at a 10% rate:
p_in = [ki67*data(2,1),(1-ki67)*data(2,1), 0]; 


%% SIMULATING THE ENTIRE THERAPY: %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[t,populations] = simulacion_tto(p_in,parameters,first_RT,t_after_RT,spacing,dose);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Subpopulations:
S = populations(:,1);
Q = populations(:,2);
D = populations(:,3);
total = S+Q+D;


%% Computing the errors for each data point and the total error %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
error = 0;

for i = 1:length(data)
        j = find( abs(t-data(1,i)) <= 0.1, 1 );
        % Relative error for each data point:
        error = error + (abs(data(2,i) - total(j))/data(2,i));; 
end

error = (error/length(data));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end
