function [ Lyy ] = yyIntegralImageBoxFilter( integralImage, Dyy  )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
n = length(Dyy);
w = 2 * floor(n/6) + 1;
h = 4 * floor(n/6) + 1;
[n, m] = size(integralImage);
Lyy_temp = zeros(n,m);
for x = 1:n
    for y = 1:m
        % {c,r,l}W = {center, right, left}Window
        cW_top_left     =   [min(n, max(0, x-floor(w/2)))   , min(m, max(0, y-floor(h/2)))] ;
        cW_bottom_right =   [min(n, max(0, x+floor(w/2)))   , min(m, max(0, y+floor(h/2)))] ;
        lW_top_left     =   [min(n, max(0, x-floor(w/2)-w)) , min(m, max(0, y-floor(h/2)))] ;
        lW_bottom_right =   [min(n, max(0, x-floor(w/2)-1)) , min(m, max(0, y+floor(h/2)))] ;
        rW_top_left     =   [min(n, max(0, x+floor(w/2)+1)) , min(m, max(0, y-floor(h/2)))] ;
        rW_bottom_right =   [min(n, max(0, x+floor(w/2)+w)) , min(m, max(0, y+floor(h/2)))] ;
        
        Lyy_temp(x,y) = computeBox(integralImage, lW_top_left, lW_bottom_right)- 2 * computeBox(integralImage, cW_top_left, cW_bottom_right)+ computeBox(integralImage, rW_top_left, rW_bottom_right);
    end
end
Lyy = Lyy_temp;

end