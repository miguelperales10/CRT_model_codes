function [t,populations] = simulation_treat(p_in,parameters,first_RT,t_after_RT,spacing,dose)
t=[];

%% Our parameters:
% The 4 parameters to be adjusted are beta1, alpha_RT, gamma, and tau. 
% The mouse number is also passed as a parameter.
% rho = parameters(1); already fitted
% PQ = parameters(2);
% tau = parameters(3); %----------------------THESE 3 GO INTO THE ODE
 alpha_RT = parameters(4);
 gamma = parameters(5);
% mouse_number = parameters(end);


%% Solving the ODE before the first RT %%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
t_in = 0; 
t_f = first_RT; % When the first irradiation is given

[t1,y1] = ode45(@(t,y)eqs_RT(t,y,parameters(1:3)),t_in: 0.01 : t_f, p_in');
t=[t;t1];
S = y1(:,1);
Q = y1(:,2);
D = y1(:,3);

p_in = [S(end), Q(end), D(end)];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%% Solving the 3 irradiations %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1:dose
    % Apply the RT pulse:
    p_in(3) = p_in(3) + alpha_RT*p_in(1); % Cells damaged by RT
    p_in(1) = (1-alpha_RT)*p_in(1) + gamma*p_in(2);
    p_in(2) = (1-gamma)*p_in(2); % Cells proliferating after RT
    
    % The tumor grows until the next RT:
    t_in = first_RT + spacing*(i-1); 
    t_f = first_RT + spacing*(i); % When the next irradiation is given
    
    % Solve ODE between RT doses
    [t1,y1] = ode45(@(t,y)eqs_RT(t,y,parameters(1:3)),t_in: 0.01 : t_f, p_in');
    
    %Update populations
    t=[t;t1];
    S = [S;y1(:,1)];
    Q = [Q;y1(:,2)];
    D = [D;y1(:,3)];
    p_in = [S(end), Q(end), D(end)];
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%% Solving the ODE after treatment ends %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
t_in = first_RT + dose*spacing; 
t_f = t_in + t_after_RT; % When the first irradiation is given

[t1,y1] = ode45(@(t,y)eqs_RT(t,y,parameters(1:3)),t_in: 0.01 : t_f, p_in');
t=[t;t1];

S = [S;y1(:,1)];
Q = [Q;y1(:,2)];
D = [D;y1(:,3)];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

populations = [S,Q,D];


end

