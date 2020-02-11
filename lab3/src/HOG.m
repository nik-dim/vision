function desc = HOG( I, pointsOfInterest, box, nbins, n, m )
% HOG computes the Histogram of Oriented Gradients of  the video I in the
% neighborhood specified by the pointsOfInterest (found by some detector)
% ---> Input Arguments:
%         I:        input video as a 3D matrix
%         pointsOfInterest:    interest points provided by some 3D detector
%         box:      size of neighborhood
%         nbins:    number of histogram bins
%         n:        x-dimension of grid
%         m:        y-dimension of grid
% ---> Output Arguments:
%         desc:     Histogram of Oriented Gradients
%--------------------------------------------------------------------------
    desc = zeros(size(pointsOfInterest,1), n*m*nbins);
    for i = 1:size(pointsOfInterest,1)
        t = pointsOfInterest(i,4); % 4th element is time, i.e. frame number
        frame = I(:,:,t);   
        lim1 = max(pointsOfInterest(i,1)-box/2,1);
        lim2 = max(pointsOfInterest(i,2)-box/2,1);
        frameCropped = imcrop(frame,[lim1, lim2, box+1,box+1]); 
        [ Gx, Gy ] = imgradientxy(frameCropped);
        desc(i,:) = OrientationHistogram(Gx, Gy, nbins, [n m]);
    end
end