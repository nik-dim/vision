function desc = HOF( I, pointsOfInterest, box, nbins, n, m )
% HOF computes the Histogram of Optical Flow  of  the video I using the
% Lucas-Kanade algorithm in the neighborhood specified by the 
% pointsOfInterest (found by some detector)
% ---> Input Arguments:
%         I:        input video as a 3D matrix
%         pointsOfInterest:    interest points provided by some 3D detector
%         box:      size of neighborhood
%         nbins:    number of histogram bins
%         n:        x-dimension of grid
%         m:        y-dimension of grid
% ---> Output Arguments:
%         desc:     Histogram of Optical Flow 
%--------------------------------------------------------------------------
    rho = 5;
    epsilon = 0.03;
    
    desc = zeros(size(pointsOfInterest,1), n*m*nbins);
    for i = 1:size(pointsOfInterest,1)
        t = pointsOfInterest(i,4); % 4th element is time, i.e. frame number
        lim1 = max(pointsOfInterest(i,1)-box/2,1);
        lim2 = max(pointsOfInterest(i,2)-box/2,1);

        temp = I(:,:,t+1);   
        frameNew = imcrop(temp,[lim1, lim2, box+1,box+1]); 
        temp = I(:,:,t);  
        frameOld = imcrop(temp,[lim1, lim2, box+1,box+1]); 
        % lk = Lucas-Kanade algorithm
        [ Gx, Gy ] = lk(frameOld,frameNew, rho, epsilon, 0, 0);
        desc(i,:) = OrientationHistogram(Gx, Gy, nbins, [n m]);
    end
end

