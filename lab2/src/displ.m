function [ displ_x, displ_y ] = displ( d_x , d_y )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

threshold = 0.4;          % HOW TO CHOOSE THRESHOLD????
d = d_x.^2 + d_y.^2;
mask = (d > threshold);
temp = d_x .* mask;
dx_mean = sum(temp(:)) / sum(mask(:));
temp = d_y .* mask;
dy_mean = sum(temp(:)) / sum(mask(:));
displ_x = round(dx_mean);
displ_y = round(dy_mean);


end

