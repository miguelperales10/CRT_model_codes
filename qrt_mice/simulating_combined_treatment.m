%% Probamos viendo si el espaciado entre terapias supone mejoría

% Number of patients. 
num_patients = 6;

% Number of treatments tried 
num_treatments = 9;

% Thereshold IVIS value
IVIS_death = 0.3e+08;

% 10% of actively proliferative cells in this animal model.  
ki67=0.1;


% OS matrix
superv = zeros(num_patients,8);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Parameters:
     parametros =[0.9134    1.8182    0.3057    0.5162    0.6206
           1.9913    1.7959    0.7527    0.9259    0.0116
           0.9433    1.8581    0.0820    0.7485    0.0772
           2.0745    1.8676    0.0446    0.9011    0.0102
           2.6818    2.4570    0.4905    0.7576    0.0551
           0.9514    1.4797    0.5416    0.6184    0.5744];
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Simulation for mouse j
for j = 1:num_patients
    
    [par,pop_in] = parametros_vt_RT(j);
    parametros_mouse_j = parametros(j,:);
    

    % Initial conditions
    p_in = [pop_in*ki67, 0, 0 ,0, pop_in*(1-ki67), 0,0];
    
    % Simulate schedule administration i for patient j
    for i = 0:num_treatments-1
    
    % Schedule simulated
    [RT_tto,QT_tto,t_despues_tto] = schedule_treatment(i);
          
    % Simulation
    [t,poblaciones] = simulacion_combined_QT_RT(p_in,parametros_mouse_j,RT_tto,QT_tto,t_despues_tto);
    
    % Subpopoulations
    S = poblaciones(:,1); 
    PI = poblaciones(:,2); 
    P = poblaciones(:,3); 
    R = poblaciones(:,4);
    Q = poblaciones(:,5);
    D = poblaciones(:,6);
    E_D = poblaciones(:,7); 
    total = S+PI+P+R+Q+D;
    
    % Death criteria
    r = find( abs(total-IVIS_death) <= 1e+04,1);
        if length(r)<1 % To ensure the death date is accurate
            r = find( abs(total-IVIS_death) <= 4e+07,1)
        end

    % Death date 
    superv(j,i+1) = r*0.001;
       
    end

end


superv
