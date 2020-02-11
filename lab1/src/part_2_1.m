%% 2.1.1
%We compute the matrices J_1, J_2, J_3 which are needed in order to
%implement the Harris-Stephens method

I_0 = imread('material\sunflowers18.png');
I = rgb2gray(I_0);

figure()
imshow(I_0);
%parameters
sigma = 2;
r = 2.5;
k = 0.05;
theta_corn = 0.000005;
s = 1.5;
N = 4;

%Computation of J_1, J_2 and J_3
n_s =  ceil(3 * sigma) * 2 + 1;
n_r = ceil(3 * r) * 2 + 1;

G_s = fspecial('gaussian', n_s, sigma);
G_r = fspecial('gaussian', n_r, r);

I_s = imfilter(double(I), G_s);

[I_x, I_y] = gradient(I_s);

temp1 = I_x .* I_x;
temp2 = I_x .* I_y;
temp3 = I_y .* I_y;

J_1 = imfilter(temp1, G_r);
J_2 = imfilter(temp2, G_r);
J_3 = imfilter(temp3, G_r);

%% 2.1.2
%We now calculate the eigenvalues of the tensor J

l_plus = (J_1 + J_3 + sqrt((J_1 - J_3) .^ 2 + 4 * J_2 .^ 2))/2;
l_minus = (J_1 + J_3 - sqrt((J_1 - J_3) .^ 2 + 4 * J_2 .^ 2))/2;

figure()
imshow(l_plus);
title('+');

figure()
imshow(l_minus);
title('-');
%% 2.1.3
%Now we are going to calculate the matrix R and then we will find which of
%its elements fulfil conditions 1 and 2

R = l_minus .* l_plus - k * (l_plus + l_minus) .^ 2;

B_sq = strel('disk', n_s);
Cond1 = ( R == imdilate(R, B_sq) );

max_R = max(R(:));
Cond2 = ( R >= theta_corn * max_R );

criterion = Cond1 & Cond2;
[m , n] = size(criterion);
input_array = [];

for i = 1:m
    for j = 1:n
        if criterion(i, j) == 1
            new_row = [j i sigma];
            input_array = [input_array; new_row];
        end
    end
end

figure()
interest_points_visualization(I_0, input_array);




