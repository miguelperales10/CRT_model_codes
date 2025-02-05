function [t,poblaciones] = CRT_treatment_sim(p_in,parametros,RT_dosis,QT_dosis,t_despues_tto)

% Vector de tiempo
t=[]; 

% Dosis de QT y RT 
primera_RT= min(RT_dosis);
primera_QT= min(QT_dosis);
idx_tto=1;
combined_treat=union(RT_dosis,QT_dosis);
n_tto=length(combined_treat);

%% All parameters. Some of them are not used in the ODE. 
rho_S = parametros(1);
rho_R = parametros(2);
mu_SQ = parametros(3);
mu_QS = parametros(4);
mu_PS = parametros(5);
ki67  = parametros(6); 
gamma = parametros(7); 
alphaRT_S = parametros(8); 
alphaRT_R = parametros(9); 
tau = parametros(10);
beta_SP = parametros(11);
beta_PR = parametros(12);
alphaQT = parametros(13);
lambda  = parametros(14);
delta_ED = parametros(15); 
 


%% Solving ODE system before first treatment %%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
t_in = 0; 
t_f = min(primera_RT,primera_QT); % First RT/drug administration

[t1,y1] = ode45(@(t,y)eqs_CRT(t,y,parametros),t_in: 0.001 : t_f, p_in');

t=[t;t1];
S = y1(:,1); % sensitive
PI = y1(:,2); % persisters PI
P = y1(:,3); % persisters P
R = y1(:,4); % resistants
Q = y1(:,5); % quiescents
D = y1(:,6); % damaged
E_D = y1(:,7); % drug efficacy

% Update subpopulations
p_in = [S(end), PI(end), P(end), R(end), Q(end), D(end), E_D(end)];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i=1:n_tto

    t_tto=combined_treat(idx_tto);

            if any(RT_dosis==t_tto) 

            % RT pulse:
                % Damaged
                p_in(6) = p_in(6) + alphaRT_S*p_in(1) + alphaRT_R*p_in(4)*ki67; 
                % TMZ-Resistant
                p_in(4) = (1-alphaRT_R)*p_in(4);                   
                % TMZ-Sensitive
                p_in(1) = (1-alphaRT_S)*p_in(1) + gamma*p_in(5);   
                % Quiescent
                p_in(5) = (1-gamma)*p_in(5);                       

            elseif any(QT_dosis==t_tto)
            % Drug pulse. Increase E_D at a rate delta_ED (1 dosis)
                p_in(7) = p_in(7) + delta_ED; 
            end


            if idx_tto<n_tto
            t_in = t_tto; 
            idx_tto=idx_tto+1;
            t_tto=combined_treat(idx_tto);
            t_f = t_tto; 
            
            [t1,y1] = ode45(@(t,y)eqs_CRT(t,y,parametros),t_in: 0.001 : t_f, p_in');
            t=[t;t1];
            S = [S;y1(:,1)]; % sensitive
            PI = [PI;y1(:,2)]; % persisters PI
            P = [P;y1(:,3)]; % persisters P
            R = [R;y1(:,4)]; % resistants
            Q = [Q;y1(:,5)]; % quiescents
            D = [D;y1(:,6)]; % damaged
            E_D = [E_D;y1(:,7)]; % drug efficacy
            p_in = [S(end), PI(end), P(end), R(end), Q(end), D(end), E_D(end)];
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            end
end

% Simulation without treatment (it'sconcluded)
t_in = t_f; 
t_f = t_in+t_despues_tto; 

[t1,y1] = ode45(@(t,y)eqs_CRT(t,y,parametros),t_in: 0.001 : t_f, p_in');
t=[t;t1];
S = [S;y1(:,1)]; % sensitive
PI = [PI;y1(:,2)]; % persisters PI
P = [P;y1(:,3)]; % persisters P
R = [R;y1(:,4)]; % resistants
Q = [Q;y1(:,5)]; % quiescents
D = [D;y1(:,6)]; % damaged
E_D = [E_D;y1(:,7)]; % drug efficacy
poblaciones = [S,PI,P,R,Q,D,E_D];



end



