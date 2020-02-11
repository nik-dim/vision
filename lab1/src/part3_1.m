clc;
clear all;
close all;
%% Part 3 initialisation
addpath(genpath('detectors/'));
addpath(genpath('descriptors/'));
addpath(genpath('matching/'));
addpath(genpath('classification/'));
%% 3.1
i = 1;
N = 4;
sigma_0 = 2;
r_0 = 2.5;
thetaBlob = 0.2;
thetaCorn = 0.005;
%%
detector_func = @(I) HarrisDetector(I, sigma_0, r_0, thetaCorn);
descriptor_func = @(I, points) featuresHOG(I, points);
[scale_error(i, :),theta_error(i, :)] = evaluation(detector_func,descriptor_func);


%%
i = i + 1;
detector_func = @(I) HarrisDetectorMultiScale(I, sigma_0, r_0, thetaCorn, N);
descriptor_func = @(I, points) featuresHOG(I, points);
[scale_error(i, :),theta_error(i, :)] = evaluation(detector_func,descriptor_func);

%%
i = i + 1;
detector_func = @(I) HessianDetector(I, sigma_0, thetaBlob);
descriptor_func = @(I, points) featuresHOG(I, points);
[scale_error(i, :),theta_error(i, :)] = evaluation(detector_func,descriptor_func);

%%
i = i + 1;
detector_func = @(I) HessianDetectorMultiScale(I, sigma_0, thetaBlob, N);
descriptor_func = @(I, points) featuresHOG(I, points);
[scale_error(i, :),theta_error(i, :)] = evaluation(detector_func,descriptor_func);

%%
i = i + 1;
detector_func = @(I) BoxFilterDetectorMultiScale(I, sigma_0, thetaBlob, 4);
descriptor_func = @(I, points) featuresHOG(I, points);
[scale_error(i, :),theta_error(i, :)] = evaluation(detector_func,descriptor_func);

%%
i = i + 1;
detector_func = @(I) HarrisDetector(I, sigma_0, r_0, thetaCorn);
descriptor_func = @(I, points) featuresSURF(I, points);
[scale_error(i, :),theta_error(i, :)] = evaluation(detector_func,descriptor_func);

%%
i = i + 1;
detector_func = @(I) HarrisDetectorMultiScale(I, sigma_0, r_0, thetaCorn, N);
descriptor_func = @(I, points) featuresSURF(I, points);
[scale_error(i, :),theta_error(i, :)] = evaluation(detector_func,descriptor_func);

%%
i = i + 1;
detector_func = @(I) HessianDetector(I, sigma_0, thetaBlob);
descriptor_func = @(I, points) featuresSURF(I, points);
[scale_error(i, :),theta_error(i, :)] = evaluation(detector_func,descriptor_func);

%%
i = i + 1;
detector_func = @(I) HessianDetectorMultiScale(I, sigma_0, thetaBlob, N);
descriptor_func = @(I, points) featuresSURF(I, points);
[scale_error(i, :),theta_error(i, :)] = evaluation(detector_func,descriptor_func);

%%
i = i + 1;
detector_func = @(I) BoxFilterDetectorMultiScale(I, sigma_0, thetaBlob, 4);
descriptor_func = @(I, points) featuresSURF(I, points);
[scale_error(i, :),theta_error(i, :)] = evaluation(detector_func,descriptor_func);

%%
save('ScaleErrors.mat', 'scale_error');
save('ThetaErrors.mat', 'theta_error');