clear all
clc
load featureTableDia.mat
data = featureTable;

% Cross varidation (train: 70%, test: 30%)
cv = cvpartition(size(data,1),'HoldOut',0.3);
idx = cv.test;

% Separate to training and test data
dataTrain = data(~idx,:);
dataTest  = data(idx,:);

svmMdl = fitrsvm(dataTrain,"DiastolicBloodPressuremmHg","KFold",5);
yPred = predict(svmMdl,dataTest);
RMSE = sqrt(mean((yPred - dataTest.DiastolicBloodPressuremmHg).^2,"omitnan"));
percentageError = 100*RMSE/mean(dataTest.DiastolicBloodPressuremmHg,"omitnan");


plot(dataTest.DiastolicBloodPressuremmHg,yPred,'r*');
xlabel("True Diasystolic BP Values");
ylabel("Predicted Diasystolic BP values");
title("Cross validation with %30 test samples")
hold on
plot(50:100,50:100);

%percentage error = %14.38
%RMSE = 10.34
