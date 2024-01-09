clear all
clc

load('dataset.mat');
load('PPGdatamatrix.mat');


Fs = 1000;  % Sampling frequency in Hz
t = linspace(0,2.1,2100);

% Apply moving average filter to the PPG signal
ppg_signal = PPGdata;
filtered_ppg = zeros(size(ppg_signal));
for i = 2 : length(ppg_signal)-1
filtered_ppg(:,i) = (ppg_signal(:,i-1) + ppg_signal(:,i) + ppg_signal(:,i+1))/3;
end
filtered_ppg(:,1) = filtered_ppg(:,2);
filtered_ppg(length(filtered_ppg)-1) = filtered_ppg(length(filtered_ppg)-2);
filtered_ppg(length(filtered_ppg)) = filtered_ppg(length(filtered_ppg)-2);

%detrend
filtered_ppg = detrend(filtered_ppg,1);

%normalize
%filtered_ppg = (filtered_ppg - min(filtered_ppg,[],2))./(max(filtered_ppg,[],2)-min(filtered_ppg,[],2));

%standartize
filtered_ppg = (filtered_ppg - mean(filtered_ppg,2))./std(filtered_ppg,0,2);


% Plot the original and filtered PPG signals
ppgToPlot = 43;
%find BPM
%find peak locations:
[~, plocs] = findpeaks(filtered_ppg(ppgToPlot,:),"MinPeakProminence",0.35,"MinPeakDistance",500);

%find local minimums
TF = islocalmin(filtered_ppg(ppgToPlot,:),'MinSeparation',500,"MinProminence",0.5);
mlocs = find(TF==1); %idx

%mampl = filtered_ppg(ppgToPlot,mlocs);
%correct the min max points
[plocs,pampl] = newMax(mlocs,plocs,filtered_ppg(ppgToPlot,:));
[mlocs,mampl] = newMin(mlocs,plocs,filtered_ppg(ppgToPlot,:));

%convert into seconds:
plocs = plocs/Fs;
%convert into seconds
mlocs = mlocs/Fs;

%RtoR intervals:
R2R = diff(plocs);

%average heartrate:
avBPM = 60/mean(R2R);

plot(t,filtered_ppg(ppgToPlot,:),mlocs,mampl,'r*',plocs,pampl,'k*')
