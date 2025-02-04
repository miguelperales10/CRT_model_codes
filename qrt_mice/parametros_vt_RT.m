function [parametros_ajuste,pop_in] = parametros_vt_RT(n_raton)

ki67=0.1;


parametros_ajuste =    [0.9134    1.8182    0.3057    0.5162    0.6206
                        1.9913    1.7959    0.7527    0.9259    0.0116
                        0.9433    1.8581    0.0820    0.7485    0.0772
                        2.0745    1.8676    0.0446    0.9011    0.0102
                        2.8136    2.8610    0.7550    0.9073    0.0215
                        0.9514    1.4797    0.5416    0.6184    0.5744];

% Only take parameters from mouse n_raton
parametros_ajuste = parametros_ajuste(n_raton,:);

a = n_raton;
% datos vector is for IVIS data collected and the day they were
% measured (days after 1st IVIS data). 
% primera_RT represents the day of the 1st irradiation (days after
% 1st IVIS measure).

% 4 mice from exp.1
if a == 1
    datos = [[0, 3, 8, 11, 14, 17, 22, 25];[5.03e5, 3.59e5, 1.02e6, 4.29e6, 5.86e6, 3.64e6, 6.61e6, 1.28e7]];
    primera_RT = 9; 
elseif a == 2
    datos = [[0, 3, 8, 11, 14, 17, 22];[8.80e5, 1.84e6, 5.57e6, 4.99e6, 5.50e6, 6.81e6, 1.04e7]];
    primera_RT = 9; 
elseif a == 3
    datos = [[0, 3, 8, 11, 14, 17, 22, 25];[7.30e5, 9.00e5, 1.83e6, 1.17e6, 2.71e6, 3.66e6, 4.73e6, 4.88e6]];
    primera_RT = 9; 
elseif a == 4
    datos = [[0, 3, 8, 11, 14, 17, 22, 25, 29];[7.93e5, 2.05e6, 4.08e6, 1.53e7, 7.47e6, 9.70e6, 9.32e6, 1.50e7, 6.19e7]];
    primera_RT = 9;

% 2 mice from exp.1
elseif  a == 5  
    datos = [[0, 3, 8, 11, 14, 17];[2.20e4, 4.78e4, 1.94e5, 4.06e5, 1.47e6, 1.70e6]];
    primera_RT = 15; 
elseif  a == 6  
    datos = [[0, 3, 8, 11, 14, 17, 22, 25, 29, 32];[3.76e5, 4.38e5, 7.98e5, 8.90e5, 2.04e6, 2.83e6, 5.00e6, 8.08e6, 1.63e7, 1.48e7]];
    primera_RT = 15;
end

% In all cases, the 1st IVIS data is measured 30 days after the tumor
% injection:
pop_in=datos(2,1)/exp(30*parametros_ajuste(1)*ki67);

end

