function [ points ] = Gabor_Detector_3D( video, sigma, taf, theta_corn )
%Gabor_Detector_3D is a function that finds the interest points
%(more precisely angles) in a video.
% ---> Input Arguments:
%         video:        input video as a 3D matrix
%         sigma:        scaling coefficient for 2D Gaussian Space Filter
%         taf:          time scale
%         theta_corn:   cut-off threshold
% ---> Output Arguments:
%         M: Binary     Video
%         points:       interest points as a Nx4 Matrix
%--------------------------------------------------------------------------

% Gaussian 2D Filter
space_window_size = 2 * ceil(3 * sigma) + 1 ;
G = fspecial('gaussian', [space_window_size, space_window_size], sigma);

% Gabor Filters
time_window = linspace(-2*taf, 2*taf, 2*taf + 1);
h_o(1,1,:) = - sin( 2 * pi * time_window * 4 / taf ) .* exp ( - time_window .^ 2 / ( 2 * taf ^ 2) );
h_e(1,1,:) = - cos( 2 * pi * time_window * 4 / taf ) .* exp ( - time_window .^ 2 / ( 2 * taf ^ 2) );

% L1 normalization
h_o(1,1,:) = h_o(1,1,:) / sum( abs( h_o(1,1,:) ) );
h_e(1,1,:) = h_e(1,1,:) / sum( abs( h_e(1,1,:) ) );

% Gaussian normalization
h_o_normalized = convn( G, h_o );
h_e_normalized = convn( G, h_e );

% Gabor filters' Energy
f1 = imfilter (video, h_o_normalized, 'symmetric');
f2 = imfilter (video, h_e_normalized, 'symmetric');
H = f1 .^ 2 + f2 .^ 2;

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

