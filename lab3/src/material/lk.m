function [ d_x, d_y ] = lk(I1, I2, rho, epsilon, dx0, dy0  )
% LUKAS KANADE ALGORITHM: SOURCE CODE TAKEN FROM LAB 2
numberOfIterations = 5;
% create a 2d grid 
[x0, y0] = meshgrid(1:size(I2,2), 1:size(I2,1));
for i = 1:numberOfIterations

    %%% EQUATION 6 (slightly different notation)
    I_interpolated = interp2(I1, x0+dx0, y0+dy0,'linear',0);
    [A1, A2] = gradient(I1);
    Dx_interpolated = interp2(A1, x0+dx0, y0+dy0,'linear',0); 
    Dy_interpolated = interp2(A2, x0+dx0, y0+dy0,'linear',0); 

    %%% EQUATION 7
    E = I2 - I_interpolated;

    %%% EQUATION 5
    n_r = ceil(3 *rho) * 2 + 1;
    G_r = fspecial('gaussian', n_r, rho);

    a = imfilter(Dx_interpolated .^ 2, G_r, 'symmetric') + epsilon;
    b = imfilter(Dx_interpolated .* Dx_interpolated, G_r, 'symmetric');
    c = b;          % not needed obviously
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

end

