clc;
clear all;
close all;
%% 1.1.1
% initialize input
I_0 = imread('material/edgetest_18.png');
% I_0 = rgb2gray(imread('material/Sketch.png'));
figure(1);
title('Original Image');
imshow(I_0);

%% 1.1.2
%   the computation of sigma to achieve the desired PSNR is explained in
%   the report
    
% PSNR = 20
[ I_20_int, PSNR_20 ] = I_noise(I_0, 0.1);

% PSNR = 10
[ I_10_int, PSNR_10 ] = I_noise(I_0, 0.316227);

%% 1.2
% The section 1.2 is implemented in the function "EdgeDetect"
sigma = 1.5; theta_edge = 0.2;

D_linear = EdgeDetect(I_20_int, sigma, theta_edge, 'linear');
figure()
imshow(D_linear);
title('Linear');

D_nonlinear = EdgeDetect(I_20_int, sigma, theta_edge, 'non linear');
figure()
imshow(D_nonlinear);
title('NON Linear');

%% 1.3.1
theta_realEdge = 20;
B = strel('diamond', 1);
M = imdilate(I_0, B) - imerode(I_0, B);
T = ( M > theta_realEdge );
figure()
imshow(T);

%% 1.3.2
C_linear = criterion(D_linear, T);
C_nonlinear = criterion(D_nonlinear, T);
