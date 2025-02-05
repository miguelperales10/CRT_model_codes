function OS_months = OS_treat_QRT(vol_in,death_threshold,RT_dosis,QT_dosis,parametros)

% Calculate OS of virtual patients (months) depending on parameters, 
% treatment, initial tumor volume, and fatal tumor volume

% Actively proliferative cells rate (%)
ki67 = parametros(6);

% Initial subpopulations
p_in = [vol_in*ki67, 0, 0, 0, vol_in*(1-ki67), 0, 0];

% Follow up virtual patient after treatment (days)
t_despues_tto = 3650; 

%% Run the simulation
[t,poblaciones] = CRT_treatment_sim(p_in,parametros,RT_dosis,QT_dosis,t_despues_tto);

% Update subpopulations
S = poblaciones(:,1); % sensitive, actively proliferative
PI = poblaciones(:,2); % persisters PI
P = poblaciones(:,3); % persisters P
R = poblaciones(:,4); % resistants
Q = poblaciones(:,5); % quiescents
D = poblaciones(:,6); % damaged
E_D = poblaciones(:,7); % drug efficacy
total = S+PI+P+R+Q+D;

%% Calculate OS (months)
r = find( abs(total-death_threshold) <= death_threshold/100,1);

if size(r) >= 1  
OS_months = r*0.001/30; % where 0.001 is \Delta t used in ode45 solver (Months)
else
OS_months = 8000; % If a patient is alive after ending the follow up
end

end


