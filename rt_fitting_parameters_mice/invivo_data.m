function [data,first_RT] = invivo_data(num_mouse)
% The data consists of time points and populations for the mouse (IVIS)

    % 4 mice from experiment 1:
    if num_mouse == 1
        data = [[0, 3, 8, 11, 14, 17, 22, 25];[5.03e5, 3.59e5, 1.02e6, 4.29e6, 5.86e6, 3.64e6, 6.61e6, 1.28e7]];
        first_RT = 9; % in the first experiment
    elseif num_mouse == 2
        data = [[0, 3, 8, 11, 14, 17, 22];[8.80e5, 1.84e6, 5.57e6, 4.99e6, 5.50e6, 6.81e6, 1.04e7]];
        first_RT = 9; % in the first experiment
    elseif num_mouse == 3
        data = [[0, 3, 8, 11, 14, 17, 22, 25];[7.30e5, 9.00e5, 1.83e6, 1.17e6, 2.71e6, 3.66e6, 4.73e6, 4.88e6]];
        first_RT = 9; % in the first experiment    
    elseif num_mouse == 4
        data = [[0, 3, 8, 11, 14, 17, 22, 25, 29];[7.93e5, 2.05e6, 4.08e6, 1.53e7, 7.47e6, 9.70e6, 9.32e6, 1.50e7, 6.19e7]];
        first_RT = 9; % in the first experiment
    
    %2 mice from experiment 2:
    elseif  num_mouse == 5  
        data = [[0, 3, 8, 11, 14, 17];[2.20e4, 4.78e4, 1.94e5, 4.06e5, 1.47e6, 1.70e6]];
        first_RT = 15; % in the second experiment
    elseif  num_mouse == 6  
        data = [[0, 3, 8, 11, 14, 17, 22, 25, 29, 32];[3.76e5, 4.38e5, 7.98e5, 8.90e5, 2.04e6, 2.83e6, 5.00e6, 8.08e6, 1.63e7, 1.48e7]];
        first_RT = 15; % in the second experiment
    end
end