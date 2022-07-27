# LSG-CPD
This repo contains codes of CPD with Local Surface Geometry (LSG-CPD).

For all inquiries regarding the code, please contact Weixiao Liu: mpewxl@nus.edu.sg

## Publication
Weixiao Liu, [Hongtao Wu](https://hongtaowu67.github.io), [Gregory Chirikjian](https://www.eng.nus.edu.sg/me/staff/chirikjian-gregory-s/), LSG-CPD: Coherent Point Drift with Local Surface Geometry for Point Cloud Registration, Proceedings of the IEEE/CVF International Conference on Computer Vision (ICCV), 2021, pp. 15293-15302.

[[Arxiv](https://arxiv.org/abs/2103.15039)] [[Paper](https://openaccess.thecvf.com/content/ICCV2021/html/Liu_LSG-CPD_Coherent_Point_Drift_With_Local_Surface_Geometry_for_Point_ICCV_2021_paper.html)][[Supplementary](doc/supplementary.pdf)] [[Video](https://youtu.be/1lxz9Uu-GXI)] [Demo [data](https://drive.google.com/file/d/1_7v1L1O_YtVbIvRzMQKClIz3TUi5mlbE/view?usp=sharing)]

## Abstact
Probabilistic point cloud registration methods are becoming more popular because of their robustness. However, unlike point-to-plane variants of iterative closest point (ICP) which incorporate local surface geometric information such as surface normals, most probabilistic methods (e.g., coherent point drift (CPD)) ignore such information and build Gaussian mixture models (GMMs) with isotropic Gaussian covariances. This results in sphere-like GMM components which only penalize the point-to-point distance between the two point clouds. In this paper, we propose a novel method called CPD with Local Surface Geometry (LSG-CPD) for rigid point cloud registration. Our method adaptively adds different levels of point-to-plane penalization on top of the point-to-point penalization based on the flatness of the local surface. This results in GMM components with anisotropic covariances. We formulate point cloud registration as a maximum likelihood estimation (MLE) problem and solve it with the Expectation-Maximization (EM) algorithm. In the E step, we demonstrate that the computation can be recast into simple matrix manipulations and efficiently computed on a GPU. In the M step, we perform an unconstrained optimization on a matrix Lie group to efficiently update the rigid transformation of the registration. The proposed method outperforms state-of-the-art algorithms in terms of accuracy and robustness on various datasets captured with range scanners, RGBD cameras, and LiDARs. Also, it is significantly faster than modern implementations of CPD. 

## Installation
1. Install Matlab
2. Install the following matlab toolbox
    1. Computer Vision Toolbox
    2. Parallel Computing Toolbox
    3. Statistics and Machine Learning Toolbox

## Usage
0. Main codes are in ```LSGCPD.m```
1. Outlier Experiment: run  ```main_outlier.m```
2. Multi-view Experiment: in ```main_multiveiw.m```, set the model and the corresponding view number you want to play with. And just run the script.
3. Lounge Experiment: run ```main_lounge.m```
4. Kitti Experiment: run ```main_kitti.m```

## Acknowledge
Normal and curvature estimation function is cited from:
Zachary Taylor (2021). Find 3D Normals and Curvature (https://www.mathworks.com/matlabcentral/fileexchange/48111-find-3d-normals-and-curvature), MATLAB Central File Exchange. Retrieved August 4, 2021.

## TODO
- [ ] Data
- [ ] Add citation
