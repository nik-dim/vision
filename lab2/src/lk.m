function [ d_x, d_y ] = lk( I1, I2, rho, epsilon, dx0, dy0 )
numberOfIterations = 10;
for i = 1:numberOfIterations
    % create a 2d grid 
    [x0, y0] = meshgrid(1:size(I2,2), 1:size(I2,1));
    I_interpolated = interp2(I1, x0+dx0, y0+dy0,'linear',0); 
    clear I_0 I_1 im_0 im_1 


    %%% EQUATION 6 (slightly different notation)
    [A1, A2] = gradient(I1);
    [x0, y0] = meshgrid(1:size(I2,2), 1:size(I2,1));
    Dx_interpolated = interp2(A1, x0+dx0, y0+dy0,'linear',0); 

    [x0, y0] = meshgrid(1:size(I2,2), 1:size(I2,1));
    Dy_interpolated = interp2(A2, x0+dx0, y0+dy0,'linear',0); 


    %%% EQUATION 7
    E = I2 - I_interpolated;
    
    %%% EQUATION 5
    n_r = ceil(3 *rho) * 2 + 1;
    G_r = fspecial('gaussian', n_r, rho);

    a = imfilter(Dx_interpolated .^ 2, G_r, 'symmetric') + epsilon;
    b = imfilter(Dx_interpolated .* Dx_interpolated, G_r, 'symmetric');
    c = b;
    d = imfilter(Dy_interpolated .^ 2, G_r, 'symmetric') + epsilon;

    den = a.*d - b.*c;


    e1 = imfilter(Dx_interpolated .* E, G_r, 'symmetric');
    e2 = imfilter(Dy_interpolated .* E, G_r, 'symmetric');

    u1 = (d.*e1 - b.*e2) ./ den;
    u2 = (-c.*e1 + a.*e2) ./ den;

    %%% EQUATION 4

    dx0 = u1 + dx0;
    dy0 = u2 + dy0;
end
d_x = dx0;
d_y = dy0;


% n = 2;
% flag = 0;
% 
% while flag == 0
%     % create a 2d grid 
%     [x0, y0] = meshgrid(1:size(I2,2), 1:size(I2,1));
%     I_interpolated = interp2(I1, x0+dx0, y0+dy0,'linear',0); 
%     clear I_0 I_1 im_0 im_1 
% 
% 
%     %%% EQUATION 6 (slightly different notation)
%     [A1, A2] = gradient(I1);
%     [x0, y0] = meshgrid(1:size(I2,2), 1:size(I2,1));
%     Dx_interpolated = interp2(A1, x0+dx0, y0+dy0,'linear',0); 
% 
%     [x0, y0] = meshgrid(1:size(I2,2), 1:size(I2,1));
%     Dy_interpolated = interp2(A2, x0+dx0, y0+dy0,'linear',0); 
% 
% 
%     %%% EQUATION 7
%     E = I2 - I_interpolated;
%     
%     %%% EQUATION 5
%     n_r = ceil(3 *rho) * 2 + 1;
%     G_r = fspecial('gaussian', n_r, rho);
% 
%     a = imfilter(Dx_interpolated .^ 2, G_r, 'symmetric') + epsilon;
%     b = imfilter(Dx_interpolated .* Dx_interpolated, G_r, 'symmetric');
%     c = b;
%     d = imfilter(Dy_interpolated .^ 2, G_r, 'symmetric') + epsilon;
% 
%     den = a.*d - b.*c;
% 
% 
%     e1 = imfilter(Dx_interpolated .* E, G_r, 'symmetric');
%     e2 = imfilter(Dy_interpolated .* E, G_r, 'symmetric');
% 
%     u1 = (d.*e1 - b.*e2) ./ den;
%     u2 = (-c.*e1 + a.*e2) ./ den;
% 
%     %%% EQUATION 4
% 
%     dx0 = u1 + dx0;
%     dy0 = u2 + dy0;
%     
%     crit = sqrt(u1.^2 + u2.^2);
%     if (crit < 10^(-n))
%         flag = 1;
%     end
% end
% d_x = dx0;
% d_y = dy0;

end

