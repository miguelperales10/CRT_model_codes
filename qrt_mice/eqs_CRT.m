function f = eqs_CRT(t,y,parametros) 

% 10% of actively proliferative cells in this animal model.  
ki67 = 0.1; 

% rho_S, mu_SQ (and thus mu_QS), and tau fitted from IVIS data from invivo
% RT experiments.  
rho_S = parametros(1);  % Sensitive cells growth rate
mu_SQ = parametros(2);  % Flow Sentivie -> Quiescent
tau = parametros(3);    % Clearance Damaged cells
mu_QS = ki67*(mu_SQ/(1-ki67) - rho_S); % Flow Quiescent -> Sentivie

% Activation function Persisters PI -> Persisters P.
aaa = 0.01;
bbb = 7.5;
E_D_min=0.001;

% Parameters taken from previous studies with this animal model.
mu_PS = .2;         % Flow Persisters P -> Sensitive
lambda = 11.8825;   % TMZ decay rate
beta_SP_I = 48;     % Persister cells generation rate
beta_PR = 16;       % Resistant cells generation rate

% Resistant populations assumed to grow as fast as Sensitive.
rho_R = rho_S;

% TMZ killing efficiency
alpha_E_D = 150; 


%% Subpopulations:
% Sensitive, actively proliferative
S = y(1); 

% Persisters PI
PI = y(2); 

% Persisters P
P = y(3); 

% Resistant
R = y(4);

% Quiescents
Q = y(5);

% Damaged
D = y(6);

% Drug efficacy
E_D = y(7); 

%% ODEs:
f = [rho_S*S + mu_PS*P - alpha_E_D*S*E_D*(E_D>E_D_min) - beta_SP_I*S*E_D*(E_D>E_D_min) + mu_QS*Q*(Q>0) - mu_SQ*S*(S>0);       
     % sensitives, actively proliferative

     beta_SP_I*S*E_D*(E_D>E_D_min) - PI*bbb*(1-tanh((E_D-aaa)/aaa));  
     % persisters PI

     PI*bbb*(1-tanh((E_D-aaa)/aaa)) - beta_PR*P*E_D*(E_D>E_D_min) - mu_PS*P;  
     % persisters 

     rho_R*ki67*R + beta_PR*P*E_D*(E_D>E_D_min);                          
     % resistants

     mu_SQ*S*(S>0) - mu_QS*Q*(Q>0)
     % quiescents

     - tau*D*(D>0) + alpha_E_D*S*E_D*(E_D>E_D_min);                              
     % damaged

     - lambda*E_D*(E_D>0)];
     % Drug efficacy
end

