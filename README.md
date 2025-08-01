# QRTmodel_codes

Codes are divided into four folders: humans_virt_trial, rt_fitting_parameters_mice, crt_mice, and global_sensitivity_analysis. 

The first folder, humans_virt_trial, contains the codes used to simulate a clinical trial of malignant glioma under radiotherapy and chemotherapy. For this purpose, model parameters are obtained from the literature.
  - The "simulating_trials" code allows for the simulation of a virtual trial with N virtual patients (default N = 100) and M different chemoradiotherapy administration protocols (the Stupp protocol by default). The output is a matrix containing the overall survival (OS) of each virtual patient under each protocol. This code should be executed to run the virtual trial.
  - The "virt_trial" code computes the OS for N virtual patients under a given protocol and reports the computation time required for the simulations. The model parameter distributions are taken from the literature.
  - The "OS_treat_CRT" code calculates the OS of a virtual patient based on individual parameters, initial conditions, and other relevant factors.
  - The "CRT_treatment_sim" code simulates the longitudinal evolution of tumor subpopulations in a virtual patient.
  - The "eqs_CRT" code contains the system of ordinary differential equations (ODEs) used in this model.
In the "tumor_dynamics" subfolder, representative tumor traces can be plotted by running the "figure_repr_patients" script.

The second folder, rt_fitting_parameters_mice, contains longitudinal data collected from in vivo experiments and the codes used to fit radiotherapy-related parameters.
  - The "invivo_IVIS_data" code contains bioluminescence IVIS measurements for each mouse, the time at which each measurement was taken, and the day each mouse received radiotherapy after the first measurement.
  - The "fitting_RT" code provides the fitted parameters and the error of each simulation. This code accounts for the biological constraints developed in the paper.
  - The "calc_error" code calculates the error of each simulation relative to the _in vivo_ data.
  - The "simulation_treat"  code simulates the longitudinal evolution of tumor subpopulations in a virtual mouse.
  - The "eqs_RT" code contains the system of ordinary differential equations (ODEs) used in this model.

The third folder, crt_mice, contains the codes required to run simulations of virtual mice, using parameter distributions obtained both from RT-related longitudinal data and from the literature. This folder also includes codes to test different chemoradiotherapy administration protocols, determine the schedule that provides the highest median overall survival (OS) for virtual mice while considering treatment restrictions, and generate the figures used in the paper ("MatSurv" code).
  - The "optimal_combined_treatment_search" code calculates the best treatment administration schedule based on median OS.
  - The "simulating_combined_treatments" code simulates different treatment schedules for a group of virtual mice, tracking their overall survival (OS) based on tumor subpopulation dynamics.
  - The "schedule_treatment" code provides the treatment schedule implemented in each administration protocol.
  - The "RT_parameters_virtualtwins" code provides the parameters fitted from RT-experiment longitudinal data and calculates the initial conditions for each virtual mouse.
  - The "simulation_combined_CT_RT" code simulates the longitudinal evolution of tumor subpopulations in a virtual mouse.
  - The "eqs_RT" code contains the system of ordinary differential equations (ODEs) used in this model.
    
The fourth folder, global_sensitivity_analysis, contains the code required to perform a global sensitivity analysis of the CRT model. This analysis identifies the biological and therapeutic scheduling parameters that most significantly impact overall survival in virtual mice. The GSAT folder is included to handle the sampling process and the computation of sensitivity indices.
  - The global_sens_analysis_Sobol script sets up the parameter distributions, runs the model simulations, and computes the sensitivity first- and total-order Sobols' indices. This is the main script to run in order to obtain the sensitivity analysis results.
Additionally, among other scripts, the folder includes:
  - The my_model script, which defines the model that simulates tumor dynamics until the fatal volume is reached. The output is survival time, which depends on the initial conditions, CRT model parameter values, and treatment schedule.
  - The CRT_eqs script, which contains the equations used to simulate CRT dynamics, as described previously.
  - The simul_combined_CRT script, which simulates tumor evolution under combined chemoradiotherapy.
  - The GSAT folder, which contains toolbox functions for FAST and Sobol analysis, including sampling routines.



