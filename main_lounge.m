% LSG-CPD: CPD with Local Surface Geometry
% Demo of Stanford Lounge Dataset
% Author: Weixiao Liu, Hongtao Wu 
% Johns Hopkins University & National University of Singapore

clc
clear
close all

% --------------- Load Data ---------------
source_ply = "data/lounge/source.ply";
target_ply = "data/lounge/target.ply";
pc_source = pcread(source_ply);
pc_target = pcread(target_ply);

% --------------- Registration ---------------
parm.maxIter = 50; % EM max iteration
parm.tolerance = 1e-2; % EM loglikelihood tolerance
parm.sigma2 = 0; 
parm.w = 0.3; % outlier_ratio
parm.mean_xform = 0; % translate to the mean position
parm.weight = 1;
parm.truncate_threshold = 0.19; % confidence truncate threshold
parm.opti_maxIter = 1; % max iteration for optimization
parm.opti_tolerance = 1e-1; % tolerance fot optimization
parm.neighbours = 30;
parm.alimit = 30;
parm.lambda = 0.2;

tic
xform = LSGCPD(pc_source, pc_target, parm);
time = toc;

% --------------- Visualization ---------------
pc_result = pctransform(pc_source, xform);

figure(1)
ShowPointCloudPair(pc_source, pc_target, 'backgroundColor', 'white', 'grid', 'hide', 'axis', 'hide')
figure(2)
ShowPointCloudPair(pc_result, pc_target, 'backgroundColor', 'white', 'grid', 'hide', 'axis', 'hide')