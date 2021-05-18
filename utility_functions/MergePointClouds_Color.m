function [pc_merge] = MergePointClouds_Color(pc)
% input: pc - pointClouds stored in a cell{1, num_pc} (class: cell{pointCloud})
%        type - 'array' or 'pointCloud'
% output: pc_merge - merged point cloud (class: pointCloud)
num_pc = size(pc, 2);
num_points = 0;
for i = 1 : num_pc
    num_points = num_points + size(pc{i}.Location, 1);
end
Location_merge = zeros(num_points, 3);
Color_merge = uint8(zeros(num_points, 3));
num_previous = 0;
for i = 1 : num_pc   
    Location_merge(num_previous + 1 : num_previous + size(pc{i}.Location, 1), :) = pc{i}.Location;
    Color_merge(num_previous + 1 : num_previous + size(pc{i}.Location, 1), :) = pc{i}.Color;
    num_previous = num_previous + size(pc{i}.Location, 1);
end
    pc_merge = pointCloud(Location_merge);
    pc_merge.Color = Color_merge;
end