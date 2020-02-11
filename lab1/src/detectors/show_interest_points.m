function [ output ] = show_interest_points( imageRGB, criterion, sigma, padding)

[x, y, ~] = size(imageRGB);
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
figure()
interest_points_visualization(imageRGB, temp);

set(gcf,'color','w');
output = getframe(gcf);

end

