function output  = findInterestPointsMulti( criterion, sigma , LoG, padding )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

N = length(sigma);
[x, y, ~] = size(criterion);
temp = []; % to be used as a list
for i = 1+padding:x-padding
    for j = 1+padding:y-padding
        for k = 1:N
            if criterion(i,j,k) > 0
                flag = 0;
                switch k
                    case 1
                        flag = sigma(1) * (LoG(i,j,1) > LoG(i,j,2));
                    case N
                        flag = sigma(N) * (LoG(i,j,N) > LoG(i,j,N-1));
                    otherwise
                        flag = sigma(k) * ((LoG(i,j,k) > LoG(i,j,k-1)) && (LoG(i,j,k) > LoG(i,j,k+1)));
                end  
                if flag > 0
                    new_row = [j i flag]; % is this right???????????????????????????
                    temp = [ temp; new_row]; 
                end        
            end
        end
    end
end
output = temp;

end

