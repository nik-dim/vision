function [ output ] = HarrisDetector( image, sigma, r, thetaCorn )
%   This detector finds the image angles. It is essential that the
%   input image must have been greyscaled first.

k = 0.05;
n_s = ceil(3 * sigma) * 2 + 1;
n_r = ceil(3 * r) * 2 + 1;
G_s = fspecial('gaussian', n_s, sigma);
G_r = fspecial('gaussian', n_r, r);
I_s = imfilter(image, G_s, 'symmetric');
[I_x, I_y] = gradient(I_s);
J_1 = imfilter(I_x .* I_x, G_r, 'symmetric');
J_2 = imfilter(I_x .* I_y, G_r, 'symmetric');
J_3 = imfilter(I_y .* I_y, G_r, 'symmetric');

l_plus  = (J_1 + J_3 + sqrt((J_1 - J_3) .^ 2 + 4 * J_2 .^ 2))/2;
l_minus = (J_1 + J_3 - sqrt((J_1 - J_3) .^ 2 + 4 * J_2 .^ 2))/2;

R = l_minus .* l_plus - k * (l_plus + l_minus) .^ 2;
B_sq = strel('disk', n_s);
Cond1 = ( R == imdilate(R, B_sq) );
max_R = max(R(:));
Cond2 = ( R >= thetaCorn * max_R );
criterion = Cond1 & Cond2;

output = findInterestPoints( criterion, sigma, 0 );

end

