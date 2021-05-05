% LSG-CPD: CPD with Local Surface Geometry
% Demo of Outlier Experiment
% Author: Weixiao Liu, Hongtao Wu 
% Johns Hopkins University & National University of Singapore

% Source = "0503/interact/tsdf_fusion_result/tsdf.ply"
% Target = "0503/tracked_pc.ply"

% Read Data
function result = track_object(source_file, target_file)

    pc_source = pcread(source_file);
    pc_target = pcread(target_file);

    pc_source = pcdownsample(pc_source, 'gridAverage', 0.008);
    pc_target = pcdownsample(pc_target, 'gridAverage', 0.008);

    % Initial
    figure(1)
    ShowPointCloudPair(pc_target, pc_source, 'backgroundColor', 'white', 'grid', 'hide', 'axis', 'on')

    xform = LSGCPD(pc_source, pc_target, 'outlierRatio', 0.1, ...
                   'xform2center', 'true', 'maxPlaneRatio', 10);

    % Show result
    figure(2)
    pc_xform = pctransform(pc_source, xform);
    ShowPointCloudPair(pc_target, pc_xform, 'backgroundColor', 'white', 'grid', 'hide', 'axis', 'on')
    
    R = xform.Rotation;
    tran = xform.Translation;
    
    result = eye(4);
    result(1:3, 1:3) = R';
    result(1:3, 4) = tran';

end
