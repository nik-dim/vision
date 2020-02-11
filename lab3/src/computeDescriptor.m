function [ histogram ] = computeDescriptor(I, pointsOfInterest, varargin )
% COMPUTEDESCRIPTOR checks the validity of the arguments and returns the 
% descriptor specified by the input arguments. 
% ---> REQUIRED Input Arguments:
%         I:        video
%         pointsOfInterest: interest points provided by computeDetector
%         descriptor:    'HOG', 'HOF','HOGHOF'
% ---> OPTIONAL Input Arguments:
%         scale:    used for the boxsize=4*scale
%         nbins:    number of histogram bins
%         n:        x-dimension of grid
%         m:        y-dimension of grid
% ---> Output Arguments:
%         histogram:  Histogram of specfied descriptor of video I in the
%         neigborhood specified by pointsOfInterest (given by
%         computeDetector)
%--------------------------------------------------------------------------


    % check validity of input parameters
    p = inputParser;
    
    validDescriptors = {'HOG', 'HOF','HOGHOF'};
    checkDescriptor = @(x) any(validatestring(x,validDescriptors));
    addRequired(p,'descriptor', checkDescriptor);
    default_scale = 1.5;
    addParameter(p,'scale',default_scale, @isnumeric);
    default_nbins = 9;
    addParameter(p,'nbins',default_nbins, @isnumeric);
    default_n = 3;
    addParameter(p,'n',default_n, @isnumeric);
    default_m = 3;  % square area by default
    addParameter(p,'m',default_m, @isnumeric);
    parse(p,varargin{:})
    
    % parse parameters
    box_size = 4 * p.Results.scale;
    nbins = p.Results.nbins;
    n = p.Results.n;
    m = p.Results.m;
    % compute result
    if (strcmp(p.Results.descriptor,'HOG'))
        histogram = HOG(I,pointsOfInterest, box_size,nbins,n,m);
    elseif (strcmp(p.Results.descriptor,'HOF'))
        histogram = HOF(I,pointsOfInterest, box_size,nbins,n,m);
    else
        hist1 = HOF(I,pointsOfInterest,box_size,nbins,n,m);
        hist2 = HOG(I,pointsOfInterest,box_size,nbins,n,m);
        histogram = horzcat(hist1, hist2);
    end
end

