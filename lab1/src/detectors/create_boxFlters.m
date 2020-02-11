function [ Dxx, Dyy, Dxy ] = create_boxFlters( sigma )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
n = 2 * ceil(3 * sigma) + 1;
y = 2 * floor(n/6) + 1;
x = 4 * floor(n/6) + 1;
padding = (3*min(x,y) - max(x,y))/2;
temp = integralKernel([1+padding,1,x,y ; 1+padding,y+1,x,y ; 1+padding,2*y+1,x,y ; x+padding+1,1,padding,padding], [1, -2, 1,0]);
Dyy = temp.Coefficients;
Dxx = Dyy';

xy = 2 * floor(n/6) + 1;
padding = (3*min(x,y) - 2*xy)/3;  
padding_in = floor(padding);
padding_out = ceil(padding);
temp = integralKernel([1+padding_out,1+padding_out,xy,xy ; 1+padding_out+padding_in+xy,1+padding_out,xy,xy ; 1+padding_out,1+padding_out+padding_in+xy,xy,xy ;1+padding_out+padding_in+xy,1+padding_out+padding_in+xy,xy,xy ; 1+padding_out+padding_in+2*xy,1+padding_out+padding_in+2*xy, padding_out, padding_out], [1,-1,-1,1,0]);
Dxy = temp.Coefficients;
end

