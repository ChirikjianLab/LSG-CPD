% testing script for TUM
% written by Weixiao Liu, JHU, NUS
% on Feb 25, 2021

%% Read Data
clc
clear
close all

% read point clouds
[file,path] = uigetfile('*.ply','Please select the point cloud files', ...
    '/home/saintsbury/Dropbox/Datasets', 'MultiSelect','on');
if isequal(file,0)
    error('No point cloud selected.');
end

num_pc = size(file, 2);
pc = cell(1, num_pc);
pc_raw = cell(1, num_pc);
pc_file = cell(1, num_pc);
disp(['Point cloud selection finished. Total number of point clouds is ', num2str(num_pc), '.']);
disp('-----------------------------------------------------------------')

%% Downsampling

downsample = 1;
downsample_ratio = 0.2;

num_points = zeros(num_pc, 1);
if downsample == 0
    for i = 1 : num_pc
        pc{i} = pcread([path file{i}]);
        pc_file{i} = file{i};
        pc_raw{i} = pc{i};
        num_points(i) = size(pc{i}.Location, 1);
    end
else
    for i = 1 : num_pc
        pc_raw{i} = pcread([path file{i}]);
        pc_file{i} = file{i};
        pc{i} = pcdownsample(pc_raw{i},'gridAverage',downsample_ratio);
        num_points(i) = size(pc{i}.Location, 1);
    end
end
disp(['Average number of points after downsampling is ', num2str(mean(num_points)), '.'])
disp(['Minimum number of points after downsampling is ', num2str(min(num_points)), '.'])
disp(['Maximum number of points after downsampling is ', num2str(max(num_points)), '.'])
disp('-----------------------------------------------------------------')

%% Point Clouds before Registration

if ~isempty(pc{1}.Color)
    pc_merge_raw = MergePointClouds_Color(pc_raw);
    ShowPointClouds(pc_merge_raw, 'backgroundColor', 'white', 'grid', 'hide', 'axis', 'hide')
else
    pc_merge_raw = MergePointClouds(pc_raw, 'pointCloud');
    ShowPointClouds(pc_merge_raw, 'backgroundColor', 'white', 'grid', 'hide', 'axis', 'hide')
end

%% Pairwise Registration

verbose = 1;

xform_rel = cell(1, num_pc-1); % relative xform
xform_abs = cell(1, num_pc);   % absolute xform

for i = 1 : num_pc-1
    xform_rel{i} = LSGCPD(pc{i+1}, pc{i}, 'outlierRatio', 0.1, 'maxPlaneRatio', 10);
    if verbose == 1
        disp([num2str(i), ' out of ', num2str(num_pc - 1), ' Aligned.'])
    end
end

xform_abs{1} = eye(4);
for i = 1 : num_pc-1
    temp_xform_rel = xform_rel{i};
    xform_abs{i+1} = xform_abs{i} * [temp_xform_rel.Rotation', temp_xform_rel.Translation'; 0 0 0 1];
end

%% Visualization

pc_result = cell(1, num_pc);
pc_result{1} = pc{1};
for i = 2 : num_pc
    temp_xform_abs = rigid3d(xform_abs{i}(1:3, 1:3)', xform_abs{i}(1:3, 4)');
    pc_result{i} = pctransform(pc_raw{i}, temp_xform_abs);
end

if ~isempty(pc{1}.Color)
    pc_result_merge = MergePointClouds_Color(pc_result);
else
    pc_result_merge = MergePointClouds(pc_result, 'pointCloud');
end

ShowPointClouds(pc_result_merge, 'backgroundColor', 'white', 'grid', 'hide', 'axis', 'hide');








