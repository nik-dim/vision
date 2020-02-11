function [ Lxx ] = xxIntegralImageBoxFilter( integralImage, Dxx  )

n = length(Dxx);
h = 2 * floor(n/6) + 1;
w = 4 * floor(n/6) + 1;
[n, m] = size(integralImage);
Lxx_temp = zeros(n,m);
for x = 1:n
    for y = 1:m
        % {c,r,l}W = {center, right, left}Window
        cW_top_left     =   [min(n, max(0, x-floor(w/2))) , min(m, max(0, y-floor(h/2)))] ;
        cW_bottom_right =   [min(n, max(0, x+floor(w/2))) , min(m, max(0, y+floor(h/2)))] ;
        lW_top_left     =   [min(n, max(0, x-floor(w/2))) , min(m, max(0, y-floor(h/2)-h))] ;
        lW_bottom_right =   [min(n, max(0, x+floor(w/2))) , min(m, max(0, y-floor(h/2)-1))] ;
        rW_top_left     =   [min(n, max(0, x-floor(w/2))) , min(m, max(0, y+floor(h/2)+1))] ;
        rW_bottom_right =   [min(n, max(0, x+floor(w/2))) , min(m, max(0, y+floor(h/2)+h))] ;
        
        S1 = computeBox(integralImage, lW_top_left, lW_bottom_right);
        S2 = computeBox(integralImage, cW_top_left, cW_bottom_right);
        S3 = computeBox(integralImage, rW_top_left, rW_bottom_right);
        Lxx_temp(x,y) = S1 - 2 * S2 + S3;
    end
end
Lxx = Lxx_temp;

end

