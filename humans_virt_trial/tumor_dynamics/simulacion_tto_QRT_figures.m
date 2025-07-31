function OS_months = simulacion_tto_QRT_figures(vol_in,death_threshold,RT_dosis,CT_dosis,param)

ki67 = param(6);
p_in = [vol_in*ki67, 0, 0, 0, vol_in*(1-ki67), 0, 0];
t_despues_tto = 4000;

%% Tumor evolution simulation
[t,poblaciones] = tto_QRT(p_in,param,RT_dosis,CT_dosis,t_despues_tto);

% Subpops
S = poblaciones(:,1); % sens S
PI = poblaciones(:,2); % persisters PI
P = poblaciones(:,3); % fully pers P
R = poblaciones(:,4); % resist R
Q = poblaciones(:,5); % quiesc Q
D = poblaciones(:,6); % damaged D
E_D = poblaciones(:,7); % tmz 
total = S+PI+P+R+Q+D;

%% Calculate OS
r = find( abs(total-death_threshold) <= death_threshold/100,1);

if size(r) >= 1  
OS_months = r*0.001/30; % where 0.001 is \Delta t used in ode45 solver (Months)
else
OS_months = 4000;
end

% Plot it
plot(t,total,'LineWidth',1.5)
hold on


end


