function f = ecuaciones_QRT(t,y,parametros) 

%% All parameters. Some of them are not used in the ODE. 
rho_S = parametros(1);
rho_R = parametros(2);
mu_SQ = parametros(3);
mu_QS = parametros(4);
mu_PS = parametros(5);
ki67  = parametros(6); % not used here
gamma = parametros(7); % not used here
alphaRT_S = parametros(8); % not used here
alphaRT_R = parametros(9); % not used here
tau = parametros(10);
beta_SP = parametros(11);
beta_PR = parametros(12);
alphaQT = parametros(13);
lambda  = parametros(14);
delta_ED = parametros(15); % not used here



% Activation function Persisters PI -> Persisters P
aaa = 0.01;
bbb = 7.5;
E_D_min=0.001;



%% Populations:
% Sensitives, actively proliferative
S = y(1); 

% Persisters PI
PI = y(2); 

% Persisters P
P = y(3); 

% Resistants
R = y(4);

% Quiescents
Q = y(5);

% Damaged
D = y(6);

% Drug efficacy
E_D = y(7); 

%% ODEs:
f = [rho_S*S + mu_PS*P - alphaQT*S*E_D*(E_D>E_D_min) - beta_SP*S*E_D*(E_D>E_D_min) + mu_QS*Q*(Q>0) - mu_SQ*S*(S>0);       
     % Sensitives, actively proliferative

     beta_SP*S*E_D*(E_D>E_D_min) - PI*bbb*(1-tanh((E_D-aaa)/aaa));  
     % Persisters PI

     PI*bbb*(1-tanh((E_D-aaa)/aaa)) - beta_PR*P*E_D*(E_D>E_D_min) - mu_PS*P;  
     % Persisters P

     rho_R*R + beta_PR*P*E_D*(E_D>E_D_min);                          
     % Resistants

     mu_SQ*S*(S>0) - mu_QS*Q*(Q>0)
     % Quiescents

     - tau*D*(D>0) + alphaQT*S*E_D*(E_D>E_D_min);                              
     % Damaged

     - lambda*E_D*(E_D>0)];
     % Drug efficacy
end

