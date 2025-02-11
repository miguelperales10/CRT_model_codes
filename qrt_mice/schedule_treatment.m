function [RT_tto,QT_tto,t_despues_tto] = schedule_treatment(num_treatment)

% Different CRT administration RT+drug schedules
tto_control = 0;
tto_Stupp   = 1;
tto_RT_X1   = 2;
tto_RT_X4   = 3;
tto_RT_X7   = 4;
tto_TMZ_X1  = 5;
tto_TMZ_X4  = 6;
tto_TMZ_X7  = 7;
tto_TMZ_X13 = 8;


if num_treatment == tto_control
    QT_tto=250; % - NO TMZ  
    RT_tto=251; % - NO RT 
    t_despues_tto = 1;


    
    elseif    num_treatment == tto_Stupp
    
    inicio_tto = 4;
    
    RT_tto=[1,2,3] + inicio_tto;
    % QT_tto=[1,2,3,5,8,11;  % first row: days
    %         1,1,1,2,2,2];  % second row: number of dosis
    QT_tto=[1.2,2.2,3.2,5,5.2,8,8.2,11,11.2] + inicio_tto;  % first row: days (1 doses each day)
    t_despues_tto =  200;
    


    elseif num_treatment == tto_RT_X1
    RT_tto=[1,2,3] + 30;
    QT_tto=199;  % first row: days - NO TMZ 
            %3,3,3];  % second row: number of dosis
    t_despues_tto =  200;
    
    elseif num_treatment == tto_RT_X4
    RT_tto=[1,5,9] + 30;
    QT_tto=199;  % first row: days - NO TMZ 
            %3,3,3];  % second row: number of dosis
    t_despues_tto =  200;
    
    elseif num_treatment == tto_RT_X7
    RT_tto=[1,8,15] + 30;
    QT_tto=199;  % first row: days - NO TMZ 
            %3,3,3];  % second row: number of dosis
    t_despues_tto =  200;
    
    
    
    elseif num_treatment == tto_TMZ_X1
    QT_tto=[1,1.2,1.4,2,2.2,2.4,3,3.2,3.4] + 7;  % first row: days - NO RT
           % 3,3,3];  % second row: number of dosis
    RT_tto=199;
    t_despues_tto =  200;
    
    elseif num_treatment == tto_TMZ_X4
    QT_tto=[1,1.2,1.4,5,5.2,5.4,9,9.2,9.4] + 7;  % first row: days - NO RT
            %3,3,3];  % second row: number of dosis
    RT_tto=199;
    t_despues_tto =  200;
        
    elseif num_treatment == tto_TMZ_X7
    QT_tto=[1,1.2,1.4,8,8.2,8.4,15,15.2,15.4] + 7;  % first row: days - NO RT
            %3,3,3];  % second row: number of dosis
    RT_tto= 199;
    t_despues_tto =  200;

    elseif num_treatment == tto_TMZ_X13
    QT_tto=[1,1.2,1.4,14,14.2,14.4,27,27.2,27.4] + 7;  % first row: days - NO RT
            %3,3,3];  % second row: number of dosis
    RT_tto= 199;
    t_despues_tto =  200;
  
end
