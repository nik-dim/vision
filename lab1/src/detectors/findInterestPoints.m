function output = findInterestPoints( criterion, sigma, padding)
%show_interest_points Summary of this function goes here
%   Detailed explanation goes here

[x, y] = size(criterion);
temp = []; % to be used as a list
% in order to eliminate artificial edges we do not consider blobs in the
% outer 10 pixels of the image
for i = 1+padding:x-padding
    for j = 1+padding:y-padding
        if criterion(i,j) == 1
            new_row = [j i sigma]; % is this right???????????????????????????
            temp = [ temp; new_row];            
        end
    end
end
output = temp;

end



