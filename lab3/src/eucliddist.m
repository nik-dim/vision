function idx = eucliddist(feature, ClustersCenter)
% EUCLIDDIST finds the cluster center closer to a feature using the
% euclidean distance
    distances = [];
    for i = 1:size(ClustersCenter,1)
        D = sum((feature - ClustersCenter(i,:)).^2);
        distances = [distances D];
    end
    [~,idx] = min(distances) ;
end