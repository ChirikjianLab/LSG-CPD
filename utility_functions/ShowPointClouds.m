% LSG-CPD: CPD with Local Surface Geometry
% Visualizationo of range scanner dataset
% Author: Weixiao Liu, Hongtao Wu 
% Johns Hopkins University & National University of Singapore

function [] = ShowPointClouds(pc, varargin)
% input: 
%   pc - pointCloud
%   varargin - 'backgroundColor': 'black'(default) or 'white'
%              'grid': 'show'(default) or 'hide'
%              'axis': 'show'(default) or 'hide'
%              'dataset': 'Armadillo', 'Bunny', 'Dragon' or 'Happy'
    marker = 6;
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
        if strcmp(varargin{i}, 'dataset')
            if strcmp(varargin{i + 1}, 'Armadillo')
                view(180, 270)
            end
            if strcmp(varargin{i + 1}, 'Bunny')
                view(0, 90)
            end
            if strcmp(varargin{i + 1}, 'Dragon')
                view(0, 90)
            end
            if strcmp(varargin{i + 1}, 'Happy')
                view(0, 90)
            end
        end
    end
end