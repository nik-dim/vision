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
R = cov(Cb, Cr);         % covariance matrix
clear skinSamplesRGB image skin Cb Cr Cb_mean Cr_mean temp 
%% part 2
dx0 = 0;
dy0 = 0;
rho = 3;
epsilon = 0.05;

% read first image and find bounding box of face
I_0 = im2double(imread('GreekSignLanguage/1.png'));
bb0 = fd(I_0, mu, R);
% there is no need to convert to YCbCr. This color space 
% is only needed to detect the face because of the color 
% properties of human skin
im_0 = rgb2gray(I_0);

%%%%%%%%%%%%%%%%%%%%%%%%
% Image = rgb2ycbcr(I_0);
% Cb = Image(:,:,2);
% temp = I_0(:,:,3);
% Cr = temp(:);
% I_0 = [Cb Cr];
%%%%%%%%%%%%%%%%%%%%%%%%

%read second image
I_1 = im2double(imread('GreekSignLanguage/2.png'));
bb1 = fd(I_1, mu, R);
im_1 = rgb2gray(I_1);

% show the faces detected from first two frames
% figure()
face_0 = I_0(bb0(2):(bb0(2)+bb0(4)), bb0(1):(bb0(1)+bb0(3)));
% subplot(1,2,1);
% imshow(face_0);
% title('First Frame');
face_1 = I_1(bb0(2):(bb0(2)+bb0(4)), bb0(1):(bb0(1)+bb0(3)));
% subplot(1,2,2)
% imshow(face_1);
% title('Second Frame');


%% PART 2.1
% Lucas Kanade algorithm
[ d_x, d_y ] = lk(face_0, face_1, rho, epsilon, 0, 0);
d_x_r = imresize(d_x, 0.3);
d_y_r = imresize(d_y, 0.3);
% optical flow velocity plot
figure()
quiver(-d_x_r, -d_y_r);
set(gca,'DataAspectRatio',[1 1 1])

%% PART 2.2 
% The necessary steps for detecting the face of frame 2 using
% the preprocessing of part 1 to detect the face for frame 1
[displ_x, displ_y] = displ(d_x , d_y);
% find the new rectangle. the size of the box 
% does not change! Only /its position
bb0 = bb0 - [displ_x, displ_y, 0 ,0];     


% the algorithm is iterated for all the images 
faceOld = I_1(bb0(2):(bb0(2)+bb0(4)), bb0(1):(bb0(1)+bb0(3)));
noOfImages = 66;
for i = 3:noOfImages
    image = rgb2gray(im2double(imread(['GreekSignLanguage/',num2str(i),'.png'])));
    faceNew = image(bb0(2):(bb0(2)+bb0(4)), bb0(1):(bb0(1)+bb0(3)));
    [ d_x, d_y ] = lk(faceOld, faceNew, rho, epsilon, 0, 0);
    [displ_x, displ_y] = displ(d_x , d_y);
    bb0 = bb0 - [displ_x, displ_y, 0 ,0];  
    faceOld = faceNew;
end
%%% TEST 2.2
figure()
subplot(1,2,1);
imshow(face_0);
title('First Frame', 'Interpreter', 'latex','FontSize', 20);
subplot(1,2,2)
imshow(faceNew);
title('Last Frame', 'Interpreter', 'latex','FontSize', 20);


%% PART 2.3
clear d_x d_y
scale = 2;
image = im2double(imread(['GreekSignLanguage/1.png']));
bb0 = fd(image, mu, R);
image = rgb2gray(image);
faceOld = image(bb0(2):(bb0(2)+bb0(4)), bb0(1):(bb0(1)+bb0(3)));
for i = 2:noOfImages
    image = rgb2gray(im2double(imread(['GreekSignLanguage/',num2str(i),'.png'])));
    faceNew = image(bb0(2):(bb0(2)+bb0(4)), bb0(1):(bb0(1)+bb0(3)));
    % multi_scaled Lukas Kanade
    [ d_x, d_y ] = lk_multi(faceOld, faceNew, rho, epsilon, scale);
    [displ_x, displ_y] = displ(d_x , d_y);
    bb0 = bb0 - [displ_x, displ_y, 0 ,0]; 
    faceOld = faceNew;
end

%%% TEST 2.3
figure()
subplot(1,2,1);
imshow(face_0);
title('First Frame', 'Interpreter', 'latex','FontSize', 20);
subplot(1,2,2)
imshow(faceNew);
title('Last Frame', 'Interpreter', 'latex','FontSize', 20);
