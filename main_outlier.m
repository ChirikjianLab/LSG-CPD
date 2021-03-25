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
ShowPointCloudPair(pc_target, pc_source, 'backgroundColor', 'white', 'grid', 'hide', 'axis', 'on')

xform = LSGCPD(pc_source, pc_target, 'outlierRatio', 0.5, ...
               'xform2center', 'true', 'maxPlaneRatio', 5);

% Show result
figure(2)
pc_xform = pctransform(pc_source, xform);
ShowPointCloudPair(pc_target, pc_xform, 'backgroundColor', 'white', 'grid', 'hide', 'axis', 'on')
