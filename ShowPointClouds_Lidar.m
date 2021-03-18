% LSG-CPD: CPD with Local Surface Geometry
% Visualizationo of LiDAR dataset (kitti)
% Author: Weixiao Liu, Hongtao Wu 
% Johns Hopkins University & National University of Singapore

function [] = ShowPointClouds_Lidar(pc, varargin)
% input: 
%	  pc - pointCloud
%     varargin - 'backgroundColor': 'black'(default) or 'white'
%                'grid': 'show'(default) or 'hide'
%                'axis': 'show'(default) or 'hide'
    marker = 1;
    pc.Color = uint8(180 .* eye(size(pc.Location, 1), 3));
    for i = 1 : size(varargin, 2)
      if strcmp(varargin{i}, 'MarkerSize')
          marker = varargin{i+1};
      end
    end
    pcshow(pc, 'MarkerSize', marker)
    for i = 1 : size(varargin, 2)
      if strcmp(varargin{i}, 'backgroundColor')
          if strcmp(varargin{i + 1}, 'white')
              set(gca,'color','w')
              set(gcf,'color','w')
          end
      end
      if strcmp(varargin{i}, 'grid')
          if strcmp(varargin{i + 1}, 'hide')
              grid off
          end
      end
      if strcmp(varargin{i}, 'axis')
          if strcmp(varargin{i + 1}, 'hide')
              axis off
          end
      end
end
