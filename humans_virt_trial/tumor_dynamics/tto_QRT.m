function [t,populations] = tto_QRT(p_in,param,RT_dosis,CT_dosis,t_despues_tto)

% Time vector
t=[]; 

% CT and RT 
first_RT= min(RT_dosis);
first_CT= min(CT_dosis);
idx_tto=1;
combined_tto=union(RT_dosis,CT_dosis);
n_tto=length(combined_tto);

%% Parameters
rho_S = param(1);
rho_R = param(2);
mu_SQ = param(3);
mu_QS = param(4);
mu_PS = param(5);
ki67  = param(6); 
gamma = param(7); 
alphaRT_S = param(8); 
alphaRT_R = param(9);
tau = param(10);
beta_SP = param(11);
beta_PR = param(12);
alphaCT = param(13);
lambda  = param(14);
delta_ED = param(15); 


%% Solve ODE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
t_in = 0; 
t_f = min(first_RT,first_CT); % first RT/CT

[t1,y1] = ode45(@(t,y)ecuaciones_QRT(t,y,param),t_in: 0.001 : t_f, p_in');

t=[t;t1];
S = y1(:,1); % sens S
PI = y1(:,2); % initial persisters PI
P = y1(:,3); % fully persisters P
R = y1(:,4); % resist R
Q = y1(:,5); % quiesc Q
D = y1(:,6); % damaged D
E_D = y1(:,7); % tmz

% update subpop.
p_in = [S(end), PI(end), P(end), R(end), Q(end), D(end), E_D(end)];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i=1:n_tto

    t_tto=combined_tto(idx_tto);

            if any(RT_dosis==t_tto) 

            % RT:
                % Damaged
                p_in(6) = p_in(6) + alphaRT_S*p_in(1) + alphaRT_R*p_in(4)*ki67; 
                % TMZ-Resistant
                p_in(4) = (1-alphaRT_R)*p_in(4);                   
                % TMZ-Sensitive
                p_in(1) = (1-alphaRT_S)*p_in(1) + gamma*p_in(5);   
                % Quiescent
                p_in(5) = (1-gamma)*p_in(5);                       

            elseif any(CT_dosis==t_tto)
            % TMZ. Update delta_ED in TMZ pop (1 dose)
                p_in(7) = p_in(7) + delta_ED; 
            end


            if idx_tto<n_tto
            t_in = t_tto; 
            idx_tto=idx_tto+1;
            t_tto=combined_tto(idx_tto);
            t_f = t_tto; 
            
            [t1,y1] = ode45(@(t,y)ecuaciones_QRT(t,y,param),t_in: 0.001 : t_f, p_in');
            t=[t;t1];
            S = [S;y1(:,1)]; % sens S
            PI = [PI;y1(:,2)]; % persisters PI
            P = [P;y1(:,3)]; % persisters P
            R = [R;y1(:,4)]; % resist T
            Q = [Q;y1(:,5)]; % quiesc Q
            D = [D;y1(:,6)]; % damaged D
            E_D = [E_D;y1(:,7)]; % tmz
            p_in = [S(end), PI(end), P(end), R(end), Q(end), D(end), E_D(end)];
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            end
end

%now simulation without treatment (it'sconcluded)
t_in = t_f; 
t_f = t_in+t_despues_tto; % First RT

[t1,y1] = ode45(@(t,y)ecuaciones_QRT(t,y,param),t_in: 0.001 : t_f, p_in');
t=[t;t1];
S = [S;y1(:,1)]; % sens S
PI = [PI;y1(:,2)]; % persisters PI
P = [P;y1(:,3)]; % persisters P
R = [R;y1(:,4)]; % resist T
Q = [Q;y1(:,5)]; % quiesc Q
D = [D;y1(:,6)]; % damaged D
E_D = [E_D;y1(:,7)]; % tmz
populations = [S,PI,P,R,Q,D,E_D];



end



