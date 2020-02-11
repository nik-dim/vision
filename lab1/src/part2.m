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

sigma = 2;
n = 2 * ceil(3 * sigma) + 1;
thetaBlob = 0.2;
G = fspecial('gaussian', n, sigma);
I_sigma = imfilter(image, G, 'symmetric');
%% 2.1.1
%We compute the matrices J_1, J_2, J_3 which are needed in order to
%implement the Harris-Stephens method
%parameters
sigma = 2;
r = 2.5;
k = 0.05;
theta_corn = 0.005;
s = 1.5;
N = 6;

%Computation of J_1, J_2 and J_3
n_s = ceil(3 * sigma) * 2 + 1;
n_r = ceil(3 * r) * 2 + 1;

G_s = fspecial('gaussian', n_s, sigma);
G_r = fspecial('gaussian', n_r, r);

I_s = imfilter(image, G_s, 'symmetric');

[I_x, I_y] = gradient(I_s);

temp1 = I_x .* I_x;
temp2 = I_x .* I_y;
temp3 = I_y .* I_y;

J_1 = imfilter(temp1, G_r, 'symmetric');
J_2 = imfilter(temp2, G_r, 'symmetric');
J_3 = imfilter(temp3, G_r, 'symmetric');

%% 2.1.2
%We now calculate the eigenvalues of the tensor J

l_plus  = (J_1 + J_3 + sqrt((J_1 - J_3) .^ 2 + 4 * J_2 .^ 2))/2;
l_minus = (J_1 + J_3 - sqrt((J_1 - J_3) .^ 2 + 4 * J_2 .^ 2))/2;

%% 2.1.3
%Now we are going to calculate the matrix R and then we will find which of
%its elements fulfil conditions 1 and 2

R = l_minus .* l_plus - k * (l_plus + l_minus) .^ 2;

B_sq = strel('disk', n_s);
Cond1 = ( R == imdilate(R, B_sq) );

max_R = max(R(:));
Cond2 = ( R >= theta_corn * max_R );

criterion = Cond1 & Cond2;

output = show_interest_points(imageRGB, criterion, sigma, 0);
if option == 1
    imwrite(output.cdata, ['output/Caravaggio2_angles_uniscale_theta_corn=',strrep(num2str(theta_corn), '.', ','),'.png']);
else
    imwrite(output.cdata, ['output/sunflowers18_angles_uniscale_theta_corn=',strrep(num2str(theta_corn), '.', ','),'.png']);
end
%% 2.2

sigma_vector = [];
r_vector = [];
for i = 1:N
    sigma_vector = [sigma_vector s ^ (i - 1) * sigma];
    r_vector = [r_vector s ^ (i - 1) * r];
end

for i = 1:N
    sigma = sigma_vector(i);
    r = r_vector(i);
        
    n_s =  ceil(3 * sigma) * 2 + 1;
    n_r = ceil(3 * r) * 2 + 1;

    G_s = fspecial('gaussian', n_s, sigma);
    G_r = fspecial('gaussian', n_r, r);

    I_s = imfilter(image, G_s, 'symmetric');

    [I_x, I_y] = gradient(I_s);

    J_1 = imfilter(I_x .* I_x, G_r, 'symmetric');
    J_2 = imfilter(I_x .* I_y, G_r, 'symmetric');
    J_3 = imfilter(I_y .* I_y, G_r, 'symmetric');

    l_plus = (J_1 + J_3 + sqrt((J_1 - J_3) .^ 2 + 4 * J_2 .^ 2))/2;
    l_minus = (J_1 + J_3 - sqrt((J_1 - J_3) .^ 2 + 4 * J_2 .^ 2))/2;

    R = l_minus .* l_plus - k * (l_plus + l_minus) .^ 2;

    B_sq = strel('disk', n_s);
    Cond1 = ( R == imdilate(R, B_sq) );

    max_R = max(R(:));
    Cond2 = ( R >= theta_corn * max_R );

    criterion(:, :, i) = Cond1 & Cond2;
    
    [Lxx, Lxy] = gradient(I_x);
    [Lyx, Lyy] = gradient(I_y);
    
    LoG(:,:,i) = (sigma_vector(i)^2) * abs( Lxx + Lyy );
    
end

output = show_interest_points_multi( imageRGB, criterion, sigma_vector , LoG, 0);
if option == 1
    imwrite(output.cdata, ['output/Caravaggio2_angles_multiscale_theta_corn=',strrep(num2str(theta_corn), '.', ','),'_N=',num2str(N),'.png']);
else
    imwrite(output.cdata, ['output/sunflowers18_angles_multiscale_theta_corn=',strrep(num2str(theta_corn), '.', ','),'_N=',num2str(N),'.png']);
end
%% 2.3.1
sigma = 2;
thetaBlob = 0.2;
n = 2 * ceil(3 * sigma) + 1;
[Lx, Ly] = gradient(double(I_sigma));
[Lxx, Lxy] = gradient(Lx);
[Lyx, Lyy] = gradient(Ly); % there is actually no need to compute Gxy because Gxy=Gyx
Hessian = [Lxx Lxy ; Lyx Lyy];

R = (Lxx .* Lyy) - (Lyx .* Lxy);
%% 2.3.2
B_sq = strel('disk', n);
Cond1 = (R == imdilate(R, B_sq) );
grad = gradient(double(I_sigma));
max_R = max(R(:));
Cond2 = ( R >= thetaBlob * max_R );
criterion =  Cond1 & Cond2;

output = show_interest_points(imageRGB, criterion, sigma, 0);
if option == 1
    imwrite(output.cdata, ['output/Caravaggio2_Blobs_uniscale_thetaBlob=',strrep(num2str(thetaBlob), '.', ','),'.png']);
else
    imwrite(output.cdata, ['output/sunflowers18_Blobs_uniscale_thetaBlob=',strrep(num2str(thetaBlob), '.', ','),'.png']);
end
%% 2.4.1
N = 6;
s = 1.5;
for i = 1:N
    if i == 1
        sigma(1) = 2;
    else
        sigma(i) =  sigma(i-1) * s; 
    end
    n(i) = 2 * ceil(3 * sigma(i)) + 1; 
    G = fspecial('gaussian', n(i), sigma(i));
    I_sigma(:,:,i) = imfilter(image, G, 'symmetric');
    
    [Lx, Ly] = gradient(double(I_sigma(:,:,i)));
    [Lxx, Lxy] = gradient(Lx);
    [Lyx, Lyy] = gradient(Ly); % there is actually no need to compute Gxy because Gxy=Gyx
    Hessian = [Lxx Lxy ; Lyx Lyy];
    LoG(:,:,i) = (sigma(i)^2) * abs( Lxx + Lyy );
    R = (Lxx .* Lyy) - (Lyx .* Lxy);
    B_sq(i) = strel('disk', n(i));
    Cond1 = (R == imdilate(R, B_sq(i)) );
    
    max_R = max(R(:));
    Cond2 = ( R >= thetaBlob * max_R );
    criterion(:,:,i) =  Cond1 & Cond2;
end

output = show_interest_points_multi( imageRGB, criterion, sigma , LoG, 0);
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
Lxx = xxIntegralImageBoxFilter(integral_image, Dxx);
Lyy = yyIntegralImageBoxFilter(integral_image, Dyy);
Lxy = xyIntegralImageBoxFilter(integral_image, Dxy);

%% 2.5.3
R = Lxx .* Lyy - (0.9*Lxy).^2;
B_sq = strel('disk', n);
Cond1 = (R == imdilate(R, B_sq) );

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
s = 1.5;
for i = 1:N
    if i == 1
        sigma(1) = 2;
    else
        sigma(i) =  sigma(i-1) * s; 
    end
    n(i) = 2 * ceil(3 * sigma(i)) + 1; 
    [ Dxx, Dyy, Dxy ] = create_boxFlters( sigma(i) );
    Lxx = xxIntegralImageBoxFilter(integral_image, Dxx);
    Lyy = yyIntegralImageBoxFilter(integral_image, Dyy);
    Lxy = xyIntegralImageBoxFilter(integral_image, Dxy);
    LoG(:,:,i) = (sigma(i)^2) * abs( Lxx + Lyy );
    R = Lxx .* Lyy - (0.9*Lxy).^2;
    B_sq(i) = strel('disk', n(i));
    Cond1 = (R == imdilate(R, B_sq(i)) );
    
    max_R = max(R(:));
    Cond2 = ( R >= thetaBlob * max_R );
    criterion(:,:,i) =  Cond1 & Cond2;
end

output = show_interest_points_multi( imageRGB, criterion, sigma , LoG, 20);
if option == 1
    imwrite(output.cdata, ['output/Caravaggio2_BoxFilters_multiscale_thetaBlob=',strrep(num2str(thetaBlob), '.', ','),'_N=',num2str(N),'.png']);
else
    imwrite(output.cdata, ['output/sunflowers18_BoxFilters_multiscale_thetaBlob=',strrep(num2str(thetaBlob), '.', ','),'_N=',num2str(N),'.png']);
end

%% print Box filters and simple integral image
% [k l] = size(Dxy);
% z = 2*ones(k,l);
% Dxy_out = (z + Dxy)/3;
% [kf l] = size(Dyy);
% z = ones(k,l);
% Dyy_out = (z + Dyy)/2;
% [k l] = size(Dxx);
% z = ones(k,l);
% Dxx_out = (z + Dxx)/2;
% figure()
% subplot(2,2,1); imshow(Dxx_out); title('Dxx');
% subplot(2,2,2); imshow(Dxy_out); title('Dxy');
% subplot(2,2,3); imshow(Dxy_out); title('Dyx');
% subplot(2,2,4); imshow(Dyy_out); title('Dyy');
% print -djpeg output/BoxFilters.jpg
% figure()
% in = ones(1000);
% o = cumsum(cumsum(in')');
% imshow(o/max(o(:)))
% print -djpeg output/SimpleIntegralImage.jpg

% Lxx = imfilter(image, Dxx, 'symmetric');
% figure()
% imshow(Lxx);
% title('Lxx kanoniko');
% Lyy = imfilter(image, Dyy, 'symmetric');
% figure()
% imshow(Lyy);
% title('Lyy kanoniko');
% Lxy = imfilter(image, Dxy, 'symmetric');
% figure()
% imshow(Lxy);
% title('Lxy kanoniko');
