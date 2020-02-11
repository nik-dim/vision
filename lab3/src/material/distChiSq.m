function D = distChiSq(X,Y)

% as required in pdist
% X : 1 x d
% Y : n x d 

num = bsxfun(@minus,Y,X).^2;
den = bsxfun(@plus,Y,X)+eps;

D = .5*sum(num./den,2)';