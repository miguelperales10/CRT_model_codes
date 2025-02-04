function [t,poblaciones] = simulacion_combined_QT_RT(p_in,parametros,RT_dosis,QT_dosis,t_despues_tto)

% 10% of actively proliferative cells in this animal model.  
ki67 = 0.1; 

% Time vector
t=[]; 

%% Our parameters:
% The four parameters to be adjusted are mu_SQ, gamma, alpha_RT, and tau. 
% The mouse number is also considered as a parameter.
% rho = parametros(1); already fitted
% mu_SQ = parametros(2);
% tau = parametros(3); %----------------------THESE THREE GO INTO THE ODE
 alpha_RT = parametros(4);
 gamma = parametros(5);
% numero_raton = parametros(end);
primera_RT= min(RT_dosis);
primera_QT= min(QT_dosis);

% Combined treatment schedule:
idx_tto=1; % Tratment administration index (1st, 2nd, ...)
combined_tto=union(RT_dosis,QT_dosis);
n_tto=length(combined_tto);

%% Solving the ODE for the period before the first treatment %%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
t_in = 0; 
t_f = min(primera_RT,primera_QT); % When the first irradiation/drug is administered

% Solve the ODE system
[t1,y1] = ode45(@(t,y)ecuaciones_QRT(t,y,parametros(1:3)),t_in: 0.001 : t_f, p_in');

% Update subpopulations
S = y1(:,1); % sensitive cells
PI = y1(:,2); % persister PI cells
P = y1(:,3); % persister cells
R = y1(:,4); % resistant cells
Q = y1(:,5); % quiescent cells
D = y1(:,6); % damaged cells
E_D = y1(:,7); % Drug efficacy
p_in = [S(end), PI(end), P(end), R(end), Q(end), D(end), E_D(end)];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Following RT/drug administrations:
for i=1:n_tto
    
    t_tto=combined_tto(idx_tto);
    
    if any(RT_dosis==t_tto) % RT pulse
        % Damaged cells
        p_in(6) = p_in(6) + alpha_RT*p_in(1)+alpha_RT*p_in(4)*ki67; 
        % QT-resistant cells damaged by RT
        p_in(4)=(1-alpha_RT*ki67)*p_in(4); 
        % QT-sensitive cells damaged by RT
        p_in(1) = (1-alpha_RT)*p_in(1) + gamma*p_in(5); 
        % Quiescent cells
        p_in(5) = (1-gamma)*p_in(5); 
    
    elseif any(QT_dosis==t_tto) % Drug pulse
        % Increase the TMZ population by 1/3 (1 dose)
        p_in(7) = p_in(7) + 1/3; 
    end
    
    if idx_tto<n_tto % Simulation between treatment administrations

        % Update time between treatment administrations
        t_in = t_tto; 
        idx_tto=idx_tto+1;
        t_tto=combined_tto(idx_tto);
        t_f = t_tto; % When the current RT/drug is administered
        
        % Solve ODE
        [t1,y1] = ode45(@(t,y)ecuaciones_QRT(t,y,parametros(1:3)),t_in: 0.001 : t_f, p_in');

        % Update time vector
        t=[t;t1];

        % Update subpopulations
        S = [S;y1(:,1)]; % sensitive cells
        PI = [PI;y1(:,2)]; % persister PI cells
        P = [P;y1(:,3)]; % persister cells
        R = [R;y1(:,4)]; % resistant cells
        Q = [Q;y1(:,5)]; % quiescent cells
        D = [D;y1(:,6)]; % damaged cells
        E_D = [E_D;y1(:,7)]; % Drug efficacy
        p_in = [S(end), PI(end), P(end), R(end), Q(end), D(end), E_D(end)];
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end
end

% Now, the simulation continues without treatment (it is concluded)
% Time we want to run the simulation after the last RT/drug administration:
t_in = t_f; 
t_f = t_in+t_despues_tto; 

% Solve ODE 
[t1,y1] = ode45(@(t,y)ecuaciones_QRT(t,y,parametros(1:3)),t_in: 0.001 : t_f, p_in');

% Update time vector
t=[t;t1];

% Update subpopulations
S = [S;y1(:,1)]; % sensitive cells
PI = [PI;y1(:,2)]; % persister PI cells
P = [P;y1(:,3)]; % persister cells
R = [R;y1(:,4)]; % resistant cells
Q = [Q;y1(:,5)]; % quiescent cells
D = [D;y1(:,6)]; % damaged cells
E_D = [E_D;y1(:,7)]; % Drug efficacy
poblaciones = [S,PI,P,R,Q,D,E_D];
end


