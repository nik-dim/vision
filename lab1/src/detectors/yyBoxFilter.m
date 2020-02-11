function [ Lyy ] = yyBoxFilter( integralImage, Dyy  )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
n = length(Dyy);
h = 2 * floor(n/6) + 1;
w = 4 * floor(n/6) + 1;
height = floor(h/2);
width = floor(w/2);
% {c,r,l}W = {center, right, left}Window
A =   imtranslate(integralImage,[-width,-height]) ;
B =   imtranslate(integralImage,[+width,-height]) ;
C =   imtranslate(integralImage,[-width,+height]) ;
D =   imtranslate(integralImage,[+width,+height]) ;
S2 = D + A - B - C;
    
A =   imtranslate(integralImage,[-width,-height-h]) ;
B =   imtranslate(integralImage,[+width,-height-h]) ;
C =   imtranslate(integralImage,[-width,+height-h]) ;
D =   imtranslate(integralImage,[+width,+height-h]) ;
S1 = D + A - B - C;

A =   imtranslate(integralImage,[-width,-height+h]) ;
B =   imtranslate(integralImage,[+width,-height+h]) ;
C =   imtranslate(integralImage,[-width,+height+h]) ;
D =   imtranslate(integralImage,[+width,+height+h]) ;
S3 = D + A - B - C;

Lyy = S1 - 2 * S2 + S3;


end

