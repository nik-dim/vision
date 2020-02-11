function [ Lxy ] = xyBoxFilter( integralImage, Dxy  )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
n = length(Dxy);
h = 2 * floor(n/6) + 1;
w = 2 * floor(n/6) + 1;
height = floor(h/2);
width = floor(w/2);
% {c,r,l}W = {center, right, left}Window
shift_w = -1-width;
shift_h = -1-height;
A =   imtranslate(integralImage,[-width+shift_w,-height+shift_h]) ;
B =   imtranslate(integralImage,[+width+shift_w,-height+shift_h]) ;
C =   imtranslate(integralImage,[-width+shift_w,+height+shift_h]) ;
D =   imtranslate(integralImage,[+width+shift_w,+height+shift_h]) ;
S1 = D + A - B - C;
 
shift_w = -1-width;
shift_h = +1+height;
A =   imtranslate(integralImage,[-width+shift_w,-height+shift_h]) ;
B =   imtranslate(integralImage,[+width+shift_w,-height+shift_h]) ;
C =   imtranslate(integralImage,[-width+shift_w,+height+shift_h]) ;
D =   imtranslate(integralImage,[+width+shift_w,+height+shift_h]) ;
S2 = D + A - B - C;
 
shift_w = +1+width;
shift_h = -1-height;
A =   imtranslate(integralImage,[-width+shift_w,-height+shift_h]) ;
B =   imtranslate(integralImage,[+width+shift_w,-height+shift_h]) ;
C =   imtranslate(integralImage,[-width+shift_w,+height+shift_h]) ;
D =   imtranslate(integralImage,[+width+shift_w,+height+shift_h]) ;
S3 = D + A - B - C;
 
shift_w = +1+width;
shift_h = +1+height;
A =   imtranslate(integralImage,[-width+shift_w,-height+shift_h]) ;
B =   imtranslate(integralImage,[+width+shift_w,-height+shift_h]) ;
C =   imtranslate(integralImage,[-width+shift_w,+height+shift_h]) ;
D =   imtranslate(integralImage,[+width+shift_w,+height+shift_h]) ;
S4 = D + A - B - C;
 

Lxy = S1 + S4 - S2 - S3;


end

