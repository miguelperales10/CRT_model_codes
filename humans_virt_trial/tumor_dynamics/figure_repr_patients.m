%% Representative figures

N = 9;
M = 1; % n de ttos simulados, solo simulamos el C8B
delta_ED = 1/3; % Salto de TMZ


% QRT concomitante con 6 ciclos:
j = 8; % Break de 8 semanas entre ciclos concomitantes.
sep = 7*j; % Separación entre dosis concomitantes

% 3 ciclos de dos semanas:
RT_dosis_2w = [1:5, 8:12, sep+(15:19), sep+(22:26), 2*sep+(29:33), 2*sep+(36:40)]; % 2semanas
QT_dosis_2w = [0.05+RT_dosis_2w,0.1+RT_dosis_2w,0.15+RT_dosis_2w];% Damos el doble de dosis

% Simulamos el virt_trial, que dibuja las figuras.
death_threshold = 280;
close all %cerramos las figuras anteriores
figure
OS = virt_trial_figures(N,QT_dosis_2w,RT_dosis_2w,delta_ED);
%N=8; OS = virt_trial_figures_repr(N,QT_dosis_2w,RT_dosis_2w,delta_ED);
hold on;
color_tto = [0.7 0.8 1];
for k = 0:2
    x1 = 1 + (56+14)*k;
    x2 = 14 + (56+14)*k;
    fill([x1 x2 x2 x1], [0 0 350 350], color_tto, ...
         'EdgeColor', 'none', 'FaceAlpha', 0.3);
end
%hold on
% Dibujar línea de umbral de muerte
h_os = plot(1:10000, death_threshold*ones(10000,1), '-.', ...
            'LineWidth', 3, 'Color', [.8 0.1 0.1]);
xlim([1,750])
ylim([1,300])
xlabel('Days', 'FontSize', 20);
ylabel('Volume (cm^3)', 'FontSize', 20);
set(gca, 'FontSize', 15);

% Crear objetos ficticios para la leyenda
h_patients = plot(NaN, NaN, '-', 'Color', [0.5 0.5 0.5], 'LineWidth', 1.5); % curvas de pacientes
h_treatment = fill(NaN(1,4), NaN(1,4), color_tto, 'FaceAlpha', 0.3, 'EdgeColor', 'none'); % banda de tratamiento

% Añadir leyenda
legend([h_patients, h_treatment, h_os], ...
       {'Virtual patient traces', 'CRT cycles', 'Fatal tumor burden'}, ...
       'Location', 'southeast', 'FontSize', 20);
hold off