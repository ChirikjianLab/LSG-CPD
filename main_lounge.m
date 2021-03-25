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

tic
xform = LSGCPD(pc_source, pc_target, 'outlierRatio', 0.07);
time = toc;

% --------------- Visualization ---------------
pc_result = pctransform(pc_source, xform);

figure(1)
ShowPointCloudPair(pc_source, pc_target, 'backgroundColor', 'white', 'grid', 'hide', 'axis', 'hide')
figure(2)
ShowPointCloudPair(pc_result, pc_target, 'backgroundColor', 'white', 'grid', 'hide', 'axis', 'hide')