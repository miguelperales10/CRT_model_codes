function f = ecuaciones_QRT(t,y,param) 

% Parameters
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
alphaQT = param(13);
lambda  = param(14);
delta_ED = param(15);



% Mechanism Persisters PI -> Persisters P
aaa = 0.01;
bbb = 7.5;
E_D_min=0.001;



%% Pops:
% Sensitive
S = y(1); 

% Persisters PI
PI = y(2); 

% Persisters P
P = y(3); 

% Resist T
R = y(4);

% Quiesc Q
Q = y(5);

% Damaged D
D = y(6);

% Tmz
E_D = y(7); 

%% ODEs:
f = [rho_S*S + mu_PS*P - alphaQT*S*E_D*(E_D>E_D_min) - beta_SP*S*E_D*(E_D>E_D_min) + mu_QS*Q*(Q>0) - mu_SQ*S*(S>0);       
     % sensitive S

     beta_SP*S*E_D*(E_D>E_D_min) - PI*bbb*(1-tanh((E_D-aaa)/aaa));  
     % persisters PI

     PI*bbb*(1-tanh((E_D-aaa)/aaa)) - beta_PR*P*E_D*(E_D>E_D_min) - mu_PS*P;  
     % persisters P

     rho_R*R + beta_PR*P*E_D*(E_D>E_D_min);                          
     % resistentes

     mu_SQ*S*(S>0) - mu_QS*Q*(Q>0)
     % quiesc Q

     - tau*D*(D>0) + alphaQT*S*E_D*(E_D>E_D_min);                              
     % damaged D

     - lambda*E_D*(E_D>0)];
     % Tmz
end

