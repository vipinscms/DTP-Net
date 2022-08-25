clc;
close all;

trainingData = readtable("Train_WO_Aug.csv");
X_Train = trainingData.Name;
validData = readtable("Valid.csv");
testingData = readtable("Test_K1.csv");
%% 
% 

Y_Train = trainingData.Value;
Y_Valid = validData.Value;
Y_Test = testingData.Value;
fn = X_Train{1};
size(imread(fn));
%imshow(imread(fn));
%% 
% 

%augmenter = imageDataAugmenter('RandRotation',[-20,20], 'RandXTranslation',[-5 5],'RandYTranslation',[-5 5]);
%% 
% 

imds = imageDatastore(X_Train(1:9));
montage(imds)
trainds = augmentedImageDatastore([224 224],trainingData);
validds = augmentedImageDatastore([224 224],validData);
testds = augmentedImageDatastore([224 224],testingData);
%% 
% 

layers = [
    imageInputLayer([224 224 1])
    convolution2dLayer(3,8,'Padding','same')
    convolution2dLayer(3,8,'Padding','same')
    batchNormalizationLayer
    reluLayer
    maxPooling2dLayer(2,'Stride',2)
    convolution2dLayer(3,16,'Padding','same')
    convolution2dLayer(3,16,'Padding','same')
    batchNormalizationLayer
    reluLayer
    maxPooling2dLayer(2,'Stride',2)
    convolution2dLayer(3,32,'Padding','same')
    convolution2dLayer(3,32,'Padding','same')
    batchNormalizationLayer
    reluLayer
    maxPooling2dLayer(2,'Stride',2)
    convolution2dLayer(3,64,'Padding','same')
    convolution2dLayer(3,64,'Padding','same')
    batchNormalizationLayer
    reluLayer
    maxPooling2dLayer(2,'Stride',2)
    convolution2dLayer(3,128,'Padding','same')
    convolution2dLayer(3,128,'Padding','same')
    batchNormalizationLayer
    reluLayer
    convolution2dLayer(3,256,'Padding','same')
    batchNormalizationLayer
    reluLayer
    dropoutLayer(0.2)
    fullyConnectedLayer(1)
    regressionLayer];
%% 
% 


options = trainingOptions("sgdm","MaxEpochs",150,"InitialLearnRate",0.0001,'Shuffle','every-epoch', ...
    'MiniBatchSize',64)


% options = trainingOptions("sgdm","MaxEpochs",500,"InitialLearnRate",0.0001, ...
%     'ValidationData',{validds,YValid},'ValidationFrequency',10, ...
%     'MiniBatchSize',8,'Plots','training-progress')


% miniBatchSize  = 128;
% validationFrequency = floor(numel(YTrain)/miniBatchSize);
% options = trainingOptions('sgdm', ...
%     'MiniBatchSize',miniBatchSize, ...
%     'MaxEpochs',30, ...
%     'InitialLearnRate',1e-3, ...
%     'LearnRateSchedule','piecewise', ...
%     'LearnRateDropFactor',0.1, ...
%     'LearnRateDropPeriod',20, ...
%     'Shuffle','every-epoch', ...
%     'ValidationData',{testds,YTrain}, ...
%     'ValidationFrequency',validationFrequency, ...
%     'Plots','training-progress', ...
%     'Verbose',false);
%% 
% 

ccnet = trainNetwork(trainds,layers,options)
%% 
% 

Train_Predicted = predict(ccnet,trainds);
Test_Predicted = predict(ccnet,testds);

Train_predictionError = Y_Train - Train_Predicted;
Test_predictionError = Y_Test - Test_Predicted;
%% 
% 

Train_Pred_mae = errperf(Y_Train,Train_Predicted,'mae')
Train_Pred_mse = errperf(Y_Train,Train_Predicted,'mse')
Train_Pred_rmse = errperf(Y_Train,Train_Predicted,'rmse')
Train_Pred_mare = errperf(Y_Train,Train_Predicted,'mare')
Train_Pred_msre = errperf(Y_Train,Train_Predicted,'msre')
Train_Pred_rmsre = errperf(Y_Train,Train_Predicted,'rmsre')
Train_Pred_mape = errperf(Y_Train,Train_Predicted,'mape')
Train_Pred_mspe = errperf(Y_Train,Train_Predicted,'mspe')
Train_Pred_rmspe = errperf(Y_Train,Train_Predicted,'rmspe')
%% 
% 

Test_Pred_mae = errperf(Y_Test,Test_Predicted,'mae')
Test_Pred_mse = errperf(Y_Test,Test_Predicted,'mse')
Test_Pred_rmse = errperf(Y_Test,Test_Predicted,'rmse')
Test_Pred_mare = errperf(Y_Test,Test_Predicted,'mare')
Test_Pred_msre = errperf(Y_Test,Test_Predicted,'msre')
Test_Pred_rmsre = errperf(Y_Test,Test_Predicted,'rmsre')
Test_Pred_mape = errperf(Y_Test,Test_Predicted,'mape')
Testn_Pred_mspe = errperf(Y_Test,Test_Predicted,'mspe')
Test_Pred_rmspe = errperf(Y_Test,Test_Predicted,'rmspe')
%% 
% 

figure
scatter(Y_Test,Test_Predicted,'+')
xlabel("True Values")
ylabel("Predicted Values")

hold on
plot([0 200], [0 200],'r--')
%% 
% 
% 
% 

figure
scatter(Y_Train,Train_Predicted,'+')
xlabel("True Values")
ylabel("Predicted Values")

hold on
plot([0 200], [0 200],'r--')

%ccnet.Layers
%% 
%