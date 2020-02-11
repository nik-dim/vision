function [ points ] = Harris_Detector_3D( video, sigma, taf, integ_sigma, integ_taf, k, theta_corn )
%Harris_Detector_3D is a function that finds the interest points
%(more precisely angles) in a video.
% ---> Input Arguments:
%         video:    input video as a 3D matrix
%         sigma:    scaling coefficient for 2D Gaussian Space Filter
%         taf:      scaling coefficient for 1D Gaussian Time Filter
%         integ_sigma:  integral coefficient for 2D Gaussian Integral Filter
%         integ_taf:    integral coefficient for 1D Gaussian Integral Filter
%         k: Harris     method coefficient
%         theta_corn:   Harris Method coefficient
% ---> Output Arguments:
%         M:        Binary Video
%         points:   interest points as a Nx4 Matrix
%--------------------------------------------------------------------------

% 2D Gaussian Space Filter
space_window_size = 2 * ceil(3 * sigma) + 1 ;
G_s = fspecial('gaussian', [space_window_size, space_window_size], sigma);

% 1D Gaussian Time Filter
time_window_size = 2 * ceil(3 * taf) + 1 ;
G_t(1,1,:) = gausswin(time_window_size, taf);

% 3D Gaussian Filter
G = convn(G_s, G_t, 'same');

% Apply Gaussian 3D Filter to the video
filtered_vid = im2double(imfilter(video, G, 'symmetric'));

% Gradients
dif_kernel = [-1 0 1]';
dif_kernel_t(1, 1, :) = [-1 0 1];
Fx = imfilter(filtered_vid, dif_kernel, 'symmetric');
Fy = imfilter(filtered_vid, dif_kernel', 'symmetric');
Ft = imfilter(filtered_vid, dif_kernel_t, 'symmetric');

% Integral Scaling Filters
% 2D Gaussian Space Integral Scaling Filter
space_window_size = 2 * ceil(3 * integ_sigma) + 1 ;
G_s = fspecial('gaussian', [space_window_size, space_window_size], integ_sigma);

% 1D Gaussian Time Integral Scaling Filter
clear G_t
time_window_size = 2 * ceil(3 * integ_taf) + 1 ;
G_t(1,1,:) = gausswin(time_window_size, integ_taf);

% 3D Gaussian Integral Scaling Filter
G = convn(G_s, G_t, 'same');

% Harris Method
J_x_x = imfilter(Fx .^ 2, G, 'symmetric');
J_y_y = imfilter(Fy .^ 2, G, 'symmetric');
J_t_t = imfilter(Ft .^ 2, G, 'symmetric');

J_x_y = imfilter(Fx .* Fy, G, 'symmetric');
J_y_t = imfilter(Fy .* Ft, G, 'symmetric');
J_t_x = imfilter(Ft .* Fx, G, 'symmetric');

det = J_x_x .* ( J_y_y .* J_t_t - J_y_t .^ 2 ) - J_x_y .* ( J_x_y .* J_t_t - J_y_t .* J_t_x ) + J_t_x .* ( J_x_y .* J_y_t - J_t_x .* J_y_y );

H = det - k * (J_x_x + J_y_y + J_t_t) .^ 3 ;

criterion_1 = imregionalmax(H);
criterion_2 = ( H > theta_corn * max(max(max(H))) );
criterion = criterion_1 & criterion_2;

% Cutoff Edge Points
[x, y, z] = size(criterion);
criterion(1, :, :) = 0;
criterion(x, :, :) = 0;
criterion(:, 1, :) = 0;
criterion(:, y, :) = 0;

criterion(: , :, 200) = 0;

% Construct a Nx4 matrix of interest points
N = 600;
H = im2double(H);
H = min(criterion, H);
H_reshaped = reshape(H, numel(H), 1, 1);
[~, index] = sort(H_reshaped,'descend');
temp = index(1 : N);
[a, b, c] = ind2sub(size(H), temp);
temp1 = ones(size(a, 1), 1);
points = [b, a, sigma * temp1, c];


end

