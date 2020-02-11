function output = HessianDetectorMultiScale( image, sigma_0, thetaBlob, N )
%HessianDetectorMultiScale outputs the blobs of an image as a matrix where
%each row is a different point. Each row consists of the coordinates(x,y)
%and the scale(sigma) in which the blob is identified. 
% Inputs: 
%   1. greyscale image 
%   2. scale sigma_0 (base). (scale parameter s=1.5 by default)
%   3. thetaBlob
%   4. N: number of scales
s = 1.5;
for i = 1:N
    if i == 1
        sigma(1) = sigma_0;
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

output = findInterestPointsMulti(criterion, sigma , LoG, 0);

end

