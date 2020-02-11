clear all;
close all;
clc;
%% add paths to video files and 
addpath('./material');
addpath('./material/samples/boxing');
addpath('./material/samples/running');
addpath('./material/samples/walking');
%% Read Videos
videos = {
    'boxing/person16_boxing_d4_uncomp'
    'boxing/person21_boxing_d1_uncomp' 
    'boxing/person25_boxing_d4_uncomp'
    'walking/person07_walking_d2_uncomp'
    'walking/person14_walking_d2_uncomp'
    'walking/person20_walking_d3_uncomp'
    'running/person09_running_d1_uncomp'
    'running/person15_running_d1_uncomp'
    'running/person23_running_d3_uncomp'
  };

clusters = [];
k = 60;     % for kmeans
%% parts 1 & 2

for i = 1:length(videos)
    str = videos{i};
    I = im2double(readVideo([str,'.avi'], 200, 0));

    % PART 1
    % find points of interest
    % Valid Detectors: Harris, Gabor
    pointsOfInterest = computeDetector(I,'Harris');
%     ___examples___:
%     pointsOfInterest = computeDetector(I,'Harris','sigma',1.5,'tau',3,'k',0.0005,'integSigma',1.5);
%     pointsOfInterest = computeDetector(I,'Gabor','sigma',1.5,'tau',3);
%     showDetection(I, pointsOfInterest);
    % PART 2
    % compute descriptor in the neighborhood of each point of interest.
    % Valid Descriptors: HOG, HOF, HOGHOF
    histogram = computeDescriptor(I, pointsOfInterest, 'HOGHOF');
%     ___examples___:
%     histogram = computeDescriptor(I, pointsOfInterest, 'HOF','nbins',9,'scale',1.5);
%     histogram = computeDescriptor(I, pointsOfInterest, 'HOG');
    features{i} = histogram;

    % Clustering
    [~, C] = kmeans(histogram, k);
    clusters = vertcat(clusters, C); 
end

%% Part 3
% compute the Bag of Visual Words representation for each video
for i = 1:length(videos)
    feat = features{i};
    for j = 1:size(feat, 1) 
        frequencies(i,j) = eucliddist(feat(j,:), clusters) ;
    end
    temp = histc(frequencies(i,:), 1 : k*9) ;
    temp = temp / norm(temp,1) ;
    BoVW(i,:) = temp ;
end
% compute dendrogram using chiSquared distance
Z = linkage(BoVW,'average',{@distChiSq});
dendrogram(Z)

% %% alternate method
% D = pdist(BoVW,@distChiSq);
% T = linkage(D,'average');
% dendrogram(T)