clc;
clear all;
close all;
%% part 2 initialization
% initialize input
option = 2;
if option == 1
    imageRGB = imread('material/Caravaggio2.jpg');
else
    imageRGB = imread('material/sunflowers18.png');
end
image = im2double(rgb2gray(imageRGB));
addpath(genpath('detectors/'));
addpath(genpath('descriptors/'));

%% 2.1.1
sigma =2;
r = 2.5;
theta_corn = 0.005;
points = HarrisDetector(image, sigma, r, theta_corn);
figure()
interest_points_visualization(imageRGB, points);
set(gcf,'color','w');
output = getframe(gcf);
if option == 1
    imwrite(output.cdata, ['output/Caravaggio2_angles_uniscale_theta_corn=',strrep(num2str(theta_corn), '.', ','),'.png']);
else
    imwrite(output.cdata, ['output/sunflowers18_angles_uniscale_theta_corn=',strrep(num2str(theta_corn), '.', ','),'.png']);
end
%% 2.2
sigma = 2;
r = 2.5;
theta_corn = 0.005;
N = 4;
points = HarrisDetectorMultiScale(image, sigma, r, theta_corn, N);
figure()
interest_points_visualization(imageRGB, points);
set(gcf,'color','w');
output = getframe(gcf);
if option == 1
    imwrite(output.cdata, ['output/Caravaggio2_angles_multiscale_theta_corn=',strrep(num2str(theta_corn), '.', ','),'_N=',num2str(N),'.png']);
else
    imwrite(output.cdata, ['output/sunflowers18_angles_multiscale_theta_corn=',strrep(num2str(theta_corn), '.', ','),'_N=',num2str(N),'.png']);
end
%% 2.3
sigma = 2;
thetaBlob = 0.08;
criterion = HessianDetector(image, sigma, thetaBlob);
figure()
interest_points_visualization(imageRGB, criterion);

set(gcf,'color','w');
output = getframe(gcf);

if option == 1
    imwrite(output.cdata, ['output/Caravaggio2_Blobs_uniscale_thetaBlob=',strrep(num2str(thetaBlob), '.', ','),'.png']);
else
    imwrite(output.cdata, ['output/sunflowers18_Blobs_uniscale_thetaBlob=',strrep(num2str(thetaBlob), '.', ','),'.png']);
end
%% 2.4
N = 6;
sigma_0 = 2;
thetaBlob = 0.2;


output = HessianDetectorMultiScale(image, sigma_0, thetaBlob, N);
a_____temp = output;
% show figure and save it
figure()
interest_points_visualization(imageRGB, output);
set(gcf,'color','w');
output = getframe(gcf);
if option == 1
    imwrite(output.cdata, ['output/Caravaggio2_Blobs_multiscale_thetaBlob=',strrep(num2str(thetaBlob), '.', ','),'_N=',num2str(N),'.png']);
else
    imwrite(output.cdata, ['output/sunflowers18_Blobs_multiscale_thetaBlob=',strrep(num2str(thetaBlob), '.', ','),'_N=',num2str(N),'.png']);
end


%% 2.5.1
clear Dxx; clear Dyy; clear Dxy;
integral_image = cumsum(cumsum(image')');
%% 2.5.2
sigma = 6;
n = 2 * ceil(3 * sigma) + 1;
[ Dxx, Dyy, Dxy ] = create_boxFlters( sigma );
Lxx = xxBoxFilter(integral_image, Dxx);
Lyy = yyBoxFilter(integral_image, Dyy);
Lxy = xyBoxFilter(integral_image, Dxy);

%% 2.5.3
thetaBlob = 0.2;
n = length(Dxx);
padding = floor(n/2);
R = Lxx .* Lyy - (0.9*Lxy).^2;
R = imtranslate(R, [padding, padding]);
R = imtranslate(R, -[padding, padding]);
B_sq = strel('disk', n);
Cond1 = (R == imdilate(R, B_sq) );
% R = imtranslate(R, -[padding, padding]);
max_R = max(R(:));
Cond2 = ( R >= thetaBlob * max_R );
criterion =  Cond1 & Cond2;
output = show_interest_points(imageRGB, criterion, sigma, 10);
if option == 1
    imwrite(output.cdata, ['output/Caravaggio2_BoxFilters_uniscale_thetaBlob=',strrep(num2str(thetaBlob), '.', ','),'_sigma=',num2str(sigma),'.png']);
else
    imwrite(output.cdata, ['output/sunflowers18_BoxFilters_uniscale_thetaBlob=',strrep(num2str(thetaBlob), '.', ','),'_sigma=',num2str(sigma),'.png']);
end
%% 2.5.4
N = 6;
sigma_0 = 2;
thetaBlob = 0.2;

output = BoxFilterDetectorMultiScale(image, sigma_0, thetaBlob, N);
temp = output;
% show figure and save it
figure()
interest_points_visualization(imageRGB, output);
set(gcf,'color','w');
output = getframe(gcf);
if option == 1
    imwrite(output.cdata, ['output/Caravaggio2_BoxFilters_multiscale_thetaBlob=',strrep(num2str(thetaBlob), '.', ','),'_N=',num2str(N),'.png']);
else
    imwrite(output.cdata, ['output/sunflowers18_BoxFilters_multiscale_thetaBlob=',strrep(num2str(thetaBlob), '.', ','),'_N=',num2str(N),'.png']);
end
