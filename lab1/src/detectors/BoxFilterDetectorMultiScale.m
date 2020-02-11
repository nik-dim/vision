function output = BoxFilterDetectorMultiScale( image, sigma_0, thetaBlob, N  )
% this Box filter detector implements the faster approach 
% translating the image to the desired "coordinates" and using matrix
% operations


integral_image = cumsum(cumsum(image')');

s = 1.5;
for i = 1:N
    if i == 1
        sigma(1) = sigma_0;
    else
        sigma(i) =  sigma(i-1) * s; 
    end
    n(i) = 2 * ceil(3 * sigma(i)) + 1; 
    [ Dxx, Dyy, Dxy ] = create_boxFlters( sigma(i) );

    Lxx = xxBoxFilter(integral_image, Dxx);
    Lyy = yyBoxFilter(integral_image, Dyy);
    Lxy = xyBoxFilter(integral_image, Dxy);
    LoG(:,:,i) = (sigma(i)^2) * abs( Lxx + Lyy );
    R = Lxx .* Lyy - (0.9*Lxy).^2;
    %-------------------------
    padding = n(i)/2;
    R = imtranslate(R, [padding, padding]);
    R = imtranslate(R, -[padding, padding]);
    %-------------------------
    B_sq(i) = strel('disk', n(i));
    Cond1 = (R == imdilate(R, B_sq(i)) );
    max_R = max(R(:));
    Cond2 = ( R >= thetaBlob * max_R );
    criterion(:,:,i) =  Cond1 & Cond2;
end
padding = 20; %pixels
output = findInterestPointsMulti(criterion, sigma , LoG, padding);

end

