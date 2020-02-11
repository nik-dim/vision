function [ output] = computeBox( integralImage, top_left, bottom_right )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
x0 = top_left(1);
y0 = top_left(2);
x1 = bottom_right(1);
y1 = bottom_right(2);

if (x1==0 || y1==0)
    S1 = 0;
else
    S1 = integralImage(x1,y1);
end
if (x0==0 || y0==0) 
    S2 = 0;
else
    S2 = integralImage(x0,y0);
end
if (x0==0 || y1==0) 
    S3 = 0;
else
    S3 = integralImage(x0,y1);
end
if (x1==0 || y0==0) 
    S4 = 0;
else
    S4 = integralImage(x1,y0);
end

output = S1 + S2 - S3 - S4; 
end

