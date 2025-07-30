% Citation: Cannavo' F., Sensitivity analysis for volcanic source modeling quality assessment and model selection, Computers & Geosciences, Vol. 44, July 2012, Pages 52-59, ISSN 0098-3004, http://dx.doi.org/10.1016/j.cageo.2012.03.008.

clear
clc
tic
% create a new project 
pro = pro_Create();

%% Input variables
% add to the project input variables, named param*, distributed in a 
% range and indicate that the variables will be sampled following a 
% Sobol set 

% proliferation rate, rho
pro = pro_AddInput(pro, @()pdf_Sobol([0 3]), 'param1'); 

% transition rate from sensitive to quiescent, mu_{SQ}
pro = pro_AddInput(pro, @()pdf_Sobol([0 3]), 'param2');

% damaged population elimination rate, tau
pro = pro_AddInput(pro, @()pdf_Sobol([0 6]), 'param3');

% fraction of sensitive population damaged by RT, alpha_{RT}
pro = pro_AddInput(pro, @()pdf_Sobol([0 1]), 'param4');

% fraction of quiescent population induced to proliferate by RT, gamma
pro = pro_AddInput(pro, @()pdf_Sobol([0 1]), 'param5');

% initial tumor volume, V_0
pro = pro_AddInput(pro, @()pdf_Sobol([10^3 5*10^4]), 'param6'); 

% TMZ killing efficiency alpha_{E_D}
pro = pro_AddInput(pro, @()pdf_Sobol([0 1000]), 'param7'); 

% Space between RT doses 
pro = pro_AddInput(pro, @()pdf_Sobol([1 15]), 'param8'); 

% Space between TMZ doses
pro = pro_AddInput(pro, @()pdf_Sobol([1 15]), 'param9'); 

% RT-TMZ iniciation offset
pro = pro_AddInput(pro, @()pdf_Sobol([-15 15]), 'param10'); 


%% model
% set the model, and name it as 'model', to the project 
% the model is well-known as "Sobol function" 
pro = pro_SetModel(pro, @(x)my_model(x), 'model'); 

%% Calculate Sobol indices
% set the number of samples for the quasi-random Monte Carlo simulation
% On our computational setup, simulating N = 20000 instances takes approximately 3 days.
pro.N = 20000; 

% initialize the project by calculating the model at the sample points
pro = GSA_Init(pro);

% calculate the first order global sensitivity coefficients by using FAST
% algorithm
Sfast = GSA_FAST_GetSi(pro);

% calculate the first order global sensitivity coefficient for the subset {n_1,...,n_l}
% of input variables. Verify that equals 1 if all parameters are included. If only a
% parameter is inclued (e.g. "...pro, {1}, ...", verify the result is the
% same obtained with the FAST algorithm.
[S1 eS1 pro] = GSA_GetSy(pro, {1}, 1); 

% calculate the total global sensitivity coefficient for the subset {n_1,...,n_l}
% of input variables
[Stot eStot pro] = GSA_GetTotalSy(pro, {1},1);

toc