% LSG-CPD: CPD with Local Surface Geometry
% Demo of Multi-view experiments
% Author: Weixiao Liu, Hongtao Wu 
% Johns Hopkins University & National University of Singapore

% Armadillo - 12 views
% Dragon    - 15 views
% Happy     - 15 views

clear
clc
close all

model_name = "Happy";
num_pc = 15;

% --------------- Load data ---------------
path = strcat("data/multiview/", model_name, '/');
pc = cell(1, num_pc);

for i = 1 : num_pc
    filename = sprintf("%d.ply", i);
    pc{i} = pcread(strcat(path, filename));
end

% --------------- Initial point cloud ---------------
[pc_merge] = MergePointClouds(pc, 'pointCloud');
figure
ShowPointClouds(pc_merge, 'backgroundColor', 'white', 'grid', 'hide', 'axis', 'hide', 'dataset', model_name);
title('Randomly Initialized Point Clouds')

% --------------- Registration ---------------
parm.maxIter = 50; % EM max iteration
parm.tolerance = 1e-5; % EM loglikelihood tolerance
parm.sigma2 = 0;
parm.w = 0.5; % outlier_ratio
parm.mean_xform = 0; % translate to the mean position
parm.weight = 0;
parm.opti_maxIter = 2; % max iteration for optimization
parm.opti_tolerance = 1e-3; % tolerance fot optimization
parm.neighbours = 10;
parm.alimit = 30;
parm.lambda = 0.2;

xform_rel = cell(1, num_pc-1); % relative xform
xform_abs = cell(1, num_pc);   % absolute xform

for i = 1 : num_pc-1
    xform_rel{i} = LSGCPD(pc{i+1}, pc{i}, parm);
end

xform_abs{1} = eye(4);
for i = 1 : num_pc-1
    temp_xform_rel = xform_rel{i};
    xform_abs{i+1} = xform_abs{i} * [temp_xform_rel.Rotation', temp_xform_rel.Translation'; 0 0 0 1];
end

% --------------- Visualization ---------------
pc_result = cell(1, num_pc);
pc_result{1} = pc{1};
for i = 2 : num_pc
    temp_xform_abs = rigid3d(xform_abs{i}(1:3, 1:3)', xform_abs{i}(1:3, 4)');
    pc_result{i} = pctransform(pc{i}, temp_xform_abs);
end

pc_result_merge = MergePointClouds(pc_result, 'pointCloud');
pc_result_merge = pcdenoise(pc_result_merge, 'Threshold', 1, 'NumNeighbors', 50);
figure
ShowPointClouds(pc_result_merge, 'backgroundColor', 'white', 'grid', 'hide', 'axis', 'hide', 'dataset', model_name);