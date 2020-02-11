function output = HessianDetector( image, sigma, thetaBlob )

% create image
n = 2 * ceil(3 * sigma) + 1;
G = fspecial('gaussian', n, sigma);
I_sigma = imfilter(image, G, 'symmetric');
% 2.3.1
[Lx, Ly] = gradient(double(I_sigma));
[Lxx, Lxy] = gradient(Lx);
[Lyx, Lyy] = gradient(Ly); % there is actually no need to compute Gxy because Gxy=Gyx
Hessian = [Lxx Lxy ; Lyx Lyy];

% 2.3.2
R = (Lxx .* Lyy) - (Lyx .* Lxy);
B_sq = strel('disk', n);
Cond1 = (R == imdilate(R, B_sq) );
grad = gradient(double(I_sigma));
max_R = max(R(:));
Cond2 = ( R >= thetaBlob * max_R );
criterion =  Cond1 & Cond2;

padding = 0;
output = findInterestPoints( criterion, sigma, padding);
end

