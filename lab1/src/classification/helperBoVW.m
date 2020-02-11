function  binCounts = helperBoVW( features, C )
% helperBoVW returns the normalized (L2 norm) histograms of visual words frequency
% appearance.

    % find the minimum euclidean distance of the descriptor and the
    % clusterig centroids C
    distances = eucliddist(features,C);
    [~,idx] = min(distances,[],2);
    
    % create the histograms
    binCounts = histc(idx,1:size(C,1));
    % normalize the output
    binCounts = binCounts ./ norm(binCounts,2);

end