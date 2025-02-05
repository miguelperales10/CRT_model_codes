function [OS] = simulating_trials

% Number of virtual patients
N = 1000;

% Number of treatments simulated
M = 1; 

% \delta_{E_D}
delta_ED = 1/3; 

% OS matrix. One entre for each patient under each treatment
OS = zeros(N,M); 

% Treatments. 
% Stupp protocol is:
RT_dosis = [1:5, 8:12, 15:19, 22:26, 29:33, 36:40]; % RT

QT_ady = [70:75, 98:104, 126:131, 154:159, 182:187, 210:215]; 
QT_ady = [QT_ady,QT_ady+0.05]; % Ady. TMZ (dose is double than when Conc.)

QT_dosis = [1.05:42.05, QT_ady]; % Conc. + Ady. TMZ



%% VIRTUAL TRIAL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
OS(:,1) = virt_trial(N,QT_dosis,RT_dosis,delta_ED);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% OTHER POSSIBLE SCHEDULE TREATMENTS
% We increase the adjuvant TMZ cycles
% RT_dosis = [1:5, 8:12, 15:19, 22:26, 29:33, 36:40];
% num_ciclos = 12; % We increase the number of cycles as in the clinical trial
% 
% QT_ady = [70,75]; 
%     for n=1:num_ciclos-1
%     QT_ady = [QT_ady, QT_ady(end)+23:QT_ady(end)+28];
%     end
% QT_ady = [QT_ady,QT_ady+0.05];% We double the dose
% 
% QT_dosis = [1.05:42.05, QT_ady];
% OS(:,2) = virt_trial(N,QT_dosis,RT_dosis,delta_ED);
% 
% 
% % Concomitant QRT would be with 6 cycles:
% for j= 1:8
% sep = 7*j; % Interval between concomitant doses
% %  RT_dosis_1w = [1:5, sep+(8:12), 2*sep+(15:19), 3*sep+(22:26), 4*sep+(29:33), 5*sep+(36:40)]; % 1 week
%   RT_dosis_2w = [1:5, 8:12, sep+(15:19), sep+(22:26), 2*sep+(29:33), 2*sep+(36:40)]; % 2 weeks
% % 
% %  QT_dosis_1w = [0.05+RT_dosis_1w,0.1+RT_dosis_1w,0.15+RT_dosis_1w];% We double the dose
%   QT_dosis_2w = [0.05+RT_dosis_2w,0.1+RT_dosis_2w,0.15+RT_dosis_2w];% We double the dose
% % 
% %  OS_1w(:,j) = virt_trial(N,QT_dosis_1w,RT_dosis_1w,delta_ED);
%  OS_2w(:,j) = virt_trial(N,QT_dosis_2w,RT_dosis_2w,delta_ED);
% 
% % RT_dosis_3w = [1:5, (8:12), (15:19), sep+(22:26), sep+(29:33), sep+(36:40)]; % 3 weeks
% % QT_dosis_3w = [0.05+RT_dosis_3w,0.1+RT_dosis_3w,0.15+RT_dosis_3w];% We double the dose
% % OS_3w(:,j) = virt_trial(N,QT_dosis_3w,RT_dosis_3w,delta_ED);
% end
% 
% RT_dosis = [];
% num_ciclos = 6;
% 
% for sep = 1:8  % Interval between cycles (weeks)
% 
%         for i=1:num_ciclos % M-F doses for n cycles 
%             RT_dosis = [RT_dosis,(1:5)+ 7*(i-1) + sep*7*(i-1),(8:12) + 7*(i-1) + sep*7*(i-1)];
%         end
% 
% QT_dosis = [0.05+RT_dosis, 0.1+RT_dosis, 0.15+RT_dosis];
% OS(:,sep+1) = virt_trial(N,QT_dosis,RT_dosis,delta_ED);
% end
% 
% for j=3
% 
% RT_dosis = [];
% QT_dosis = [];
% 
% num_ciclos = 6;
% 
% sep = 7*j;
% 
%         for i = 1:num_ciclos
%              RT_dosis = [RT_dosis, (i-1)*sep+(1:5)];
%              QT_dosis = [QT_dosis, (i-1)*sep+0.05+(1:14), (i-1)*sep+0.1+(8:14)];% We double the dose
%         end
% 
% OS = virt_trial(N,QT_dosis,RT_dosis,delta_ED);
% end


end
