function [ output , PSNR ] = I_noise( image, sigma )
%I_noise takes an image without noise and applies gaussian noise with mean
%= 0 and standrard deviation = sigma. It also shows the result. It returns a normalized image with noise

temp = imnoise(image, 'gaussian', 0, sigma);

% normalization
output = im2double(temp); 

I_20_max = max(output(:));
I_20_min = min(output(:));
PSNR = 20*log10((I_20_max - I_20_min)/sigma);

figure();
imshow(temp);
title(['PSNR = ',num2str(PSNR), ' dB']);

set(gcf,'color','w');
temp = getframe(gcf);
imwrite(temp.cdata, [ 'output/ImageWithNoise_PSNR=',num2str(PSNR),'.png']);

end

