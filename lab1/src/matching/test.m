clc;
clear all;
close all;
%% part 3 initialization

addpath(genpath('../detectors/'));
addpath(genpath('../descriptors/'));
addpath(genpath('../matching/'));
addpath(genpath('../classification/'));
addpath(genpath('classification/libsvm-3.17/'));
addpath(genpath('../'));
% %% 3.1
detector_func = @(I) HessianDetectorMultiScale(I, 2, 0.05, 6);
descriptor_func = @(I, points) featuresSURF(I, points);

% get the requested errors, one value for each image in the dataset 
[scale_error, theta_error] = evaluation(detector_func, descriptor_func);
