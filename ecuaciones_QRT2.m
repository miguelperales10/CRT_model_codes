function f = ecuaciones_QRT2(t,y,parametros) 

% Le pasamos rho1, beta1 (y beta2), tau del ajuste en RT. 

ki67 = 0.1;
rho1 = parametros(1);
beta1 = parametros(2); 
tau = parametros(3);

psi2 = parametros(4);

% Mecanismo de Persisters PI -> Persisters P
aaa = 0.01;
bbb = 7.5;
T_min=0.001;


% El resto de parámetros se cogen de la literatura. 
gamma = .2;% d^-1
lambda = 11.8825; %d^-1
alpha1 = 48; %d^-1
alpha2 = 16; %d^-1

%%%%%   solo una parte prolifera in P+Q
rho2 = rho1*ki67;%


beta2 = ki67*(beta1/(1-ki67) - rho1);


%psi2 = 65*2.9706; % Funciona para gamma>0.01
%psi2 = 150; % Funciona para gamma>0.01 y rho "libre"

% psi2 = 40;%%%% Probamos nuevas. Juan pone 0.25;


%% Poblaciones:
% Sensibles
S = y(1); 

% Persisters PI
PI = y(2); 

% Persisters P
P = y(3); 

% Resistentes
R = y(4);

% Quiescentes
Q = y(5);

% Dañadas
D = y(6);

% Temozolomida
T = y(7); 

%% EDOs:
f = [rho1*S*(S>0) + gamma*P*(P>0) - psi2*S*T*(T>T_min) - alpha1*S*T*(T>T_min)*(S>0) + beta2*Q*(Q>0) - beta1*S*(S>0);       
     % sensibles

     alpha1*S*T*(T>T_min)*(S>0) - PI*bbb*(1-tanh((T-aaa)/aaa))*(PI>0);  
     % persisters PI

     PI*bbb*(1-tanh((T-aaa)/aaa))*(PI>0) - alpha2*P*T*(T>T_min)*(P>0) - gamma*P*(P>0);  
     % persisters 

     rho2*R*(R>0) + alpha2*P*T*(T>T_min)*(P>0);                          
     % resistentes

     beta1*S*(S>0) - beta2*Q*(Q>0)
     % quiescentes

     - tau*D*(D>0) + psi2*S*T*(T>T_min)*(S>0);                              
     % dañadas 

     - lambda*T*(T>0)];
     % Temozolomida
end

