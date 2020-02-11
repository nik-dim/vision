clear all;
close all;
clc;
%% part1: find skin distribution from mat file
addpath(genpath('cv18_lab2_material'));
skinSamplesRGB = open('skinSamplesRGB.mat');
image = im2double(skinSamplesRGB.skinSamplesRGB);
% imshow(image);
skin = rgb2ycbcr(image);
temp = skin(:,:,2);
Cb = temp(:);
temp = skin(:,:,3);
Cr = temp(:);
Cb_mean = mean(Cb);    
Cr_mean = mean(Cr);
mu = [Cb_mean Cr_mean];  % find mean of Cb and Cr
R = cov(Cb, Cr);        % covariance matrix   
