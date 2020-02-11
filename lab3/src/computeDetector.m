function [ pointsOfInterest ] = computeDetector(I, varargin )
% COMPUTEDETECTOR checks the validity of the arguments andr eturns the 
% detector specified by the input arguments. 
% ---> REQUIRED Input Arguments:
%         I:            video
%         detector:    'Harris', 'Gabor'
% ---> OPTIONAL Input Arguments:
%         sigma:    scaling coefficient for 2D Gaussian Space Filter
%         tau:      scaling coefficient for 1D Gaussian Time Filter
%         integSigma:  integral coefficient for 2D Gaussian Integral Filter
%         integTau:    integral coefficient for 1D Gaussian Integral Filter
%         k:            Harris  method coefficient
%         thetaGabor:   cut-off threshold Gabor
%         thetaHarris:  cut-off threshold Harris
% ---> Output Arguments:
%         M:        Binary Video
%         points:   interest points as a Nx4 Matrix
%--------------------------------------------------------------------------

    % check validity of input parameters
    p = inputParser;
    validDetectors = {'Harris', 'Gabor'};
    checkDetector = @(x) any(validatestring(x,validDetectors));
    addRequired(p,'detector', checkDetector);

    defaultSigma = 1.5;
    addParameter(p,'sigma',defaultSigma, @isnumeric);
    defaultTau = 3;
    addParameter(p,'tau',defaultTau, @isnumeric);
    default_k = 0.0005;
    addParameter(p,'k',default_k, @isnumeric);
    defaultInteg_sigma = 1.5;
    addParameter(p,'integSigma',defaultInteg_sigma, @isnumeric);
    defaultInteg_tau = 3;
    addParameter(p,'integTau',defaultInteg_tau, @isnumeric);
    default_theta_cornHarris = 0;
    addParameter(p,'thetaHarris',default_theta_cornHarris, @isnumeric);
    default_theta_cornGabor = 0.01;
    addParameter(p,'thetaGabor',default_theta_cornGabor, @isnumeric);
    
    parse(p,varargin{:})
    
    % parse parameters
    sigma = p.Results.sigma;
    tau = p.Results.tau;
    k = p.Results.k;
    thetaGabor = p.Results.thetaGabor;
    thetaHarris = p.Results.thetaHarris;
    integSigma = p.Results.integSigma;
    integTau = p.Results.integTau;
    
    % compute result
    if (strcmp(p.Results.detector,'Harris'))
        pointsOfInterest = Harris_Detector_3D(I, sigma, tau, integSigma, integTau, k, thetaHarris);
    else
        pointsOfInterest = Gabor_Detector_3D(I, sigma, tau, thetaGabor);
    end
end

