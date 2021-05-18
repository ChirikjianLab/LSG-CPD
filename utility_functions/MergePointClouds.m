% LSG-CPD: CPD with Local Surface Geometry
% Merging point clouds together
% Author: Weixiao Liu, Hongtao Wu 
% Johns Hopkins University & National University of Singapore

function [pc_merge] = MergePointClouds(pc, type)
% input: 
%   pc (array or pointCloud): pointClouds stored in a cell{1, num_pc} (class: cell{pointCloud})
% output: 
%   pc_merge (pointCloud)- merged point cloud
	num_pc = size(pc, 2);
	num_points = 0;
	for i = 1 : num_pc
	num_points = num_points + size(pc{i}.Location, 1);
	end
	Location_merge = zeros(num_points, 3);
	num_previous = 0;
	for i = 1 : num_pc
	Location_merge(num_previous + 1 : num_previous + size(pc{i}.Location, 1), :) = pc{i}.Location;
	num_previous = num_previous + size(pc{i}.Location, 1);
	end
	if strcmp(type, 'pointCloud')
	pc_merge = pointCloud(Location_merge);
	else
	if strcmp(type, 'array')
	    pc_merge = Location_merge;
	else
	    error('TYPE not supported. Please select either array or pointCloud.')
	end
	end
end
