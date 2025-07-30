function f = CRT_eqs(t,y,param) 
ki67 = 0.1;
rho_S = param(1);
muSQ = param(2); 
tau = param(3);
psi2 = param(4);

% Mechanism initial Persisters (PI) -> full Persisters (P)
aaa = 0.01;
bbb = 7.5;
T_min=0.001;

% Parameters taken from literature. 
gamma = .2;
lambda = 11.8825;
alpha1 = 48;
alpha2 = 16;

% Resistant growth rate is the same as sensitive
rho_R = rho_S*ki67;

% Flow Q->S ruled by flow S->Q and ki67
muQS = ki67*(muSQ/(1-ki67) - rho_S);


%% Subpops:
% Sensitive S
S = y(1); 

% Initial Persisters PI
PI = y(2); 

% Full Persisters P
P = y(3); 

% Resistants R
R = y(4);

% Quiescents Q
Q = y(5);

% Damaged D
D = y(6);

% Temozolomide efficacy E_D
T = y(7); 

%% EDOs:
f = [rho_S*S*(S>0) + gamma*P*(P>0) - psi2*S*T*(T>T_min) - alpha1*S*T*(T>T_min)*(S>0) + muQS*Q*(Q>0) - muSQ*S*(S>0);       
     % sens S

     alpha1*S*T*(T>T_min)*(S>0) - PI*bbb*(1-tanh((T-aaa)/aaa))*(PI>0);  
     % pers PI

     PI*bbb*(1-tanh((T-aaa)/aaa))*(PI>0) - alpha2*P*T*(T>T_min)*(P>0) - gamma*P*(P>0);  
     % pers P

     rho_R*R*(R>0) + alpha2*P*T*(T>T_min)*(P>0);                          
     % resist T

     muSQ*S*(S>0) - muQS*Q*(Q>0)
     % quiesc Q

     - tau*D*(D>0) + psi2*S*T*(T>T_min)*(S>0);                              
     % damaged D

     - lambda*T*(T>0)];
     % Tmz eff E_D
end

