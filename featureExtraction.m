clear all
clc
load('dataset.mat');
load('filteredPPG.mat');
filtered_ppg(263,:) = filtered_ppg(262,:); %fix bad reading 
filtered_ppg(576,:) = filtered_ppg(575,:); %fix bad reading 

Fs = 1000;  % Sampling frequency in Hz
t = linspace(0,2.1,2100);

ST = zeros(length(filtered_ppg(:,1)),1);
DT = zeros(length(filtered_ppg(:,1)),1);
halfPW = zeros(length(filtered_ppg(:,1)),1);
two3rdsPW = zeros(length(filtered_ppg(:,1)),1);

for k = 1:length(filtered_ppg(:,1))
    ppgToPlot =k;
    % plot(t, filtered_ppg(ppgToPlot,:));
    % title('Filtered PPG Signal');
    % xlabel('Time (s)');
    % ylabel('Amplitude');
    
    feature_signal = filtered_ppg(ppgToPlot,:);
    
    %find peak locations:
    [pampl , plocs] = findpeaks(feature_signal,"MinPeakProminence",0.1);
    %convert into seconds:
    plocs = plocs/Fs;
    
    %find local minimums
    TF = islocalmin(feature_signal,'MinSeparation',50,"MinProminence",0.1);
    %convert into seconds
    mlocs = t(TF);
    
    %plot peaks and valleys
    % hold on
    % plot(t,feature_signal,mlocs,feature_signal(TF),'r*',plocs,pampl,'k*')
    
    %calculate the mean systolic upstroke time (ST) and diastolic time (DT)
    [ST(k) ,DT(k)] = STDTofPPG(mlocs,plocs);
    
    %calculate mean %50 pulse width
    [halfPW(k)] = mean(nonzeros(PWofPPG(feature_signal,0.5)));
    %calculate mean %66 pulse width
    [two3rdsPW(k)] = mean(nonzeros(PWofPPG(feature_signal,0.66)));
end

IntraSubjectST = meanfeatures(ST)';
IntraSubjectDT = meanfeatures(DT)';
IntraSubjectHalfPW = meanfeatures(halfPW)';
IntraSubjectTwo3rdsPW = meanfeatures(two3rdsPW)';

featureTable = addvars(PPGBPdataset, IntraSubjectST, IntraSubjectDT, ...
  IntraSubjectHalfPW, IntraSubjectTwo3rdsPW,  'NewVariableNames', ...
  {'IntraSubjectST', 'IntraSubjectDT', 'IntraSubjectHalfPW' ,'IntraSubjectTwo3rdsPW'});

%omit NaN
featureTable([7,11,23,30,41,54,81,83,99,103,116,173,175],:) = [];

close all;
