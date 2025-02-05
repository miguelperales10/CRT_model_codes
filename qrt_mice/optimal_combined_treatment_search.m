% Try all different combinations RT-CT and choose the shedule which offers
% maximal median overall survival

IVIS_death = 0.3e+08;

t_despues_tto = 150;

ki67=0.1;

% Constraints
a = 16; % max spacing between RT doses
b = 15; % max spacing between CT doses
c = 30; % max delay between RT and CT start

n_rat= 6;

superv_mediana = zeros(a,b,2*c+1);
superv = zeros(n_rat,a,b,2*c+1);

optimo=zeros(1,4);
for i = 1:a 
    for k = 1:b
        for l = -c:c
            labs=abs(l);            
            if l<0
                RT_tto = labs+[1,i+1,i*2+1];
                CT_tto = [1.2, 1.4, 1.6,k+1.2, k+1.4, k+1.6,2*k+1.2, 2*k+1.4, 2*k+1.6];
                else 
                RT_tto = [1,i+1,2*i+1];
                CT_tto = labs+[1.2, 1.4, 1.6,k+1.2, k+1.4, k+1.6,2*k+1.2, 2*k+1.4, 2*k+1.6];
            end
            
            for j = 1:n_rat
            [parametros,pop_in] = RT_parameters_virtualtwins(j);
            
            p_in = [pop_in*ki67, 0, 0 ,0, pop_in*(1-ki67), 0,0];
            
            [t,poblaciones] = simulation_combined_CT_RT(p_in,parametros,RT_tto,CT_tto,t_despues_tto);
            
            S = poblaciones(:,1); PI = poblaciones(:,2); P = poblaciones(:,3); R = poblaciones(:,4);
            Q = poblaciones(:,5);D = poblaciones(:,6);T = poblaciones(:,7); 
            total = S+PI+P+R+Q+D;
            
            r = find( abs(total-IVIS_death) <= 1e+04,1);
            superv(j,i,k,l+c+1) = r*0.001;
            end
            superv_mediana(i,k,l+c+1) = median(superv(:,i,k,l+c+1));
            
            if  superv_mediana(i,k,l+c+1)>optimo(end,1)
                optimo = [optimo; superv_mediana(i,k,l+c+1),i,k,l] % show optimal treatment
               
            end
        end
    end
end



