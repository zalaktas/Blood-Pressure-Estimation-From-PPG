clear all
clc

load('dataset.mat');
load('PPGdatamatrix.mat');

%design filter
Fs = 1000;  % Sampling frequency in Hz
t = linspace(0,2.1,2100);


% Chebyshev-II filter parameters
Rp = 0.5;  % Passband ripple in dB
Rs = 10; % Stopband attenuation in dB
Fpass1 = 0.4;  % Lower cut-off frequency in Hz
Fpass2 = 12;    % Upper cut-off frequency in Hz

% Design the 4th-order Chebyshev-II filter
[n, Wn] = cheb2ord(Fpass1/(Fs/2), Fpass2/(Fs/2), Rp, Rs);
[b, a] = cheby2(n, Rs, Wn);

ppg_signal = zeros(size(PPGdata));
filtered_ppg = zeros(size(PPGdata));
for i = 1:length(PPGdata(:,1))
ppg_signal(i,:) = PPGdata(i,:);
% Apply the filter to the PPG signal
filtered_ppg(i,:) = filtfilt(b, a, ppg_signal(i,:));
end

%normalize
ppg_signal = (ppg_signal - min(ppg_signal,[],2))./(max(ppg_signal,[],2)-min(ppg_signal,[],2));
filtered_ppg = (filtered_ppg - min(filtered_ppg,[],2))./(max(filtered_ppg,[],2)-min(filtered_ppg,[],2));

% Plot the original and filtered PPG signals
ppgToPlot = 312;
figure;
subplot(2,1,1);
plot(t, ppg_signal(ppgToPlot,:));
title('Original PPG Signal');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(2,1,2);
plot(t, filtered_ppg(ppgToPlot,:));
title('Filtered PPG Signal');
xlabel('Time (s)');
ylabel('Amplitude');

feature_signal = filtered_ppg(ppgToPlot,:);
%find peak locations:
[pampl , plocs] = findpeaks(feature_signal,"MinPeakProminence",0.3);

%convert into seconds:
plocs = plocs/Fs;

hold on

TF = islocalmin(feature_signal,'MinSeparation',50,"MinProminence",0.3);
plot(t,feature_signal,t(TF),feature_signal(TF),'r*',plocs,pampl,'k*')

