function [ output ] = EdgeDetect( image, sigma, theta_Edge, LaplacType  )
%EdgeDetect Summary of this function goes here
%   Detailed explanation goes here

%% 1.2.1-2

n = 2 * ceil(3 * sigma) + 1;
B = strel('diamond', 1);
G = fspecial('gaussian', n, sigma);
I_sigma = imfilter(image, G, 'symmetric');

if strcmp(LaplacType, 'linear')
    % linear
    h = fspecial('log', n, sigma);
    L = imfilter(image, h, 'symmetric');
else
    % non - linear
    L = imdilate(I_sigma, B) + imerode(I_sigma, B) - 2 * I_sigma; 
end

%% 1.2.3
X = (L >= 0);
figure()
imshow(X);
Y = imdilate(X, B) - imerode(X, B);
figure()
imshow(Y);
%% 1.2.4
grad = gradient(I_sigma);
max_grad = max(grad(:));
output = (Y == 1) & (abs(grad) > theta_Edge * max_grad );