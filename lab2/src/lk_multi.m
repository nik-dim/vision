function [ d_x, d_y ] = lk_multi(I1, I2, rho, epsilon, scale)


if scale == 0 
    [ d_x, d_y ] = lk(I1, I2, rho, epsilon, 0, 0);
else
    % Gaussian filtering to avoid aliasing in upsampling
    G_r = fspecial('gaussian', 3, rho);
    faceOld = imresize(imfilter(I1, G_r, 'symmetric'),0.5);
    faceNew = imresize(imfilter(I2, G_r, 'symmetric') ,0.5);
    % use recursion to move up in scale and 
    % obtain initial estimation for this scale
    [ dx0, dy0 ] = lk_multi(faceOld, faceNew, rho, epsilon, scale-1);
    % resize to the size of the bounding box 
    % so that LK can be computed in Matlab
    % This is almost equivalent to imresize(dx0, 2)
    dx = imresize(dx0,size(I1));
    dy = imresize(dy0,size(I1));
    % Use estimation from higher scales
    % as initial estimation in this scale
    [ d_x, d_y ] = lk(I1, I2, rho, epsilon, 2*dx, 2*dy);
end

end

