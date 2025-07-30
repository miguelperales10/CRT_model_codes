function OS = my_model(param)
t_span_dif = 0.001;

% Parameters:
pop_in = param(6);         % initial tumor volume, V_0
delta_RT = param(8);       % Space between RT doses
delta_TMZ = param(9);      % Space between TMZ doses
delta_start = param(10);   % RT-TMZ iniciation offset
ki67 = 0.1;                % Percentage of actively proliferating cells
p_in = [pop_in*ki67, 0, 0 ,0, pop_in*(1-ki67), 0,0]; % Prolif and quiesc cells

% Treatment schedule:
treat_start = 4;

if delta_start >=0 % If RT starts before
 RT_treat = [treat_start, treat_start+delta_RT, treat_start+2*delta_RT];
 CT_treat = [treat_start+delta_start, treat_start+delta_start+delta_TMZ, treat_start+delta_start+2*delta_TMZ];
 CT_treat = [CT_treat, CT_treat+0.2, CT_treat+0.4]; CT_treat = sort(CT_treat);
else               % If CT starts before
 RT_treat = [treat_start-delta_start, treat_start-delta_start+delta_RT, treat_start-delta_start+2*delta_RT];
 CT_treat = [treat_start, treat_start+delta_TMZ, treat_start+2*delta_TMZ];
 CT_treat = [CT_treat, CT_treat+0.2, CT_treat+0.4]; CT_treat = sort(CT_treat);
end

% Simulation after treatment finishes
 t_after_treat =  200;

% Solve ODEs
[t,pops] = simul_combined_CRT(p_in,param,RT_treat,CT_treat,t_after_treat);

% Update subpops
S = pops(:,1); PI = pops(:,2); P = pops(:,3); R = pops(:,4);
Q = pops(:,5); D = pops(:,6);  T = pops(:,7); 
total = S+PI+P+R+Q+D;

% OS when tumor volume reaches the fatal burden
IVIS_death = 0.3e+08;
r = find (total >= IVIS_death, 1);
% OS too large are truncated
if isempty(r) 
    OS = t_after_treat + CT_treat(end);
else
OS = r*t_span_dif;

end
