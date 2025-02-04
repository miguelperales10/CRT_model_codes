
N = 1000; % Num. of virtual patients
M = 1; % Num. of treatments tried. 

% Survival times of the different treatments:
t_surv = [OS(:,1)];%[OS(:,1); OS(:,2); ... OS(:,M)] 

%t_surv = [KM_paper_hum(:,1); KM_paper_hum(:,2); KM_paper_hum(:,3); KM_paper_hum(:,4); KM_paper_hum(:,5)];

EventVar=cell(N*M,1);
EventVar(:)={'DECEASED'};

for i=1:N*M
    if t_surv(i) >= 100
    EventVar(i)={'Alive'};
    end
end  



Treatment=cell(N*M,1);
tto_control=0;
% tto_Stupp=1;
% tto_wt=2;
% tto_TMZ_RT=3;
% tto_RT_X1=4;


for i=0%:4
    if i==tto_control
        Treatment(1+(i)*N:N+(i)*N)={'Stupp protocol'};
    % elseif    i==tto_Stupp
    %     Treatment(1+(i)*N:N+(i)*N)={'Optimal mini Stupp 1'};
    % elseif i==tto_wt
    %     Treatment(1+(i)*N:N+(i)*N)={'Optimal mini Stupp 2'};
    % elseif i==tto_TMZ_RT
    %     Treatment(1+(i)*N:N+(i)*N)={'Optimal concomitant 1'};%{'Concomitant CT'};%
    % elseif i==tto_RT_X1
    %     Treatment(1+(i)*N:N+(i)*N)={'Optimal concomitant 2'};
    end
end
% 
% for i=1
% [p,fh,stats]=MatSurv(times([1:6,6*i:6*i+6],1), EventVar([1:6,6*i:6*i+6],1),  Treatment([1:6,6*i:6*i+6],1));
% end

% Statistical test:
 [fh,stats]=MatSurv(t_surv, EventVar,  Treatment, 'TimeMax',100);

%'group', {'control','Stupp','wt'},'Xstep',24);