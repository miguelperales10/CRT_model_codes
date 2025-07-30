function [t,pops] = simul_combined_CRT(p_in,param,RT_dosis,CT_dosis,t_after_treatment)

t=[];               % time vector
t_span_dif = 0.001; % t_span for ode solver

%% Our parameters:
% rho_S = param(1);
% mu_PQ = param(2);
% tau = param(3);
 alpha_RT = param(4);
 gamma = param(5);
% vol_in = param(6);
% alpha_E_D = param(7);
first_RT= min(RT_dosis);
first_CT= min(CT_dosis);
ki67 = 0.1;

%% CRT combined treatment:
idx_tto=1;
combined_tto=union(RT_dosis,CT_dosis);
n_tto=length(combined_tto);

%% Solve ODE until first treatment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
t_in = 0; 
t_f = min(first_RT,first_CT); % 1st treatment

[t1,y1] = ode45(@(t,y)CRT_eqs(t,y,param([1:3,7])),t_in: t_span_dif : t_f, p_in');

t=[t;t1];
S = y1(:,1);  % sens S
PI = y1(:,2); % initial pers PI
P = y1(:,3);  % fully pers P
R = y1(:,4);  % resist R
Q = y1(:,5);  % quiesc Q
D = y1(:,6);  % damaged D
T = y1(:,7);  % tmz eff E_D
p_in = [S(end), PI(end), P(end), R(end), Q(end), D(end), T(end)];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i=1:n_tto

    t_tto=combined_tto(idx_tto);

    if any(RT_dosis==t_tto) % RT treatment
        % Damaged cells:
        p_in(6) = p_in(6) + alpha_RT*p_in(1) + alpha_RT*p_in(4)*ki67; 
        % Drug-resistant cells damaged by RT:
        p_in(4)=(1-alpha_RT*ki67)*p_in(4); 
        % Drug-sensitive cells damaged by RT and accelerated repop.:
        p_in(1) = (1-alpha_RT)*p_in(1) + gamma*p_in(5); 
        % Quiescent cells induced to proliferate by RT: 
        p_in(5) = (1-gamma)*p_in(5); 

    elseif any(CT_dosis==t_tto) % TMZ treatment
        p_in(7) = p_in(7) + 1/3; % Aument in 1/3 TMZ drug eff (1 dose)
    end

    if idx_tto<n_tto
        t_in = t_tto; 
        idx_tto=idx_tto+1;
        t_tto=combined_tto(idx_tto);
        t_f = t_tto; % t_final
        
        if t_f-t_in<t_span_dif
            t_f=t_in+t_span_dif;
        else
            [t1,y1] = ode45(@(t,y)CRT_eqs(t,y,param([1:3,7])),t_in: t_span_dif : t_f, p_in');
            t=[t;t1];
            S = y1(:,1);  % sens S
            PI = y1(:,2); % initial pers PI
            P = y1(:,3);  % fully pers P
            R = y1(:,4);  % resist R
            Q = y1(:,5);  % quiesc Q
            D = y1(:,6);  % damaged D
            T = y1(:,7);  % tmz eff E_D
            p_in = [S(end), PI(end), P(end), R(end), Q(end), D(end), T(end)];
        end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end
end

% Final phase: simulation without treatment (it'sconcluded)

% Update tspan
t_in = t_f;               
t_f = t_in+t_after_treatment;  

[t1,y1] = ode45(@(t,y)CRT_eqs(t,y,param([1:3,7])),t_in: t_span_dif : t_f, p_in');
t=[t;t1];
S = y1(:,1);  % sens S
PI = y1(:,2); % initial pers PI
P = y1(:,3);  % fully pers P
R = y1(:,4);  % resist R
Q = y1(:,5);  % quiesc Q
D = y1(:,6);  % damaged D
T = y1(:,7);  % tmz eff E_D
pops = [S,PI,P,R,Q,D,T];
end

