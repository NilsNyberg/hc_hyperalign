% Decription of purpose
% Users/Owners
% Date of modification

% Add Path 
addpath('../../mind_2018/hc_hyperalign/SpecFun')
addpath('/Users/weizhenxie/Documents/Jupyter/mind2018/hc_hyperalign/R042-2013-08-18')


% load data
load('R042-2013-08-18-metadata.mat')


% Regularize left and right trials
TSE_L(:, 1) = metadata.taskvars.trial_iv_L.tstart;
TSE_L(:, 2) = metadata.taskvars.trial_iv_L.tend;
TSE_R(:, 1) = metadata.taskvars.trial_iv_R.tstart;
TSE_R(:, 2) = metadata.taskvars.trial_iv_R.tend;

reg_trials = RegularizedTrials(TSE_L, TSE_R);

% Produce the Q matrix (Neuron by Time)
Qmat = generateQmatrix(reg_trials, S, 0);
Qmat = generateQmatrix(reg_trials, S, 0);

% 


