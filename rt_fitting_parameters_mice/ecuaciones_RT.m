function f = ecuaciones_RT(t,y, parametros) 

% Percentage of proliferative cells, 10% in SVZ EGFR-wt animal model
ki67 = 0.1; 

%% Parameters:
% Proliferative proliferation
  rho_S = parametros(1); 

% Transition from proliferative to quiescent
  mu_PQ  = parametros(2);

% To keep ki-67 constant at a 10% rate, mu_QP  must be:
  mu_QP  = ki67*(mu_PQ /(1-ki67) - rho_S);

% Clearance of damaged cells:
  tau = parametros(3);

%% Populations
S = y(1); 
Q = y(2);
D = y(3);

%% ODEs
f = [rho_S*S - mu_PQ *S*(S>0) + mu_QP *Q*(Q>0);       
     % Sensitive - Actively proliferative

     mu_PQ *S*(S>0) - mu_QP *Q*(Q>0);                              
     % Quiescent  

     - tau*D*(D>0)];                              
     % Damaged
end
