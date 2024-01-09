clear all
clc
load featureTableSys.mat
data = featureTable;

% Cross varidation (train: 70%, test: 30%)
cv = cvpartition(size(data,1),'HoldOut',0.3);
idx = cv.test;

% Separate to training and test data
dataTrain = data(~idx,:);
dataTest  = data(idx,:);

svmMdl = fitrsvm(dataTrain,"SystolicBloodPressuremmHg","OptimizeHyperparameters","all");
yPred = predict(svmMdl,dataTest);
RMSE = sqrt(mean((yPred - dataTest.SystolicBloodPressuremmHg).^2,"omitnan"));
percentageError = 100*RMSE/mean(dataTest.SystolicBloodPressuremmHg,"omitnan");

%15.55 error
%RMSE 19.97

plot(dataTest.SystolicBloodPressuremmHg,yPred,'r*');
xlabel("True Systolic BP Values");
ylabel("Predicted Systolic BP values");
title("Cross validation with %30 test samples")
hold on
plot(80:180,80:180);