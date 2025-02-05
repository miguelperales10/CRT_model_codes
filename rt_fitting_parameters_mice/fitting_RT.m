function [parameters, min_error] = fitting_RT
 

min_error = zeros(6,1);

% Fit with several seeds to achieve the global min


% Testing different seeds:
values = zeros(6,num_seeds);
errors = zeros(1,num_seeds);

rho_S = zeros(6,1);
mu_SQ = zeros(6,1); 
tau = zeros(6,1);
alpha_RT = zeros(6,1);   
gamma = zeros(6,1);


for i = 1:6 % Fitting param. for mouse i  
    mouse = i;
    % Modify ki67 in the equation code if necessary. 
    
    
    for k = 1:num_seeds % Fitting param. for seed k
      
        % Initial seed
        param_In = [rand*3, rand*3, rand, rand, rand];     
        
        %% Sets optimization options in MATLAB. 
        % 'Display', 'iter': Specifies that iteration information should be
        % displayed in the command window during the optimization process.
        %'MaxFunEvals', 3000: Sets the maximum number of function evaluations
        % to 3000, limiting how many times the objective function can be called.
        options = optimset('Display','iter', 'MaxFunEvals',3000);
        
        %% Constraints:
        % Lower and upper bounds of the parameters
              lb = [0, 0,   0,  0, 0.01, mouse]';
              ub = [3, 3,   1,  1,   1,  mouse]';
        % Biological-based constraints
        b = zeros(6,1);
        beq = zeros(6,1);
        A = zeros(6); Aeq = zeros(6);
        A(1,1)=-1; A(1,3) = 1; % tau<=rho_S
        A(3,1)=1/100; A(3,3) = -1; % rho_S/100<=tau
      
        A(2,1)=0.9; A(2,2) = -1; %non-negativity constraint
        
        % minimize the error function considering previous constraints
        [y,fval] = fmincon(@calc_error,[param_In, mouse],A,b,Aeq,beq,lb,ub,[],options);
        values(:,k) = y
        errors(k) = fval
    end 
    
    % Seed in which the minimun error is achieved
    index = find(errors==min(errors));
    
    % Best fitting parameters set
    rho_S(i) = values(1,index);
    mu_SQ(i) = values(2,index);
    tau(i) = values(3,index);
    alpha_RT(i) = values(4,index);
    gamma(i) = values(5,index);
    
    % Error
    min_error(i) = errors(index(1));

end

% Fitted parameters for i mouse
parameters = [rho_S,mu_SQ,tau,alpha_RT,gamma];

end


