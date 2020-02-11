function output = fd( I, mu, R )
%FD (Face Detection) returns a bounding box that contains the face  

imageYCbCr = rgb2ycbcr(I);
threshold = 0.3;
temp = imageYCbCr(:,:,2);
Cb = temp(:);
temp = imageYCbCr(:,:,3);
Cr = temp(:);
X = [Cb Cr];
Pdf = mvnpdf(X, mu, R);
Pdf = Pdf / max(Pdf);
t = reshape(Pdf, size(temp));
% imshow(t)
% imwrite(t,'output/GaussSkin.png');            % to show the image
% produced using the skinsamples.mat
Pdf = (Pdf > threshold);
P = reshape(Pdf, size(temp));
% imshow(P);
n_opening = 3;
n_closing = 15;
B_opening = strel('rectangle', [n_opening,n_opening]);
B_closing = strel('rectangle', [n_closing,n_closing]);

P = imopen(P, B_opening);
P = imclose(P, B_closing);
% imshow(P);
test = regionprops('table',P, 'Area', 'Centroid', 'MajorAxisLength', 'MinorAxisLength');
[~, id] = max(vertcat(test.Area));      % find maximum Area
center = test.Centroid;
minorAxis = ceil(test{id, 'MinorAxisLength'}); 
majorAxis = ceil(test{id, 'MajorAxisLength'}); 
origin_x = ceil(center(id,1) - minorAxis/2);
origin_y = ceil(center(id,2) - majorAxis/2);
output = [origin_x, origin_y, minorAxis, majorAxis];
end

