% LSG-CPD: CPD with Local Surface Geometry
% Demo of Outlier Experiment
% Author: Weixiao Liu, Hongtao Wu 
% Johns Hopkins University & National University of Singapore

%--------------- Load Data ---------------
clc
clear
close all

% Load point cloud
path = "data/kitti/Sequence_07/";
num_pc = 551;
pc = cell(1, num_pc);
pc_file = cell(1, num_pc);

for i = 1 : num_pc
    filename = sprintf("Downsampled/%06d.ply", 2*(i-1));
    pc{i} = pcread(strcat(path, filename));
end

% Loading ground truth
interval = 2;
file = "07.txt";
gt_xform_info = table2array(readtable(strcat(path, file)));
g_gt = cell(1, num_pc);

for i = 1 : num_pc
    g_gt{i} = [reshape(gt_xform_info(interval * (i - 1) + 1, :)', 4, 3)'; 0 0 0 1];
end

% Show ground truth alignment
pc_gt = cell(1, num_pc);
xform_gt = cell(1, num_pc);

for i = 1 : num_pc      
    xform_gt{i} = rigid3d(single(g_gt{i}(1 : 3, 1 : 3)'), single(g_gt{i}(1 : 3, 4)'));
    pc_gt{i} = pctransform(pc{i}, xform_gt{i});
end

figure(1)
pc_gt_merge = MergePointClouds(pc_gt, 'pointCloud');
pcshow(pc_gt_merge)

% Draw ground truth trajectory
Traj_gt = zeros(3, num_pc);
Mileage_gt = 0;

for i = 1 : num_pc
    Traj_gt(:, i) = g_gt{i}(1 : 3, 4);   
end
for i = 1 : num_pc - 1
    Mileage_gt = Mileage_gt + norm(Traj_gt(:, i + 1) - Traj_gt(:, i));
end
hold on
plot3(Traj_gt(1, :), Traj_gt(2, :), Traj_gt(3, :), 'r', 'LineWidth', 3)
hold off

% Show Merged Point Cloud before Registration
figure(2)
pc_init = MergePointClouds(pc, 'pointCloud');
pcshow(pc_init)

%--------------- Registration ---------------
parm.maxIter = 50; % EM max iteration
parm.tolerance = 1e-2; % EM loglikelihood tolerance
parm.sigma2 = 0; % sigma is autonomously evaluated
parm.w = 0.5; % outlier_ratio
parm.mean_xform = 0; % translate to the mean position
parm.rescale = 0;
parm.weight = 0;
parm.opti_maxIter = 2; % max iteration for optimization
parm.opti_tolerance = 1e-3; % tolerance fot optimization
parm.neighbours = 10; % Neighbour
parm.alimit = 30; % Alpha max
parm.lambda = 0.2; % lambda

verbose = input('Verbose? 1-Yes; 0-No: ');
g_relative = cell(1, num_pc - 1);
xform = cell(1, num_pc - 1);

tic
for i = 1 : num_pc - 1
    [xform{i}] = LSGCPD(pc{i + 1}, pc{i}, parm);
    g_relative{i} = single([xform{i}.Rotation', xform{i}.Translation'; 0, 0, 0, 1]);
    
    if verbose == 1
        disp(['Progress: ', num2str(i), '/' num2str(num_pc - 1), ';'])
    end
end
toc
disp('LPP time comsumption')


% --------------- Result Visualization ---------------
% align to the first frame and generate xformed pc
pc_xform = cell(1, num_pc);
g_absolute = cell(1, num_pc);

pc_xform{1} = pc{1};
g_absolute{1} = single(eye(4));

for i = 1 : num_pc - 1      
    g_absolute{i + 1} = single(g_absolute{i}) * single(g_relative{i});
    pc_xform{i + 1} = pointCloud((g_absolute{i + 1}(1 : 3, 1 : 3) * pc{i + 1}.Location' + g_absolute{i + 1}(1 : 3, 4))');
end

% merge and visualize
[pc_merge] = pcdownsample(MergePointClouds(pc_xform, 'pointCloud'), 'gridAverage', 1.2);
figure(6)
% pcshow(pc_merge)
ShowPointClouds_Lidar(pc_merge, 'backgroundColor', 'white', 'grid', 'hide', 'axis', 'hide');
view(0, 0)

% Draw registrated trajectory
Traj_reg = zeros(3, num_pc);
Mileage = 0;

for i = 1 : num_pc
    Traj_reg(:, i) = g_absolute{i}(1 : 3, 4);   
end
for i = 1 : num_pc - 1
    Mileage = Mileage + norm(Traj_reg(:, i + 1) - Traj_reg(:, i));
end
hold on
plot3(Traj_reg(1, :), Traj_reg(2, :), Traj_reg(3, :), 'b', 'LineWidth', 3)
hold off

% Draw ground truth trajectory
Traj_gt = zeros(3, num_pc);
Mileage_gt = 0; % Range

for i = 1 : num_pc
    Traj_gt(:, i) = g_gt{i}(1 : 3, 4);   
end
for i = 1 : num_pc - 1
    Mileage_gt = Mileage_gt + norm(Traj_gt(:, i + 1) - Traj_gt(:, i));
end
hold on
plot3(Traj_gt(1, :), Traj_gt(2, :), Traj_gt(3, :), 'r', 'LineWidth', 3)
hold off

% --------------- Compute Error ---------------
% average absolute error
error_trans = zeros(1, num_pc);
error_rot = zeros(1, num_pc);
mileage_gt = zeros(1, num_pc);
relative_error = zeros(1, 6);
j = 1;
for i = 1 : num_pc
   error_trans(i) =  norm(g_gt{i}(1 : 3, 4)-g_absolute{i}(1 : 3, 4));
   rot_logm = logm(g_gt{i}(1 : 3, 1 : 3)' * g_absolute{i}(1 : 3, 1 : 3));
   error_rot(i) =  norm([-rot_logm(2, 3), rot_logm(1, 3), -rot_logm(1, 2)]) * 180 / pi; % in degree;
   if i == 1
       mileage_gt(i) = norm(g_gt{i}(1 : 3, 4));
   else
       mileage_gt(i) = mileage_gt(i - 1) + norm(g_gt{i}(1 : 3, 4) - g_gt{i - 1}(1 : 3, 4));      
   end
end
average_trans = mean(error_trans);
average_rot = mean(error_rot);
max_trans = max(error_trans);
max_rot = max(error_rot);

disp(['Average absolute translation error is ', num2str(average_trans), ' m.' ])
disp(['Average absolute rotation error is ', num2str(average_rot), ' degree.' ])
disp(['Max absolute translation error is ', num2str(max_trans), ' m.' ])
disp(['Max absolute rotation error is ', num2str(max_rot), ' degree.' ])
disp(['Last frame translation error is ', num2str(error_trans(num_pc)), ' m.' ])
disp(['Last frame rotation error is ', num2str(error_rot(num_pc)), ' degree.' ])

% average relative error
error_trans_relative = zeros(1, num_pc - 1);
error_rot_relative = zeros(1, num_pc - 1);
for i = 1 : num_pc - 1
    g_gt_relative = g_gt{i} \ eye(4) * g_gt{i + 1};
    error_trans_relative(i) = norm(g_gt_relative(1 : 3, 4)-g_relative{i}(1 : 3, 4));
    rot_logm = logm(g_gt_relative(1 : 3, 1 : 3)' * g_relative{i}(1 : 3, 1 : 3));
    error_rot_relative(i) = norm([-rot_logm(2, 3), rot_logm(1, 3), -rot_logm(1, 2)]) * 180 / pi; % in degree
end
x = linspace(1,num_pc - 1, num_pc - 1);
figure(7)
plot(x, error_trans_relative);
hold on
plot(x, error_rot_relative);
average_trans_relative = mean(error_trans_relative);
average_rot_relative = mean(error_rot_relative);
max_trans_relative = max(error_trans_relative);
max_rot_relative = max(error_rot_relative);

disp(['Average relative translation error is ', num2str(average_trans_relative), ' m.' ])
disp(['Average relative rotation error is ', num2str(average_rot_relative), ' degree.' ])
disp(['Max relative translation error is ', num2str(max_trans_relative), ' m.' ])
disp(['Max relative rotation error is ', num2str(max_rot_relative), ' degree.' ])