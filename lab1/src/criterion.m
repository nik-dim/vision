function [ C ] = criterion( D , T )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
temp = D & T;
PrT_D = sum(temp(:)) / sum(T(:));
PrD_T = sum(temp(:)) / sum(D(:));

C = (PrT_D + PrD_T) / 2;
end

