clear; clc;
addpath(genpath('libsvm-3.17'));
addpath(genpath('../detectors'));
addpath(genpath('../descriptors'));
%% Feature Extraction 3.2.1
% add here your detector/descriptor functions i.e.
detector_func = @(I)  HessianDetectorMultiScale(I, 2, 0.2, 4);
descriptor_func = @(I,points) featuresSURF(I,points);

features = FeatureExtraction(detector_func,descriptor_func);

%% Image Classification
parfor k=1:5
    %% Split train and test set 3.2.2
    [data_train,label_train,data_test,label_test] = createTrainTest(features,k);
    %% Bag of Words 3.2.3
    [BOF_tr,BOF_ts] = myBoVW(data_train,data_test);
    %% SVM classification 3.2.4
    [percent(k),KMea] = svm(BOF_tr,label_train,BOF_ts,label_test);
    fprintf('Classification Accuracy: %f %%\n',percent(k)*100);
end
fprintf('Average Classification Accuracy: %f %%\n',mean(percent)*100);