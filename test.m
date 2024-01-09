clear all
clc
load('dataset.mat');
load('filteredPPG.mat');

Fs = 1000;  % Sampling frequency in Hz
t = linspace(0,2.1,2100);


ppgToPlot =263;
plot(t, filtered_ppg(ppgToPlot,:));
title('Filtered PPG Signal');
xlabel('Time (s)');
ylabel('Amplitude');

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
hold on
plot(t,feature_signal,mlocs,feature_signal(TF),'r*',plocs,pampl,'k*')

%calculate the mean systolic upstroke time (ST) and diastolic time (DT)
[ST ,DT] = STDTofPPG(mlocs,plocs);

%calculate mean %50 pulse width
[halfPW] = mean(nonzeros(PWofPPG(feature_signal,0.5)));
%calculate mean %66 pulse width
[two3rdsPW] = mean(nonzeros(PWofPPG(feature_signal,0.66)));


