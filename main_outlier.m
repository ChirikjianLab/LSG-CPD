% LSG-CPD: CPD with Local Surface Geometry
% Demo of Outlier Experiment
% Author: Weixiao Liu, Hongtao Wu 
% Johns Hopkins University & National University of Singapore

% Read Data
clc
clear
close all

source_file = 'data/outlier/GOutRatio_0.5_1_Rand.ply';
target_file = 'data/outlier/GOutRatio_0.5_1_Base.ply';

pc_source = pcread(source_file);
pc_target = pcread(target_file);

% Initial
figure(1)
pcshowpair(pc_target, pc_source);

% Registration
parm.maxIter = 100; % EM max iteration
parm.tolerance = 1e-5; % EM loglikelihood tolerance
parm.sigma2 = 0;
parm.w = 0.5; % outlier_ratio
parm.mean_xform = 1; % translate to the mean position
parm.weight = 0;
parm.opti_maxIter = 10; % max iteration for optimization
parm.opti_tolerance = 1e-3; % tolerance fot optimization
parm.neighbours = 30; % Neighbour
parm.alimit = 30; % Alpha max
parm.lambda = 0.2; % lambda

tic
xform = LSGCPD(pc_source, pc_target, parm);
toc
disp('Time comsumption')

% Show result
figure(2)
pc_xform = pctransform(pc_source, xform);
pcshowpair(pc_target, pc_xform);