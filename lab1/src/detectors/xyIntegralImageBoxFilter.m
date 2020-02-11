function [ Lxy ] = xyIntegralImageBoxFilter( integralImage, Dxy  )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
n = length(Dxy);

xy = 2 * floor(n/6) + 1;
padding = floor(xy/3);
pad = floor(padding/2);
[n, m] = size(integralImage);
Lxy_temp = zeros(n,m);
for x = 1:n
    for y = 1:m
        % {ru,rd,lu,ld}W = {right up, right down, left up, left down}Window
        lu_top_left     =   [min(n, max(0, x-pad-xy))   ,   min(m, max(0, y-pad-xy))] ;
        lu_bottom_right =   [min(n, max(0, x-pad-1))    ,   min(m, max(0, y-pad-1))] ;
        ld_top_left     =   [min(n, max(0, x-pad-xy))   ,   min(m, max(0, y+pad+1))] ;
        ld_bottom_right =   [min(n, max(0, x-pad-1))    ,   min(m, max(0, y+pad+xy))] ;

        ru_top_left     =   [min(n, max(0, x+pad+1))    ,   min(m, max(0, y-pad-xy))] ;
        ru_bottom_right =   [min(n, max(0, x+pad+xy))   ,   min(m, max(0, y-pad-1))] ;
        rd_top_left     =   [min(n, max(0, x+pad+1))    ,   min(m, max(0, y+pad+1))] ;
        rd_bottom_right =   [min(n, max(0, x+pad+xy))   ,   min(m, max(0, y+pad+xy))] ;
        
        S1 = computeBox(integralImage, lu_top_left, lu_bottom_right);
        S2 = computeBox(integralImage, ld_top_left, ld_bottom_right);
        S3 = computeBox(integralImage, ru_top_left, ru_bottom_right);
        S4 = computeBox(integralImage, rd_top_left, rd_bottom_right);

        Lxy_temp(x,y) = S1 - S2 - S3 + S4;
    end
end
Lxy = Lxy_temp;

end

