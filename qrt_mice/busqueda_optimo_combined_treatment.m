% Try all different combinations RT-CT and choose the shedule which offers
% maximal median overall survival

IVIS_death = 0.3e+08;

t_despues_tto = 150;

ki67=0.1;

% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Con las hipótesis iniciales
% parametros_0 = [
%     0.8848    1.6243    0.2685    0.8573    0.9539
%     2.3094    2.0933    1.7942    0.9925    0.0003
%     1.1502    1.0542    0.9781    0.7267    0.0347
%     2.0501    1.8532    0.1409    0.7169    0.0037
%     2.7244    3.4176    1.4606    0.7951    0.0388
%     0.9418    1.9407    0.6057    0.3314    0.6053];
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Con gamma>0.01
% parametros_gammma001 = [0.8848    1.6257    0.2680    0.8580    0.9551
%     2.3094    2.0785    2.3093    1.0000    0.0100
%     1.1502    1.0382    1.0078    0.4510    0.0146
%     2.0501    1.8452    0.0033    0.8672    0.0100
%     2.7244    3.3977    1.5430    0.8243    0.0444
%     0.9418    1.4010    0.5388    0.6619    0.6052];
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Con 2.5>beta1>=0.9*rho, tau<rho, rho>=rho_in*0.8 (rho_in es el de pre-rt)
% % Con gamma>0.01
% nuevos_par3 = [ 0.9134    1.8182    0.3057    0.5162    0.6206
%                 1.9913    1.7959    0.7527    0.9259    0.0116
%                 0.9433    1.8581    0.0820    0.7485    0.0772
%                 2.0745    1.8676    0.0446    0.9011    0.0102
%                 2.6818    2.4570    0.4905    0.7576    0.0551
%                 0.9514    1.4797    0.5416    0.6184    0.5744];
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% 
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % Parámetros validados por matteo1
% % parametros_matteo1 =[0.8949    0.8054    0.5401    0.4601    0.1507
% %                     1.3969    1.2572    0.1340    0.6742    0.0527
% %                     0.7200    0.6480    0.7611    0.3405    0.0775
% %                     1.3232    1.1909    0.2123    0.6569    0.0546
% %                     2.6973    2.4276    2.8567    0.6867    0.0519
% %                     0.9514    0.8562    0.0473    0.6795    0.2138];
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


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
            [parametros,pop_in] = parametros_vt_RT(j);
            
            parametros = nuevos_par3(j,:);
                        
            p_in = [pop_in*ki67, 0, 0 ,0, pop_in*(1-ki67), 0,0];
            
            [t,poblaciones] = simulacion_combined_CT_RT(p_in,parametros,RT_tto,CT_tto,t_despues_tto);
            
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



