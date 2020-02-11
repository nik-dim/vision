function [ output ] = HarrisDetectorMultiScale( image, sigma_0, r_0, thetaCorn, N )
%HarrisDetectorMultiScale outputs the angles of an image as a matrix where
%each row is a different point. Each row consists of the coordinates(x,y)
%and the scale(sigma) in which the angle is identified. 
% Inputs: 
%   1. greyscale image 
%   2. differantiation scale sigma_0 (base). (scale parameter s = 1.5 by default)
%   3. integration scale r_0. (scale parameter s = 1.5 by default)
%   4. thetaCorn
%   5. N: number of scales

s = 1.5;
k = 0.05;
sigma = [];
r = [];
for i = 1:N
    sigma = [sigma s ^ (i - 1) * sigma_0];
    r = [r s ^ (i - 1) * r_0];
end

for i = 1:N    
    n_s =  ceil(3 * sigma(i)) * 2 + 1;
    n_r = ceil(3 * r(i)) * 2 + 1;
    G_s = fspecial('gaussian', n_s, sigma(i));
    G_r = fspecial('gaussian', n_r, r(i));
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
    Cond2 = ( R >= thetaCorn * max_R );
    criterion(:, :, i) = Cond1 & Cond2;
    
    [Lxx, Lxy] = gradient(I_x);
    [Lyx, Lyy] = gradient(I_y);
    
    LoG(:,:,i) = (sigma(i)^2) * abs( Lxx + Lyy );
    
end

output = findInterestPointsMulti(criterion, sigma , LoG, 0);

end

