function [BoF_tr, BoF_ts] = myBoVW(data_train, data_test)
% MYBVOW returns the Bag of (Visual) Words model. 
% By default the kmeans clustering algorithm uses k=500 clusters.
 
    % concantenate all train set descriptors into a vector of
    % characteristics regardless of their class
    TrainSetDescriptors = cell2mat(data_train'); 
    
    % select (randomly) half the rows of the training dataset
    % https://www.mathworks.com/matlabcentral/answers/17659-how-to-select-random-rows-from-a-matrix
    rows_rand = randperm(size(TrainSetDescriptors,1));
    selectedRows = TrainSetDescriptors(rows_rand(1:ceil(size(TrainSetDescriptors,1)/2)),:);
    
    % kmeans clustering algorithm. By default k = 500. The algorithm
    % returns k cluster centroid locations C. it is only used in the
    % training data set
    k = 500;
    [~, C] = kmeans(selectedRows, k);
    
    % cellfun: apply the helperBoVW to each cell in cell array. This
    % function implements 3.2.3(b,c)
    temp__ = cellfun(@(x) helperBoVW(x,C),data_train,'UniformOutput',false);
    BoF_tr = cell2mat(temp__)';

    temp__ = cellfun(@(x) helperBoVW(x,C),data_test,'UniformOutput',false);
    BoF_ts = cell2mat(temp__)'; 
end

