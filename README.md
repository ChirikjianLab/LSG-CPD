# LSG-CPD
This repo contains the matlab implementation of CPD with Local Surface Geometry (LSG-CPD).

## Introduction
CPD with Local Surface Geometry is a probabilistic rigid registration method.
Compared to the original CPD (Link to CPD paper), it takes into account the local surface geometry in the construction of the Gaussian mixture models (GMM).
Main codes are contained within __LSGCPD.m__.

## Installation
1. Install Matlab
2. Install the following matlab toolbox
    1. Computer Vision Toolbox
    2. Parallel Computing Toolbox
    3. Statistics and Machine Learning Toolbox

## Usage
1. Outlier Experiment: run  __main_outlier.m__
2. Multi-view Experiment: in __main_multiveiw.m__, set the model and the corresponding view number you want to play with. And just run the script.
3. Lounge Experiment: run __main_lounge.m__
4. Kitti Experiment: run __main_kitti.m__

## Acknowledge
Normal and curvature estimation function is cited from:
Zachary Taylor (2021). Find 3D Normals and Curvature (https://www.mathworks.com/matlabcentral/fileexchange/48111-find-3d-normals-and-curvature), MATLAB Central File Exchange. Retrieved August 4, 2021.
## TODO
We are also working on implementing the method on C++. Stay tuned.
