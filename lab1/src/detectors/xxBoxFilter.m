function [ Lxx ] = xxBoxFilter( integralImage, Dxx  )
n = length(Dxx);
h = 4 * floor(n/6) + 1;
w = 2 * floor(n/6) + 1;
height = floor(h/2);
width = floor(w/2);

A =   imtranslate(integralImage,[-width,-height]) ;
B =   imtranslate(integralImage,[+width,-height]) ;
C =   imtranslate(integralImage,[-width,+height]) ;
D =   imtranslate(integralImage,[+width,+height]) ;
S2 = D + A - B - C;
shift = 0;    

A =   imtranslate(integralImage,[-width-w-shift,-height]) ;
B =   imtranslate(integralImage,[+width-w-shift,-height]) ;
C =   imtranslate(integralImage,[-width-w-shift,+height]) ;
D =   imtranslate(integralImage,[+width-w-shift,+height]) ;
S1 = D + A - B - C;

A =   imtranslate(integralImage,[-width+w+shift,-height]) ;
B =   imtranslate(integralImage,[+width+w+shift,-height]) ;
C =   imtranslate(integralImage,[-width+w+shift,+height]) ;
D =   imtranslate(integralImage,[+width+w+shift,+height]) ;
S3 = D + A - B - C;

Lxx = S1 - 2 * S2 + S3;


end

